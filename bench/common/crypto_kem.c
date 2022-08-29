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
#define TIMINGS 8192
#endif

#define OP 3

//

#include "cpucycles.c"
#include "printbench1.c"
#include "alignedcalloc.c"

//

int main(int argc, char**argv)
{
  int loop, i;
  uint64_t cycles[TIMINGS];
  uint64_t results[OP][LOOPS];
  char *op_str[] = {xstr(crypto_kem_keypair,.csv),
                    xstr(crypto_kem_enc,.csv),
                    xstr(crypto_kem_dec,.csv)};

  uint8_t *_ps, *ps, *p; // CRYPTO_PUBLICKEYBYTES
  uint8_t *_ss, *ss, *s; // CRYPTO_SECRETKEYBYTES
  uint8_t *_k, *k; // CRYPTO_BYTES
  uint8_t *_c, *c; // CRYPTO_CIPHERTEXTBYTES
  uint8_t *_t, *t; // CRYPTO_BYTES
  size_t plen, slen;

  plen = alignedcalloc_step(CRYPTO_PUBLICKEYBYTES);
  slen = alignedcalloc_step(CRYPTO_SECRETKEYBYTES);

  ps = alignedcalloc(&_ps, plen * TIMINGS);
  ss = alignedcalloc(&_ss, slen * TIMINGS);
  k = alignedcalloc(&_k, CRYPTO_BYTES);
  c = alignedcalloc(&_c, CRYPTO_CIPHERTEXTBYTES);
  t = alignedcalloc(&_t, CRYPTO_BYTES);

  for(loop = 0; loop < LOOPS; loop++)
  {
    // keypair
    p = ps; s = ss;
    for (i = 0; i < TIMINGS; i++, p += plen, s += slen)
    { cycles[i] = cpucycles();
      crypto_kem_keypair(p, s); }
    results[0][loop] = cpucycles_median(cycles, TIMINGS);

    // enc
    p = ps;
    for (i = 0; i < TIMINGS; i++, p += plen)
    { cycles[i] = cpucycles();
      crypto_kem_enc(c, k, p); }
    results[1][loop] = cpucycles_median(cycles, TIMINGS);

    // dec
    s = ss;
    for (i = 0; i < TIMINGS; i++, s += slen)
    { cycles[i] = cpucycles();
      crypto_kem_dec(t, c, s); }
    results[2][loop] = cpucycles_median(cycles, TIMINGS);
  }

  pb_print_1(argc, results, op_str);

  free(_ps);
  free(_ss);
  free(_k);
  free(_c);
  free(_t);

  return 0;
}

