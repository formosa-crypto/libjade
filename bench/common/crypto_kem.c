#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

//

#define CRYPTO_BYTES           NAMESPACE(BYTES)
#define CRYPTO_PUBLICKEYBYTES  NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_SECRETKEYBYTES  NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_CIPHERTEXTBYTES NAMESPACE(CIPHERTEXTBYTES)
#define CRYPTO_ALGNAME         NAMESPACE(ALGNAME)

#define crypto_kem_keypair NAMESPACE_LC(keypair)
#define crypto_kem_enc NAMESPACE_LC(enc)
#define crypto_kem_dec NAMESPACE_LC(dec)

#define OP 3

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
  int run, loop, i;
  uint64_t cycles[TIMINGS];
  uint64_t results[OP][LOOPS];
  char *op_str[] = {xstr(crypto_kem_keypair,.csv),
                    xstr(crypto_kem_enc,.csv),
                    xstr(crypto_kem_dec,.csv)};

  uint8_t *_ps, *ps, *p; // CRYPTO_PUBLICKEYBYTES
  uint8_t *_ss, *ss, *s; // CRYPTO_SECRETKEYBYTES
  uint8_t *_ks, *ks, *k; // CRYPTO_BYTES
  uint8_t *_cs, *cs, *c; // CRYPTO_CIPHERTEXTBYTES
  uint8_t *_ts, *ts, *t; // CRYPTO_BYTES
  size_t plen, slen, klen, clen, tlen;

  plen = alignedcalloc_step(CRYPTO_PUBLICKEYBYTES);
  slen = alignedcalloc_step(CRYPTO_SECRETKEYBYTES);
  klen = alignedcalloc_step(CRYPTO_BYTES);
  clen = alignedcalloc_step(CRYPTO_CIPHERTEXTBYTES);
  tlen = alignedcalloc_step(CRYPTO_BYTES);

  ps = alignedcalloc(&_ps, plen * TIMINGS);
  ss = alignedcalloc(&_ss, slen * TIMINGS);
  ks = alignedcalloc(&_ks, klen * TIMINGS);
  cs = alignedcalloc(&_cs, clen * TIMINGS);
  ts = alignedcalloc(&_ts, tlen * TIMINGS);

  for(run = 0; run < RUNS; run++)
  {
    for(loop = 0; loop < LOOPS; loop++)
    {
      // keypair
      p = ps; s = ss;
      for (i = 0; i < TIMINGS; i++, p += plen, s += slen)
      { cycles[i] = cpucycles();
        crypto_kem_keypair(p, s); }
      results[0][loop] = cpucycles_median(cycles, TIMINGS);

      // enc
      c = cs; k = ks; p = ps;
      for (i = 0; i < TIMINGS; i++, c += clen, k += klen, p += plen)
      { cycles[i] = cpucycles();
        crypto_kem_enc(c, k, p); }
      results[1][loop] = cpucycles_median(cycles, TIMINGS);

      // dec
      t = ts; c = cs; s = ss;
      for (i = 0; i < TIMINGS; i++, t += tlen, c += clen, s += slen)
      { cycles[i] = cpucycles();
        crypto_kem_dec(t, c, s); }
      results[2][loop] = cpucycles_median(cycles, TIMINGS);

      #if defined(ASSERT)
      k = ks; t = ts;
      for (i = 0; i < TIMINGS; i++, k += klen, t += tlen)
      { assert(memcmp(k, t, CRYPTO_BYTES) == 0); }
      #endif
    }
    pb_print_1(argc, results, op_str);
  }

  free(_ps);
  free(_ss);
  free(_ks);
  free(_cs);
  free(_ts);

  return 0;
}

