#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_sign.h"
#include "print.h"

// sign_keypair
#define jade_sign_keypair_STACK_MAX_SIZE NAMESPACE_LC(keypair_STACK_MAX_SIZE)
#define jade_sign_keypair_STACK_ALIGNMENT NAMESPACE_LC(keypair_STACK_ALIGNMENT)

// sign
#define jade_sign_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_sign_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// sign_open
#define jade_sign_open_STACK_MAX_SIZE NAMESPACE_LC(open_STACK_MAX_SIZE)
#define jade_sign_open_STACK_ALIGNMENT NAMESPACE_LC(open_STACK_ALIGNMENT)

// sign_keypair
#ifndef jade_sign_keypair_STACK_MAX_SIZE
#error "jade_sign_keypair_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_sign_keypair_STACK_ALIGNMENT
#error "jade_sign_keypair_STACK_ALIGNMENT is not defined."
#endif

// sign
#ifndef jade_sign_STACK_MAX_SIZE
#error "jade_sign_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_sign_STACK_ALIGNMENT
#error "jade_sign_STACK_ALIGNMENT is not defined."
#endif

// sign_open
#ifndef jade_sign_open_STACK_MAX_SIZE
#error "jade_sign_open_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_sign_open_STACK_ALIGNMENT
#error "jade_sign_open_STACK_ALIGNMENT is not defined."
#endif

#include "clearstack-amd64.h"

#ifndef TESTS
#define TESTS 1
#endif

#ifndef MAXINBYTES
#define MAXINBYTES 1024
#endif

int main(void)
{
  int r;
  uint8_t public_key[JADE_SIGN_PUBLICKEYBYTES];
  uint8_t secret_key[JADE_SIGN_SECRETKEYBYTES];

  uint8_t message_1[MAXINBYTES];
  uint8_t message_2[MAXINBYTES];
  uint64_t message_length;

  uint8_t signed_message[JADE_SIGN_BYTES + MAXINBYTES];
  uint64_t signed_message_length;

    cs_declare(rsp0, ca0, ra0, jade_sign_keypair_STACK_MAX_SIZE);
    cs_declare(rsp1, ca1, ra1, jade_sign_STACK_MAX_SIZE);
    cs_declare(rsp2, ca2, ra2, jade_sign_open_STACK_MAX_SIZE);

  for(size_t tests=0; tests < TESTS; tests++)
  {
    for(size_t length=0; length < MAXINBYTES; length++)
    {
      randombytes(message_1, length);

        cs_init(rsp0, jade_sign_keypair_STACK_MAX_SIZE, jade_sign_keypair_STACK_ALIGNMENT, ca0)
      r = jade_sign_keypair(public_key, secret_key);
        cs_recover_and_check(rsp0, ra0, ca0, jade_sign_keypair_STACK_MAX_SIZE)
        assert(r == 0);

      //
        cs_init(rsp1, jade_sign_STACK_MAX_SIZE, jade_sign_STACK_ALIGNMENT, ca1)
      r = jade_sign(signed_message, &signed_message_length, message_1, length, secret_key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_sign_STACK_MAX_SIZE)
        assert(r == 0);
        assert(signed_message_length <= (JADE_SIGN_BYTES + length));

      //
        cs_init(rsp2, jade_sign_open_STACK_MAX_SIZE, jade_sign_open_STACK_ALIGNMENT, ca2)
      r = jade_sign_open(message_2, &message_length, signed_message, signed_message_length, public_key);
        cs_recover_and_check(rsp2, ra2, ca2, jade_sign_open_STACK_MAX_SIZE)
        assert(r == 0);
        for(size_t i=0; i<length; i++)
        { assert(message_1[i] == message_2[i]); }
    }
  }

  print_info(JADE_SIGN_ALGNAME, JADE_SIGN_ARCH, JADE_SIGN_IMPL);

  printf("jade_sign_keypair_STACK_MAX_SIZE: %d\n",   jade_sign_keypair_STACK_MAX_SIZE);
  printf("jade_sign_keypair_STACK_ALIGNMENT: %d\n",  jade_sign_keypair_STACK_ALIGNMENT);
  printf("jade_sign_STACK_MAX_SIZE: %d\n",           jade_sign_STACK_MAX_SIZE);
  printf("jade_sign_STACK_ALIGNMENT: %d\n",          jade_sign_STACK_ALIGNMENT);
  printf("jade_sign_open_STACK_MAX_SIZE: %d\n",      jade_sign_open_STACK_MAX_SIZE);
  printf("jade_sign_open_STACK_ALIGNMENT: %d\n",     jade_sign_open_STACK_ALIGNMENT);

  return 0;
}

