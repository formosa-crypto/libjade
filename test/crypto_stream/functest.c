#include "api.h"
#include "randombytes.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef NTESTS
#define NTESTS 5
#endif

#ifndef MAXTESTBYTES
#define MAXTESTBYTES (1024)
#endif

#define CL 8 // canary length
#define CHECK_C(f) \
  if (check_canary((f)) != 0) { \
      puts("check_canary : " #f " returned non-zero returncode"); \
      res = 1; \
      goto end; \
  }

const uint8_t canary[8] = {
    0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF
};

/* allocate a bit more for all keys and messages and
 * make sure it is not touched by the implementations.
 */
static void write_canary(uint8_t *d) {
    for (size_t i = 0; i < 8; i++) {
        d[i] = canary[i];
    }
}

static int check_canary(const uint8_t *d) {
    for (size_t i = 0; i < 8; i++) {
        if (d[i] != canary[i]) {
            return -1;
        }
    }
    return 0;
}

inline static void* malloc_s(size_t size) {
    void *ptr = malloc(size);
    if (ptr == NULL) {
        perror("Malloc failed!");
        exit(1);
    }
    return ptr;
}

// https://stackoverflow.com/a/1489985/1711232
#define PASTER(x, y) x##_##y
#define EVALUATOR(x, y) PASTER(x, y)
#define NAMESPACE(fun) EVALUATOR(JADE_NAMESPACE, fun)
#define NAMESPACE_LC(fun) EVALUATOR(JADE_NAMESPACE_LC, fun)

#define CRYPTO_KEYBYTES NAMESPACE(KEYBYTES)
#define CRYPTO_NONCEBYTES NAMESPACE(NONCEBYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_stream_xor NAMESPACE_LC(xor)
#define crypto_stream JADE_NAMESPACE_LC

#define RETURNS_ZERO(f)                           \
    if ((f) != 0) {                               \
        puts(#f " returned non-zero returncode"); \
        res = 1;                                  \
        goto end;                                 \
    }

// https://stackoverflow.com/a/55243651/248065
#define MY_TRUTHY_VALUE_X 1
#define CAT(x,y) CAT_(x,y)
#define CAT_(x,y) x##y
#define HAS_NAMESPACE(x) CAT(CAT(MY_TRUTHY_VALUE_,CAT(JADE_NAMESPACE,CAT(_,x))),X)

#if !HAS_NAMESPACE(API_H)
#error "namespace not properly defined for header guard"
#endif

static int test_crypto_stream_xor(void) {
    /*
     * This is most likely going to be aligned by the compiler.
     * 16 extra bytes for canary
     * 1 extra byte for unalignment
     */
    int res = 0;
    uint64_t length;
    uint8_t *ciphertext_aligned = malloc_s(MAXTESTBYTES + (CL*2) + 1);
    uint8_t *plaintext1_aligned = malloc_s(MAXTESTBYTES + (CL*2) + 1);
    uint8_t *plaintext2_aligned = malloc_s(MAXTESTBYTES + (CL*2) + 1);
    uint8_t *nonce_aligned = malloc_s(CRYPTO_NONCEBYTES + (CL*2) + 1);
    uint8_t *key_aligned = malloc_s(CRYPTO_KEYBYTES +(CL*2) + 1);


    /*
     * Make sure all pointers are odd.
     * This ensures that the implementation does not assume anything about the
     * data alignment. For example this would catch if an implementation
     * directly uses these pointers to load into vector registers using movdqa.
     */
    uint8_t *ciphertext = (uint8_t *) ((uintptr_t) ciphertext_aligned|(uintptr_t) 1);
    uint8_t *plaintext1 = (uint8_t *) ((uintptr_t) plaintext1_aligned|(uintptr_t) 1);
    uint8_t *plaintext2 = (uint8_t *) ((uintptr_t) plaintext2_aligned|(uintptr_t) 1);
    uint8_t *nonce = (uint8_t *) ((uintptr_t) nonce_aligned|(uintptr_t) 1);
    uint8_t *key = (uint8_t *) ((uintptr_t) key_aligned|(uintptr_t) 1);

    /*
     * Write 8 byte canary before and after the actual memory regions.
     * This is used to validate that the implementation does not assume
     * anything about the placement of data in memory
     * (e.g., assuming that the pk is always behind the sk)
     */

    for(length=0; length <= MAXTESTBYTES; length += 1)
    {
      write_canary(ciphertext);
      write_canary(ciphertext + length + CL);

      write_canary(plaintext1);
      randombytes(plaintext1+CL, length);
      write_canary(plaintext1 + length + CL);

      write_canary(plaintext2);
      write_canary(plaintext2 + length + CL);

      write_canary(nonce);
      randombytes(nonce+CL, CRYPTO_NONCEBYTES);
      write_canary(nonce + CRYPTO_NONCEBYTES + CL);

      write_canary(key);
      randombytes(key+CL, CRYPTO_KEYBYTES);
      write_canary(key + CRYPTO_KEYBYTES + CL);

      // crypto_stream
      RETURNS_ZERO(crypto_stream_xor(ciphertext+CL,
                                     plaintext1+CL,
                                     length,
                                     nonce+CL,
                                     key+CL));
        // check canary
        CHECK_C(ciphertext)
        CHECK_C(ciphertext+length+CL)
        CHECK_C(plaintext1)
        CHECK_C(plaintext1+length+CL)
        CHECK_C(nonce)
        CHECK_C(nonce+CRYPTO_NONCEBYTES+CL)
        CHECK_C(key)
        CHECK_C(key+CRYPTO_KEYBYTES+CL)

      // crypto_stream
      RETURNS_ZERO(crypto_stream_xor(plaintext2+CL,
                                     ciphertext+CL,
                                     length,
                                     nonce+CL,
                                     key+CL));

        // check canary
        CHECK_C(ciphertext)
        CHECK_C(ciphertext+length+CL)
        CHECK_C(plaintext2)
        CHECK_C(plaintext2+length+CL)
        CHECK_C(nonce)
        CHECK_C(nonce+CRYPTO_NONCEBYTES+CL)
        CHECK_C(key)
        CHECK_C(key+CRYPTO_KEYBYTES+CL)

      // check if plaintext2 is equal to plaintext1
      if ( memcmp(plaintext1,plaintext2,length) != 0)
      {
        printf("ERROR : functest : crypto_stream : plaintexts do not match \n");
        res = 1;
        goto end;
      }
    }

end:
    free(ciphertext_aligned);
    free(plaintext1_aligned);
    free(plaintext2_aligned);
    free(nonce_aligned);
    free(key_aligned);

    return res;
}


int main(void) {
    // Check if CRYPTO_ALGNAME is printable
    puts(CRYPTO_ALGNAME);

    int result = 0;
    result += test_crypto_stream_xor();

    if (result != 0) {
        puts("Errors occurred");
    }
    return result;
}
