#include "api.h"
#include "randombytes.h"
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

//

#ifndef LOOPS
#define LOOPS 5
#endif

#ifndef TIMINGS
#define TIMINGS 10000
#endif

#define OP 2

//

#include "cpucycles.c"

#define PRINTBENCH_1 1
#include "printbench.c"
#undef PRINTBENCH_1

//

int main(int argc, char**argv)
{
  int loop, i;
  char *op_str[] = {xstr(crypto_scalarmult,.csv), xstr(crypto_scalarmult_base,.csv)};
  uint8_t m[CRYPTO_SCALARBYTES];
  uint8_t n[CRYPTO_SCALARBYTES];
  uint8_t p[CRYPTO_BYTES];
  uint8_t q[CRYPTO_BYTES];
  uint64_t cycles[TIMINGS];
  uint64_t results[OP][LOOPS];

  for(loop = 0; loop < LOOPS; loop++)
  {
    // scalarmult 
    for (i = 0; i < TIMINGS; i++)
    { cycles[i] = cpucycles();
      crypto_scalarmult(q,n,p); }
    results[0][loop] = cpucycles_median(cycles, TIMINGS);

    // scalarmult_base
    for (i = 0; i < TIMINGS; i++)
    { cycles[i] = cpucycles();
      crypto_scalarmult_base(p,m); }
    results[1][loop] = cpucycles_median(cycles, TIMINGS);
  }

  cpucycles_fprintf_1(argc, results, op_str);

  return 0;
}

