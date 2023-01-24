#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_BYTES NAMESPACE(BYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)
#define crypto_hash JADE_NAMESPACE_LC

#define OP2 1

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
  int run, loop, r, i;
  uint64_t cycles[TIMINGS];
  uint64_t* results[OP2][LOOPS];
  char *op2_str[] = {xstr(crypto_hash,.csv)};

  uint8_t *_out, *out; // CRYPTO_BYTES
  uint8_t *_in, *in; // MAXINBYTES
  size_t len;

  pb_alloc_2(results, size_inc_in(MININBYTES, MAXINBYTES));

  out = alignedcalloc(&_out, CRYPTO_BYTES);
  in = alignedcalloc(&_in, MAXINBYTES);

  for(run = 0; run < RUNS; run++)
  {
    for(loop = 0; loop < LOOPS; loop++)
    {
      for (len = MININBYTES, r = 0; len <= MAXINBYTES; len = inc_in(len), r += 1)
      {
        benchrandombytes(in, len);

        for (i = 0; i < TIMINGS; i++)
        { cycles[i] = cpucycles();
          crypto_hash(out, in, len); }
        results[0][loop][r] = cpucycles_median(cycles, TIMINGS);
      }
    }
    pb_print_2(argc, results, op2_str);
  }

  pb_free_2(results);
  free(_in);
  free(_out);

  return 0;
}

