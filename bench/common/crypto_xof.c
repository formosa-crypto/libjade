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

#define xstr(s,e) str(s)#e
#define str(s) #s

//

#ifndef LOOPS
#define LOOPS 3
#endif

#ifndef MINBYTES
#define MINBYTES 32
#endif

#ifndef MAXBYTES
#define MAXBYTES 16384
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

#define inc_32 inc
#define inc_4 inc_out
#include "increment.c"
#include "cpucycles.c"
#include "printbench.c"

//

int main(void)
{
  int loop, r0, r1, i;
  char *op_str[] = {xstr(crypto_xof,.csv)};
  uint8_t out[MAXOUTBYTES], in[MAXBYTES];
  size_t outsize, outlen, inlen;
  uint64_t cycles[TIMINGS];
  uint64_t** results[OP][LOOPS];

  outsize = size_inc_4(MINOUTBYTES,MAXOUTBYTES);
  alloc_4(results, outsize, size_inc_32(MINBYTES,MAXBYTES));

  for(loop = 0; loop < LOOPS; loop++)
  { for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen += inc_out(outlen), r0 += 1)
    { for (inlen = MINBYTES, r1 = 0; inlen <= MAXBYTES; inlen += inc(inlen), r1 += 1)
      { for (i = 0; i < TIMINGS; i++)
        { cycles[i] = cpucycles();
          crypto_xof(out, outlen, in, inlen); }
        results[0][loop][r0][r1] = cpucycles_median(cycles, TIMINGS);
      }
    }
  }

  cpucycles_fprintf_4(results, op_str);
  free_4(results, outsize);

  return 0;
}

