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

#define xstr(s,e) str(s)#e
#define str(s) #s

//

#ifndef LOOPS
#define LOOPS 3
#endif

#ifndef TIMINGS
#define TIMINGS 2048
#endif

#define OP 2

//

#include "cpucycles.c"
#include "printbench.c"

//

int main(void)
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

  cpucycles_fprintf_2(results, op_str);

  return 0;
}

