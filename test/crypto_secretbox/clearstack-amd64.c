#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_secretbox.h"
#include "print.h"

// secretbox
#define jade_secretbox_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_secretbox_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// secretbox_open
#define jade_secretbox_open_STACK_MAX_SIZE NAMESPACE_LC(open_STACK_MAX_SIZE)
#define jade_secretbox_open_STACK_ALIGNMENT NAMESPACE_LC(open_STACK_ALIGNMENT)

// secretbox
#ifndef jade_secretbox_STACK_MAX_SIZE
#error "jade_secretbox_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_secretbox_STACK_ALIGNMENT
#error "jade_secretbox_STACK_ALIGNMENT is not defined."
#endif

// secretbox_open
#ifndef jade_secretbox_open_STACK_MAX_SIZE
#error "jade_secretbox_open_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_secretbox_open_STACK_ALIGNMENT
#error "jade_secretbox_open_STACK_ALIGNMENT is not defined."
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
  uint8_t plaintext[MAXINBYTES];

  int r;
  uint8_t  ciphertext[JADE_SECRETBOX_ZEROBYTES + MAXINBYTES];
  uint8_t  plaintext_1[JADE_SECRETBOX_ZEROBYTES + MAXINBYTES];
  uint8_t  plaintext_2[JADE_SECRETBOX_ZEROBYTES + MAXINBYTES];
  uint8_t  _nonce[JADE_SECRETBOX_NONCEBYTES];
  uint8_t  _key[JADE_SECRETBOX_KEYBYTES];
  uint8_t* nonce = _nonce;
  uint8_t* key = _key;

    cs_declare(rsp0, ca0, ra0, jade_secretbox_STACK_MAX_SIZE);
    cs_declare(rsp1, ca1, ra1, jade_secretbox_open_STACK_MAX_SIZE);

  for(size_t tests=0; tests < TESTS; tests++)
  {
    for (size_t length=JADE_SECRETBOX_ZEROBYTES; length <= JADE_SECRETBOX_ZEROBYTES+MAXINBYTES; length++)
    {
      randombytes(nonce, JADE_SECRETBOX_NONCEBYTES);
      randombytes(key, JADE_SECRETBOX_KEYBYTES);
      randombytes(plaintext, length-JADE_SECRETBOX_ZEROBYTES);

      memset(plaintext_1, 0, JADE_SECRETBOX_ZEROBYTES);
      memcpy(&(plaintext_1[JADE_SECRETBOX_ZEROBYTES]), plaintext, length-JADE_SECRETBOX_ZEROBYTES);

        cs_init(rsp0, jade_secretbox_STACK_MAX_SIZE, jade_secretbox_STACK_ALIGNMENT, ca0)
      r = jade_secretbox(ciphertext, plaintext_1, length, nonce, key);
        cs_recover_and_check(rsp0, ra0, ca0, jade_secretbox_STACK_MAX_SIZE)

        assert(r == 0);
        for(int i=0; i<JADE_SECRETBOX_BOXZEROBYTES; i++)
        { assert(ciphertext[i] == 0); }

        cs_init(rsp1, jade_secretbox_open_STACK_MAX_SIZE, jade_secretbox_open_STACK_ALIGNMENT, ca1)
      r = jade_secretbox_open(plaintext_2, ciphertext, length, nonce, key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_secretbox_open_STACK_MAX_SIZE)

        assert(r == 0);
        for(size_t i=0; i<JADE_SECRETBOX_ZEROBYTES; i++)
        { assert(plaintext_2[i] == 0); }
        for(size_t i=0; i<length-JADE_SECRETBOX_ZEROBYTES; i++)
        { assert(plaintext[i] == plaintext_2[JADE_SECRETBOX_ZEROBYTES + i]); }

      // flip one bit of ciphertext so the verification fails
      if(length-JADE_SECRETBOX_ZEROBYTES != 0)
      {
        ciphertext[JADE_SECRETBOX_ZEROBYTES] ^= 1;
        cs_init(rsp1, jade_secretbox_open_STACK_MAX_SIZE, jade_secretbox_open_STACK_ALIGNMENT, ca1)
        r = jade_secretbox_open(plaintext_2, ciphertext, length, nonce, key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_secretbox_open_STACK_MAX_SIZE)
          assert(r == -1);
      }
    }
  }

  print_info(JADE_SECRETBOX_ALGNAME, JADE_SECRETBOX_ARCH, JADE_SECRETBOX_IMPL);

  printf("jade_secretbox_STACK_MAX_SIZE: %d\n",  jade_secretbox_STACK_MAX_SIZE);
  printf("jade_secretbox_STACK_ALIGNMENT: %d\n", jade_secretbox_STACK_ALIGNMENT);
  printf("jade_secretbox_open_STACK_MAX_SIZE: %d\n",  jade_secretbox_open_STACK_MAX_SIZE);
  printf("jade_secretbox_open_STACK_ALIGNMENT: %d\n", jade_secretbox_open_STACK_ALIGNMENT);

  return 0;
}

