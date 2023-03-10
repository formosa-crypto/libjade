#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//
#define CRYPTO_BYTES           NAMESPACE(BYTES)
#define CRYPTO_SCALARBYTES     NAMESPACE(SCALARBYTES)
#define CRYPTO_ALGNAME         NAMESPACE(ALGNAME)

#define crypto_scalarmult      JADE_NAMESPACE_LC
#define crypto_scalarmult_base NAMESPACE_LC(base)

#define OP1 2

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
  size_t run, loop, i;
  uint64_t cycles[TIMINGS];
  uint64_t median_loops[OP1][LOOPS];

#if defined(ST_ON)
  uint64_t median_runs[OP1][RUNS];
  double   sd_runs[OP1], mean_runs[OP1];
#endif

  char *op1_str[] = {xstr(crypto_scalarmult_base,.csv),
                     xstr(crypto_scalarmult,.csv)};

  uint8_t *_m, *m; // CRYPTO_SCALARBYTES
  uint8_t *_n, *n; // CRYPTO_SCALARBYTES
  uint8_t *_p, *p; // CRYPTO_BYTES
  uint8_t *_q, *q; // CRYPTO_BYTES

  pb_init_1(argc, op1_str);

  m = alignedcalloc(&_m, CRYPTO_SCALARBYTES);
  n = alignedcalloc(&_n, CRYPTO_SCALARBYTES);
  p = alignedcalloc(&_p, CRYPTO_BYTES);
  q = alignedcalloc(&_q, CRYPTO_BYTES);

_st_while_b

  for(run = 0; run < RUNS; run++)
  {
    _st_reset_randombytes

    for(loop = 0; loop < LOOPS; loop++)
    {
      benchrandombytes(m, CRYPTO_SCALARBYTES);
      benchrandombytes(n, CRYPTO_SCALARBYTES);

      // scalarmult_base
      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_scalarmult_base(p,m); }
      median_loops[1][loop] = cpucycles_median(cycles, TIMINGS);

      // scalarmult
      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_scalarmult(q,n,p); }
      median_loops[0][loop] = cpucycles_median(cycles, TIMINGS);
    }

    _st_ifnotst(pb_print_1(argc, median_loops, op1_str))
    _st_store_1(median_runs, run, median_loops)
  }

  // all results must be within 'spec' at the same time
  // does not save 'best' results
  _st_check_1(sd_runs, mean_runs, median_runs)

_st_while_e

_st_print_1(argc, sd_runs, mean_runs, median_runs, op1_str)

  free(_m);
  free(_n);
  free(_p);
  free(_q);

  return 0;
}

