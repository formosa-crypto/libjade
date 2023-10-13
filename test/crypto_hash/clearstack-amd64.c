#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_hash.h"
#include "print.h"

// hash
#define jade_hash_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_hash_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// hash
#ifndef jade_hash_STACK_MAX_SIZE
#error "jade_hash_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_hash_STACK_ALIGNMENT
#error "jade_hash_STACK_ALIGNMENT is not defined."
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
  uint8_t hash[JADE_HASH_BYTES];
  uint8_t input[MAXINBYTES];

    cs_declare(rsp0, ca0, ra0, jade_hash_STACK_MAX_SIZE);


  for(size_t tests=0; tests < TESTS; tests++)
  {
    for (size_t length=0; length <= MAXINBYTES; length++)
    {
      randombytes(input, length);

        cs_init(rsp0, jade_hash_STACK_MAX_SIZE, jade_hash_STACK_ALIGNMENT, ca0)
      r = jade_hash(hash, input, sizeof(input));
        cs_recover_and_check(rsp0, ra0, ca0, jade_hash_STACK_MAX_SIZE)

      assert(r == 0);
    }
  }
  
  print_info(JADE_HASH_ALGNAME, JADE_HASH_ARCH, JADE_HASH_IMPL);

  printf("jade_hash_STACK_MAX_SIZE: %d\n",  jade_hash_STACK_MAX_SIZE);
  printf("jade_hash_STACK_ALIGNMENT: %d\n", jade_hash_STACK_ALIGNMENT);

  return r;
}

