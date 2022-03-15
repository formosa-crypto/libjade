#include "api.h"
#include "randombytes.h"
#include "cpucycles.h"
#include "printbench.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NRUNS 1000

#define CRYPTO_BYTES           NAMESPACE(BYTES)
#define CRYPTO_PUBLICKEYBYTES  NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_SECRETKEYBYTES  NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_CIPHERTEXTBYTES NAMESPACE(CIPHERTEXTBYTES)
#define CRYPTO_ALGNAME         NAMESPACE(ALGNAME)

#define crypto_kem_keypair NAMESPACE_LC(keypair)
#define crypto_kem_enc NAMESPACE_LC(enc)
#define crypto_kem_dec NAMESPACE_LC(dec)


int main(void) {
  uint8_t ss0[CRYPTO_BYTES];
  uint8_t ss1[CRYPTO_BYTES];
  uint8_t pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
  int i;
  uint64_t t[NRUNS];

  for(i=0;i<NRUNS;i++) {
    t[i] = cpucycles();
    crypto_kem_keypair(pk, sk);
  }
  printbench(CRYPTO_ALGNAME, "keypair", t, NRUNS);

  for(i=0;i<NRUNS;i++) {
    t[i] = cpucycles();
    crypto_kem_enc(ct, ss0, pk);
  }
  printbench(CRYPTO_ALGNAME, "enc", t, NRUNS);

  for(i=0;i<NRUNS;i++) {
    t[i] = cpucycles();
    crypto_kem_dec(ss1, ct, sk);
  }
  printbench(CRYPTO_ALGNAME, "dec", t, NRUNS);

  return 0;
}
