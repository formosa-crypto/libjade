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

//

#ifndef LOOPS
#define LOOPS 5
#endif

#ifndef TIMINGS
#define TIMINGS 10000
#endif

#define OP 3

//

#include "cpucycles.c"

#define PRINTBENCH_1 1
#include "printbench.c"
#undef PRINTBENCH_1

//

int main(int argc, char**argv)
{
  int loop;
  size_t i;
  char *op_str[] = {xstr(crypto_kem_keypair,.csv), xstr(crypto_kem_enc,.csv), xstr(crypto_kem_dec,.csv)};
  uint8_t ss0[CRYPTO_BYTES];
  uint8_t ss1[CRYPTO_BYTES];
  uint8_t *pk, *pkt;
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
  uint64_t cycles[TIMINGS];
  uint64_t results[OP][LOOPS];

  // for Kyber768 (pk 1184, sk 2400) and 16K timings, ~18MB and ~37MB; atm pk;
  pk = (uint8_t*) malloc(TIMINGS*CRYPTO_PUBLICKEYBYTES*sizeof(uint8_t));

  for(loop = 0; loop < LOOPS; loop++)
  {
    // keypair
    pkt = pk;
    for (i = 0; i < TIMINGS; i++, pkt += CRYPTO_PUBLICKEYBYTES)
    { cycles[i] = cpucycles();
      crypto_kem_keypair(pkt, sk); }
    results[0][loop] = cpucycles_median(cycles, TIMINGS);

    // enc
    pkt = pk;
    for (i = 0; i < TIMINGS; i++, pkt += CRYPTO_PUBLICKEYBYTES)
    { cycles[i] = cpucycles();
      crypto_kem_enc(ct, ss0, pkt); }
    results[1][loop] = cpucycles_median(cycles, TIMINGS);

    // dec
    for (i = 0; i < TIMINGS; i++)
    { cycles[i] = cpucycles();
      crypto_kem_dec(ss1, ct, sk); }
    results[2][loop] = cpucycles_median(cycles, TIMINGS);
  }

  cpucycles_fprintf_1(argc, results, op_str);

  free(pk);

  return 0;
}

