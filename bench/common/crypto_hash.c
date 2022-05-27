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

#ifndef TIMINGS
#define TIMINGS 256
#endif

#define OP 1

//

#define inc_32 inc
#include "increment.c"
#include "cpucycles.c"
#include "printbench.c"

//

int main(void)
{
  int loop, r, i;
  char *op_str[] = {xstr(crypto_hash,.csv)};
  uint8_t out[MAXBYTES], in[MAXBYTES];
  size_t len;
  uint64_t cycles[TIMINGS];
  uint64_t* results[OP][LOOPS];

  alloc_3(results, size_inc_32(MINBYTES,MAXBYTES));

  for(loop = 0; loop < LOOPS; loop++)
  { for (len = MINBYTES, r = 0; len <= MAXBYTES; len += inc(len), r += 1)
    { for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_hash(out, in, len); }
      results[0][loop][r] = cpucycles_median(cycles, TIMINGS);
    }
  }

  cpucycles_fprintf_3(results, op_str);
  free_3(results);

  return 0;
}

