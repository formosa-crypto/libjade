#include "api.h"
#include "randombytes.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_BYTES NAMESPACE(BYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)
#define crypto_hash JADE_NAMESPACE_LC

//

#ifndef LOOPS
#define LOOPS 3
#endif

#ifndef MININBYTES
#define MININBYTES 32
#endif

#ifndef MAXINBYTES
#define MAXINBYTES 16384
#endif

#ifndef TIMINGS
#define TIMINGS 256
#endif

#define OP 1

//

#include "cpucycles.c"
#include "increment.c"

#define inc_in inc_32

#define PRINTBENCH_2 1
#include "printbench.c"
#undef PRINTBENCH_2

//

int main(int argc, char**argv)
{
  int loop, r, i;
  char *op_str[] = {xstr(crypto_hash,.csv)};
  uint8_t out[MAXINBYTES], in[MAXINBYTES];
  size_t len;
  uint64_t cycles[TIMINGS];
  uint64_t* results[OP][LOOPS];

  alloc_2(results, size_inc_32(MININBYTES,MAXINBYTES));

  for(loop = 0; loop < LOOPS; loop++)
  { for (len = MININBYTES, r = 0; len <= MAXINBYTES; len += inc_in(len), r += 1)
    { for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_hash(out, in, len); }
      results[0][loop][r] = cpucycles_median(cycles, TIMINGS);
    }
  }

  cpucycles_fprintf_2(argc, results, op_str);
  free_2(results);

  return 0;
}

