#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_onetimeauth.h"
#include "print.h"

// onetimeauth
#define jade_onetimeauth_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_onetimeauth_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// onetimeauth_verify
#define jade_onetimeauth_verify_STACK_MAX_SIZE NAMESPACE_LC(verify_STACK_MAX_SIZE)
#define jade_onetimeauth_verify_STACK_ALIGNMENT NAMESPACE_LC(verify_STACK_ALIGNMENT)

// onetimeauth
#ifndef jade_onetimeauth_STACK_MAX_SIZE
#error "jade_onetimeauth_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_onetimeauth_STACK_ALIGNMENT
#error "jade_onetimeauth_STACK_ALIGNMENT is not defined."
#endif

// onetimeauth_verify
#ifndef jade_onetimeauth_verify_STACK_MAX_SIZE
#error "jade_onetimeauth_verify_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_onetimeauth_verify_STACK_ALIGNMENT
#error "jade_onetimeauth_verify_STACK_ALIGNMENT is not defined."
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

  uint8_t mac[JADE_ONETIMEAUTH_BYTES];
  uint8_t input[MAXINBYTES];
  uint8_t _key[JADE_ONETIMEAUTH_KEYBYTES];
  uint8_t* key = _key;

    cs_declare(rsp0, ca0, ra0, jade_onetimeauth_STACK_MAX_SIZE);
    cs_declare(rsp1, ca1, ra1, jade_onetimeauth_verify_STACK_MAX_SIZE);

  for(size_t tests=0; tests < TESTS; tests++)
  {
    for (size_t length=0; length <= MAXINBYTES; length++)
    {
      randombytes(key, JADE_ONETIMEAUTH_KEYBYTES);
      randombytes(input, length);

        cs_init(rsp0, jade_onetimeauth_STACK_MAX_SIZE, jade_onetimeauth_STACK_ALIGNMENT, ca0)
      r = jade_onetimeauth(mac, input, sizeof(input), key);
        cs_recover_and_check(rsp0, ra0, ca0, jade_onetimeauth_STACK_MAX_SIZE)
        assert(r == 0);

        cs_init(rsp1, jade_onetimeauth_verify_STACK_MAX_SIZE, jade_onetimeauth_verify_STACK_ALIGNMENT, ca1)
      r = jade_onetimeauth_verify(mac, input, sizeof(input), key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_onetimeauth_verify_STACK_MAX_SIZE)
        assert(r == 0);

      //flip one bit of input so the verification fails
      input[0] ^= 0x1;
        cs_init(rsp1, jade_onetimeauth_verify_STACK_MAX_SIZE, jade_onetimeauth_verify_STACK_ALIGNMENT, ca1)
      r = jade_onetimeauth_verify(mac, input, sizeof(input), key);
        cs_recover_and_check(rsp1, ra1, ca1, jade_onetimeauth_verify_STACK_MAX_SIZE)
        assert(r == -1);
    }
  }

  print_info(JADE_ONETIMEAUTH_ALGNAME, JADE_ONETIMEAUTH_ARCH, JADE_ONETIMEAUTH_IMPL);

  printf("jade_onetimeauth_STACK_MAX_SIZE: %d\n",         jade_onetimeauth_STACK_MAX_SIZE);
  printf("jade_onetimeauth_STACK_ALIGNMENT: %d\n",        jade_onetimeauth_STACK_ALIGNMENT);
  printf("jade_onetimeauth_verify_STACK_MAX_SIZE: %d\n",  jade_onetimeauth_verify_STACK_MAX_SIZE);
  printf("jade_onetimeauth_verify_STACK_ALIGNMENT: %d\n", jade_onetimeauth_verify_STACK_ALIGNMENT);


  return 0;
}

