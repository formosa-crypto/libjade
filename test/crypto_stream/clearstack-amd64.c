#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_stream.h"
#include "print.h"

// stream
#define jade_stream_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_stream_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// stream_xor
#define jade_stream_xor_STACK_MAX_SIZE NAMESPACE_LC(xor_STACK_MAX_SIZE)
#define jade_stream_xor_STACK_ALIGNMENT NAMESPACE_LC(xor_STACK_ALIGNMENT)

// stream
#ifndef jade_stream_STACK_MAX_SIZE
#error "jade_stream_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_stream_STACK_ALIGNMENT
#error "jade_stream_STACK_ALIGNMENT is not defined."
#endif

// stream_xor
#ifndef jade_stream_xor_STACK_MAX_SIZE
#error "jade_stream_xor_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_stream_xor_STACK_ALIGNMENT
#error "jade_stream_xor_STACK_ALIGNMENT is not defined."
#endif

#include "clearstack-amd64.h"

#ifndef TESTS
#define TESTS 10
#endif

#ifndef MAXINBYTES
#define MAXINBYTES 1024
#endif

int main(void)
{
  int r;

  uint8_t plaintext_1[MAXINBYTES];
  uint8_t plaintext_2[MAXINBYTES];
  uint8_t ciphertext[MAXINBYTES];
  uint8_t stream[MAXINBYTES];
  uint8_t _nonce[JADE_STREAM_NONCEBYTES];
  uint8_t _key[JADE_STREAM_KEYBYTES];
  uint8_t* nonce = _nonce;
  uint8_t* key = _key;

    cs_declare(rsp0, ca0, ra0, jade_stream_STACK_MAX_SIZE);
    cs_declare(rsp1, ca1, ra1, jade_stream_xor_STACK_MAX_SIZE);

  for(size_t tests=0; tests < TESTS; tests++)
  {
    for (size_t length=0; length <= MAXINBYTES; length++)
    {
      randombytes(nonce, JADE_STREAM_NONCEBYTES);
      randombytes(key, JADE_STREAM_KEYBYTES);
      randombytes(plaintext_1, length);


        cs_init(rsp0, jade_stream_STACK_MAX_SIZE, jade_stream_STACK_ALIGNMENT, ca0)
      r = jade_stream(stream, length, nonce, key);
        cs_recover_and_check(rsp0, ra0, ca0, jade_stream_STACK_MAX_SIZE)
        assert(r == 0);

        cs_init(rsp1, jade_stream_xor_STACK_MAX_SIZE, jade_stream_xor_STACK_ALIGNMENT, ca1)
      r = jade_stream_xor(ciphertext, plaintext_1, length, nonce, key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_stream_xor_STACK_MAX_SIZE)
        assert(r == 0);

        cs_init(rsp1, jade_stream_xor_STACK_MAX_SIZE, jade_stream_xor_STACK_ALIGNMENT, ca1)
      r = jade_stream_xor(plaintext_2, ciphertext, length, nonce, key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_stream_xor_STACK_MAX_SIZE)
        assert(r == 0);

        for(size_t i=0; i<length; i++)
        { assert(plaintext_1[i] == plaintext_2[i]);
          assert(ciphertext[i] == (plaintext_1[i] ^ stream[i]));
        }
    }
  }

  print_info(JADE_STREAM_ALGNAME, JADE_STREAM_ARCH, JADE_STREAM_IMPL);

  printf("jade_stream_STACK_MAX_SIZE: %d\n",  jade_stream_STACK_MAX_SIZE);
  printf("jade_stream_STACK_ALIGNMENT: %d\n", jade_stream_STACK_ALIGNMENT);
  printf("jade_stream_xor_STACK_MAX_SIZE: %d\n",  jade_stream_xor_STACK_MAX_SIZE);
  printf("jade_stream_xor_STACK_ALIGNMENT: %d\n", jade_stream_xor_STACK_ALIGNMENT);

  return r;
}

