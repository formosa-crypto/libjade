#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_xof.h"
#include "print.h"

// xof
#define jade_xof_STACK_MAX_SIZE NAMESPACE_LC(STACK_MAX_SIZE)
#define jade_xof_STACK_ALIGNMENT NAMESPACE_LC(STACK_ALIGNMENT)

// xof
#ifndef jade_xof_STACK_MAX_SIZE
#error "jade_xof_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_xof_STACK_ALIGNMENT
#error "jade_xof_STACK_ALIGNMENT is not defined."
#endif

#include "clearstack-amd64.h"

#ifndef TESTS
#define TESTS 10
#endif

#ifndef MAXINBYTES
#define MAXINBYTES 512
#endif

#ifndef MAXOUTBYTES
#define MAXOUTBYTES 64
#endif

int main(void)
{
  int r;

  uint8_t input[MAXINBYTES];
  uint8_t output[MAXOUTBYTES];

    cs_declare(rsp0, ca0, ra0, jade_xof_STACK_MAX_SIZE);


  for(size_t tests=0; tests < TESTS; tests++)
  {
    for (size_t outlength=0; outlength <= MAXOUTBYTES; outlength++)
    {
      for (size_t inlength=0; inlength <= MAXINBYTES; inlength++)
      {
          cs_init(rsp0, jade_xof_STACK_MAX_SIZE, jade_xof_STACK_ALIGNMENT, ca0)
        r = jade_xof(output, outlength, input, inlength);
          cs_recover_and_check(rsp0, ra0, ca0, jade_xof_STACK_MAX_SIZE)

          assert(r == 0);
      }
    }
  }

  print_info(JADE_XOF_ALGNAME, JADE_XOF_ARCH, JADE_XOF_IMPL);

  printf("jade_xof_STACK_MAX_SIZE: %d\n",  jade_xof_STACK_MAX_SIZE);
  printf("jade_xof_STACK_ALIGNMENT: %d\n", jade_xof_STACK_ALIGNMENT); 

  return 0;
}

