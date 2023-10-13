#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_scalarmult.h"
#include "print.h"

// scalarmult
#define jade_scalarmult_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_scalarmult_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// scalarmult_base
#define jade_scalarmult_base_STACK_MAX_SIZE NAMESPACE_LC(base_STACK_MAX_SIZE)
#define jade_scalarmult_base_STACK_ALIGNMENT NAMESPACE_LC(base_STACK_ALIGNMENT)

// scalarmult
#ifndef jade_scalarmult_STACK_MAX_SIZE
#error "jade_scalarmult_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_scalarmult_STACK_ALIGNMENT
#error "jade_scalarmult_STACK_ALIGNMENT is not defined."
#endif

// scalarmult_base
#ifndef jade_scalarmult_base_STACK_MAX_SIZE
#error "jade_scalarmult_base_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_scalarmult_base_STACK_ALIGNMENT
#error "jade_scalarmult_base_STACK_ALIGNMENT is not defined."
#endif

#include "clearstack-amd64.h"

#ifndef TESTS
#define TESTS 10
#endif

int main(void)
{
  int r;
  uint8_t public_key_a[JADE_SCALARMULT_BYTES];
  uint8_t public_key_b[JADE_SCALARMULT_BYTES];

  uint8_t _secret_key_a[JADE_SCALARMULT_SCALARBYTES];
  uint8_t _secret_key_b[JADE_SCALARMULT_SCALARBYTES];
  uint8_t* secret_key_a = _secret_key_a;
  uint8_t* secret_key_b = _secret_key_b;

  uint8_t secret_a[JADE_SCALARMULT_BYTES];
  uint8_t secret_b[JADE_SCALARMULT_BYTES];

    cs_declare(rsp0, ca0, ra0, jade_scalarmult_base_STACK_MAX_SIZE);
    cs_declare(rsp1, ca1, ra1, jade_scalarmult_STACK_MAX_SIZE);

  for(size_t tests=0; tests < TESTS; tests++)
  {
    randombytes(secret_key_a, JADE_SCALARMULT_SCALARBYTES);
    randombytes(secret_key_b, JADE_SCALARMULT_SCALARBYTES);

      cs_init(rsp0, jade_scalarmult_base_STACK_MAX_SIZE, jade_scalarmult_base_STACK_ALIGNMENT, ca0)
    r = jade_scalarmult_base(public_key_a, secret_key_a);
      cs_recover_and_check(rsp0, ra0, ca0, jade_scalarmult_base_STACK_MAX_SIZE)
      assert(r == 0);

      cs_init(rsp0, jade_scalarmult_base_STACK_MAX_SIZE, jade_scalarmult_base_STACK_ALIGNMENT, ca0)
    r = jade_scalarmult_base(public_key_b, secret_key_b);
      cs_recover_and_check(rsp0, ra0, ca0, jade_scalarmult_base_STACK_MAX_SIZE)
      assert(r == 0);

      cs_init(rsp1, jade_scalarmult_STACK_MAX_SIZE, jade_scalarmult_STACK_ALIGNMENT, ca1)
    r = jade_scalarmult(secret_a, secret_key_a, public_key_b);
      cs_recover_and_check(rsp1, ra1, ca1, jade_scalarmult_STACK_MAX_SIZE)
      assert(r == 0);

      cs_init(rsp1, jade_scalarmult_STACK_MAX_SIZE, jade_scalarmult_STACK_ALIGNMENT, ca1)
    r = jade_scalarmult(secret_b, secret_key_b, public_key_a);
      cs_recover_and_check(rsp1, ra1, ca1, jade_scalarmult_STACK_MAX_SIZE)
      assert(r == 0);

      assert(memcmp(secret_a, secret_b, JADE_SCALARMULT_BYTES) == 0);
  }

  print_info(JADE_SCALARMULT_ALGNAME, JADE_SCALARMULT_ARCH, JADE_SCALARMULT_IMPL);

  printf("jade_scalarmult_STACK_MAX_SIZE: %d\n", jade_scalarmult_STACK_MAX_SIZE);
  printf("jade_scalarmult_STACK_ALIGNMENT: %d\n", jade_scalarmult_STACK_ALIGNMENT);
  printf("jade_scalarmult_base_STACK_MAX_SIZE: %d\n", jade_scalarmult_base_STACK_MAX_SIZE);
  printf("jade_scalarmult_base_STACK_ALIGNMENT: %d\n", jade_scalarmult_base_STACK_ALIGNMENT);

  return r;
}

