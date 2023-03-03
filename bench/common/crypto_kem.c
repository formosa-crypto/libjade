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

#define OP1 3

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

  char *op1_str[] = {xstr(crypto_kem_keypair,.csv),
                     xstr(crypto_kem_enc,.csv),
                     xstr(crypto_kem_dec,.csv)};

  uint8_t *_ps, *ps, *p; // CRYPTO_PUBLICKEYBYTES
  uint8_t *_ss, *ss, *s; // CRYPTO_SECRETKEYBYTES
  uint8_t *_ks, *ks, *k; // CRYPTO_BYTES
  uint8_t *_cs, *cs, *c; // CRYPTO_CIPHERTEXTBYTES
  uint8_t *_ts, *ts, *t; // CRYPTO_BYTES
  size_t plen, slen, klen, clen, tlen;

  pb_init_1(argc, op1_str);

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

_st_while_b

  for(run = 0; run < RUNS; run++)
  {

    _st_reset_randombytes

    for(loop = 0; loop < LOOPS; loop++)
    {
      // keypair
      p = ps; s = ss;
      for (i = 0; i < TIMINGS; i++, p += plen, s += slen)
      { cycles[i] = cpucycles();
        crypto_kem_keypair(p, s); }
      median_loops[0][loop] = cpucycles_median(cycles, TIMINGS);

      // enc
      c = cs; k = ks; p = ps;
      for (i = 0; i < TIMINGS; i++, c += clen, k += klen, p += plen)
      { cycles[i] = cpucycles();
        crypto_kem_enc(c, k, p); }
      median_loops[1][loop] = cpucycles_median(cycles, TIMINGS);

      // dec
      t = ts; c = cs; s = ss;
      for (i = 0; i < TIMINGS; i++, t += tlen, c += clen, s += slen)
      { cycles[i] = cpucycles();
        crypto_kem_dec(t, c, s); }
      median_loops[2][loop] = cpucycles_median(cycles, TIMINGS);

      #if defined(ASSERT)
      k = ks; t = ts;
      for (i = 0; i < TIMINGS; i++, k += klen, t += tlen)
      { assert(memcmp(k, t, CRYPTO_BYTES) == 0); }
      #endif
    }

    _st_ifnotst(pb_print_1(argc, median_loops, op1_str))
    _st_store_1(median_runs, run, median_loops)
  }

  // all results must be within 'spec' at the same time
  // does not save 'best' results
  _st_check_1(sd_runs, mean_runs, median_runs)

_st_while_e

_st_print_1(argc, sd_runs, mean_runs, median_runs, op1_str)

  free(_ps);
  free(_ss);
  free(_ks);
  free(_cs);
  free(_ts);

  return 0;
}

