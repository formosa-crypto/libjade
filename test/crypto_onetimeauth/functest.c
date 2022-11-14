#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_onetimeauth.h"

/*

int jade_onetimeauth(
 uint8_t *out,
 uint8_t *in,
 uint64_t inlen,
 uint8_t *key
);

int jade_onetimeauth_verify(
 uint8_t *h,
 uint8_t *in,
 uint64_t inlen,
 uint8_t *key
);

*/

#define MAXBYTES 32

int main(void)
{
  uint8_t ciphertext_1[MAXBYTES];
  uint8_t ciphertext_2[MAXBYTES];
  uint8_t stream_1[MAXBYTES];
  uint8_t plaintext_1[MAXBYTES];
  uint8_t plaintext_2[MAXBYTES];
  uint64_t length = 0;
  uint8_t nonce[JADE_STREAM_NONCEBYTES];
  uint8_t key[JADE_STREAM_KEYBYTES];
  uint64_t i;

  // Replace the initialization of the following arrays to
  // produce different results. The main purpose of this file
  // is to show how the exported Jasmin functions can be used.

  memset(ciphertext_1, 0, MAXBYTES);
  memset(ciphertext_2, 0, MAXBYTES);
  memset(stream_1,     0, MAXBYTES);
  memset(plaintext_1,  0, MAXBYTES);
  memset(plaintext_2,  0, MAXBYTES);
  memset(nonce,        0, JADE_STREAM_NONCEBYTES);
  memset(key,          0, JADE_STREAM_KEYBYTES);

  #ifndef NOPRINT
  print_info(JADE_STREAM_ALGNAME, JADE_STREAM_ARCH, JADE_STREAM_IMPL);
  print_str_u8("nonce", nonce, JADE_STREAM_NONCEBYTES);
  print_str_u8("key", key, JADE_STREAM_KEYBYTES);
  #endif

  //
  for(length=0; length <= MAXBYTES; length++)
  {
    //
    jade_stream(stream_1, length, nonce, key);

    // encrypt
    jade_stream_xor(ciphertext_1, plaintext_1, length, nonce, key);

    // decrypt
    jade_stream_xor(plaintext_2, ciphertext_1, length, nonce, key);

    #ifndef NOPRINT
    print_str_c_u8("plaintext", length, plaintext_1, length);
    print_str_c_u8("ciphertext", length, ciphertext_1, length);
    #endif

    // some checks
    for(i=0; i < length; i++)
    { ciphertext_2[i] = stream_1[i] ^ plaintext_1[i]; }

    assert(memcmp(plaintext_1, plaintext_2, length) == 0);
    assert(memcmp(ciphertext_1, ciphertext_2, length) == 0);
  }

  return 0;
}

