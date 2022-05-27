#include "api.h"
#include "randombytes.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//
#define CRYPTO_BYTES           NAMESPACE(BYTES)
#define CRYPTO_PUBLICKEYBYTES  NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_SECRETKEYBYTES  NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_CIPHERTEXTBYTES NAMESPACE(CIPHERTEXTBYTES)
#define CRYPTO_ALGNAME         NAMESPACE(ALGNAME)

#define crypto_kem_keypair NAMESPACE_LC(keypair)
#define crypto_kem_enc NAMESPACE_LC(enc)
#define crypto_kem_dec NAMESPACE_LC(dec)

#define xstr(s,e) str(s)#e
#define str(s) #s

//

#ifndef LOOPS
#define LOOPS 3
#endif

#ifndef TIMINGS
#define TIMINGS 2048
#endif

#define OP 3

//

#include "cpucycles.c"
#include "printbench.c"

//

int main(void)
{
  int loop, i;
  char *op_str[] = {xstr(crypto_kem_keypair,.csv), xstr(crypto_kem_enc,.csv), xstr(crypto_kem_dec,.csv)};
  uint8_t ss0[CRYPTO_BYTES];
  uint8_t ss1[CRYPTO_BYTES];
  uint8_t pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
  uint64_t cycles[TIMINGS];
  uint64_t results[OP][LOOPS];

  for(loop = 0; loop < LOOPS; loop++)
  {
    // keypair 
    for (i = 0; i < TIMINGS; i++)
    { cycles[i] = cpucycles();
      crypto_kem_keypair(pk, sk); }
    results[0][loop] = cpucycles_median(cycles, TIMINGS);

    // enc
    for (i = 0; i < TIMINGS; i++)
    { cycles[i] = cpucycles();
      crypto_kem_enc(ct, ss0, pk); }
    results[1][loop] = cpucycles_median(cycles, TIMINGS);

    // dec
    for (i = 0; i < TIMINGS; i++)
    { cycles[i] = cpucycles();
      crypto_kem_dec(ss1, ct, sk); }
    results[1][loop] = cpucycles_median(cycles, TIMINGS);
  }

  cpucycles_fprintf_2(results, op_str);

  return 0;
}

