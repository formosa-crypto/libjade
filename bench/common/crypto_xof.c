#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_xof JADE_NAMESPACE_LC

#define OP3 1

//

#include "config.h"
#include "cpucycles.c"
#include "increment.c"
#include "printbench.c"
#include "alignedcalloc.c"
#include "benchrandombytes.c"

//

int main(int argc, char**argv)
{
  int run, loop, r0, r1, i;
  uint64_t cycles[TIMINGS];
  uint64_t** results[OP3][LOOPS];
  char *op3_str[] = {xstr(crypto_xof,.csv)};

  uint8_t *_out, *out; // MAXOUTBYTES
  uint8_t *_in, *in; // MAXINBYTES
  size_t outsize, outlen, inlen;

  outsize = size_inc_out(MINOUTBYTES,MAXOUTBYTES);
  pb_alloc_3(results, outsize, size_inc_in(MININBYTES,MAXINBYTES));

  out = alignedcalloc(&_out, MAXOUTBYTES);
  in = alignedcalloc(&_in, MAXINBYTES);

  for(run = 0; run < RUNS; run++)
  {
    for(loop = 0; loop < LOOPS; loop++)
    {
      for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen = inc_out(outlen), r0 += 1)
      {
        for (inlen = MININBYTES, r1 = 0; inlen <= MAXINBYTES; inlen = inc_in(inlen), r1 += 1)
        {
          benchrandombytes(in, inlen);

          for (i = 0; i < TIMINGS; i++)
          { cycles[i] = cpucycles();
            crypto_xof(out, outlen, in, inlen); }
          results[0][loop][r0][r1] = cpucycles_median(cycles, TIMINGS);
        }
      }
    }
    pb_print_3(argc, results, op3_str);
  }

  pb_free_3(results, outsize);
  free(_out);
  free(_in);

  return 0;
}

