#include "api.h"
#include "randombytes.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_xof JADE_NAMESPACE_LC

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

#ifndef MINOUTBYTES
#define MINOUTBYTES 32
#endif

#ifndef MAXOUTBYTES
#define MAXOUTBYTES 256
#endif

#ifndef TIMINGS
#define TIMINGS 32
#endif

#define OP 1

//

#include "cpucycles.c"
#include "increment.c"

#define inc_in  inc_32
#define inc_out inc_4

#define PRINTBENCH_3 1
#include "printbench.c"
#undef PRINTBENCH_3

//

int main(int argc, char**argv)
{
  int loop, r0, r1, i;
  char *op_str[] = {xstr(crypto_xof,.csv)};
  uint8_t out[MAXOUTBYTES], in[MAXINBYTES];
  size_t outsize, outlen, inlen;
  uint64_t cycles[TIMINGS];
  uint64_t** results[OP][LOOPS];

  outsize = size_inc_4(MINOUTBYTES,MAXOUTBYTES);
  alloc_3(results, outsize, size_inc_32(MININBYTES,MAXINBYTES));

  for(loop = 0; loop < LOOPS; loop++)
  { for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen += inc_out(outlen), r0 += 1)
    { for (inlen = MININBYTES, r1 = 0; inlen <= MAXINBYTES; inlen += inc_in(inlen), r1 += 1)
      { for (i = 0; i < TIMINGS; i++)
        { cycles[i] = cpucycles();
          crypto_xof(out, outlen, in, inlen); }
        results[0][loop][r0][r1] = cpucycles_median(cycles, TIMINGS);
      }
    }
  }

  cpucycles_fprintf_3(argc, results, op_str);
  free_3(results, outsize);

  return 0;
}

