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
#include "stability.c"

//

int main(int argc, char**argv)
{
  int run, loop, r0, r1, i;
  uint64_t cycles[TIMINGS];
  uint64_t** median_loops[OP3][LOOPS];

  char *op3_str[] = {xstr(crypto_xof,.csv)};

#if defined(ST_ON)
  uint64_t*** median_runs[OP3]; // op -> outlen -> inlen -> [runs]
  double**    sd_runs[OP3];     // op -> outlen -> inlen -> stdev
  double**    mean_runs[OP3];   // op -> outlen -> inlen -> mean
#endif

  uint8_t *_out, *out; // MAXOUTBYTES
  uint8_t *_in, *in; // MAXINBYTES
  size_t outlen, inlen;
  size_t size_out, size_in;

  size_out = size_inc_out(MINOUTBYTES,MAXOUTBYTES);
  size_in  = size_inc_in(MININBYTES,MAXINBYTES);

  pb_init_3(argc, op3_str);
  pb_alloc_3(median_loops, size_out, size_in);

  _st_alloc_3(median_runs, size_out, size_in);
  _st_d_alloc_3(sd_runs, size_out, size_in);
  _st_d_alloc_3(mean_runs, size_out, size_in);

  out = alignedcalloc(&_out, MAXOUTBYTES);
  in = alignedcalloc(&_in, MAXINBYTES);

_st_while_b

  for(run = 0; run < RUNS; run++)
  {
    _st_reset_randombytes

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
          median_loops[0][loop][r0][r1] = cpucycles_median(cycles, TIMINGS);
        }
      }
    }
    _st_ifnotst(pb_print_3(argc, median_loops, op3_str))
    _st_store_3(median_runs, run, median_loops)
  }

  // all results must be within 'spec' at the same time
  // does not save 'best' results
  _st_check_3(sd_runs, mean_runs, median_runs)

_st_while_e

_st_print_3(argc, sd_runs, mean_runs, median_runs, op3_str)

  pb_free_3(median_loops, size_out);
  _st_free_3(median_runs, size_out, size_in);
  _st_d_free_3(sd_runs, size_out);
  _st_d_free_3(mean_runs, size_out);
  free(_out);
  free(_in);

  return 0;
}

