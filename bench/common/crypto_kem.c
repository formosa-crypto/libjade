#include "api.h"
#include "namespace.h"
#include "randombytes.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

//

#define CRYPTO_SECRETKEYBYTES     NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_PUBLICKEYBYTES     NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_KEYPAIRCOINBYTES   NAMESPACE(KEYPAIRCOINBYTES)

#define CRYPTO_CIPHERTEXTBYTES    NAMESPACE(CIPHERTEXTBYTES)
#define CRYPTO_BYTES              NAMESPACE(BYTES)
#define CRYPTO_ENCCOINBYTES       NAMESPACE(ENCCOINBYTES)

#define CRYPTO_ALGNAME            NAMESPACE(ALGNAME)
#define CRYPTO_ARCH               NAMESPACE(ARCH)
#define CRYPTO_IMPL               NAMESPACE(IMPL)

#define crypto_kem_keypair        NAMESPACE_LC(keypair)
#define crypto_kem_keypair_derand NAMESPACE_LC(keypair_derand)
#define crypto_kem_enc            NAMESPACE_LC(enc)
#define crypto_kem_enc_derand     NAMESPACE_LC(enc_derand)
#define crypto_kem_dec            NAMESPACE_LC(dec)

#define OP1 5

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
                     xstr(crypto_kem_keypair_derand,.csv),
                     xstr(crypto_kem_enc,.csv),
                     xstr(crypto_kem_enc_derand,.csv),
                     xstr(crypto_kem_dec,.csv)};

  char *op1_str_short[] =
                    {"keypair       ",
                     "keypair_derand",
                     "enc           ",
                     "enc_derand    ",
                     "dec           "};

  // 'rand'
  uint8_t *_ss,  *ss,  *s;  // CRYPTO_SECRETKEYBYTES  // keypair, dec
  uint8_t *_ps,  *ps,  *p;  // CRYPTO_PUBLICKEYBYTES  // keypair, enc
  uint8_t *_cs,  *cs,  *c;  // CRYPTO_CIPHERTEXTBYTES // enc, dec
  uint8_t *_ks,  *ks,  *k;  // CRYPTO_BYTES           // enc
  uint8_t *_ts,  *ts,  *t;  // CRYPTO_BYTES           // dec

  // 'derand'
  uint8_t *_d_ss,  *d_ss,  *d_s;  // CRYPTO_SECRETKEYBYTES    // keypair, dec
  uint8_t *_d_ps,  *d_ps,  *d_p;  // CRYPTO_PUBLICKEYBYTES    // keypair, enc
  uint8_t *_d_cs,  *d_cs,  *d_c;  // CRYPTO_CIPHERTEXTBYTES   // enc, dec
  uint8_t *_d_ks,  *d_ks,  *d_k;  // CRYPTO_BYTES             // enc
  uint8_t *_d_kcs, *d_kcs, *d_kc; // CRYPTO_KEYPAIRCOINBYTES  // keypair
  uint8_t *_d_ecs, *d_ecs, *d_ec; // CRYPTO_ENCCOINBYTES      // enc

  size_t slen, plen, clen, klen, tlen;
  size_t kclen, eclen;

  pb_init_1(argc, op1_str);

  slen  = alignedcalloc_step(CRYPTO_SECRETKEYBYTES);
  plen  = alignedcalloc_step(CRYPTO_PUBLICKEYBYTES);
  clen  = alignedcalloc_step(CRYPTO_CIPHERTEXTBYTES);
  klen  = alignedcalloc_step(CRYPTO_BYTES);
  tlen  = alignedcalloc_step(CRYPTO_BYTES);
  kclen = alignedcalloc_step(CRYPTO_KEYPAIRCOINBYTES);
  eclen = alignedcalloc_step(CRYPTO_ENCCOINBYTES);

  //
  ss  = alignedcalloc(&_ss,  slen  * TIMINGS);
  ps  = alignedcalloc(&_ps,  plen  * TIMINGS);
  cs  = alignedcalloc(&_cs,  clen  * TIMINGS);
  ks  = alignedcalloc(&_ks,  klen  * TIMINGS);
  ts  = alignedcalloc(&_ts,  tlen  * TIMINGS);

  d_ss  = alignedcalloc(&_d_ss,  slen  * TIMINGS);
  d_ps  = alignedcalloc(&_d_ps,  plen  * TIMINGS);
  d_cs  = alignedcalloc(&_d_cs,  clen  * TIMINGS);
  d_ks  = alignedcalloc(&_d_ks,  klen  * TIMINGS);
  d_kcs = alignedcalloc(&_d_kcs, kclen * TIMINGS);
  d_ecs = alignedcalloc(&_d_ecs, eclen * TIMINGS);

_st_while_b

  for(run = 0; run < RUNS; run++)
  {

    _st_reset_randombytes

    for(loop = 0; loop < LOOPS; loop++)
    {
      // ////////////////////
      // keypair
      p = ps; s = ss;
      for (i = 0; i < TIMINGS; i++, p += plen, s += slen)
      { cycles[i] = cpucycles();
        crypto_kem_keypair(p, s); }
      median_loops[0][loop] = cpucycles_median(cycles, TIMINGS);

        // keypair derand:
        // - init coins; benchmark;
        // - keypair and keypair_derand are measured with
        //   the same 'coins' if notrandombytes.c from test is provided as
        //   RNDLIB; otherwise, randombytes1 'points' to randombytes; this
        //   is handled by stability.c
        d_kc = d_kcs;
        for (i = 0; i < TIMINGS; i++, d_kc += kclen)
        { _st_randombytes1(d_kc, CRYPTO_KEYPAIRCOINBYTES); }

        d_p = d_ps; d_s = d_ss; d_kc = d_kcs;
        for (i = 0; i < TIMINGS; i++, d_p += plen, d_s += slen, d_kc += kclen)
        { cycles[i] = cpucycles();
          crypto_kem_keypair_derand(d_p, d_s, d_kc); }
        median_loops[1][loop] = cpucycles_median(cycles, TIMINGS);

      // ////////////////////
      // enc
      c = cs; k = ks; p = ps;
      for (i = 0; i < TIMINGS; i++, c += clen, k += klen, p += plen)
      { cycles[i] = cpucycles();
        crypto_kem_enc(c, k, p); }
      median_loops[2][loop] = cpucycles_median(cycles, TIMINGS);

        // enc derand: check notes for keypair derand
        d_ec = d_ecs;
        for (i = 0; i < TIMINGS; i++, d_ec += eclen)
        { _st_randombytes1(d_ec, CRYPTO_ENCCOINBYTES); }

        d_c = d_cs; d_k = d_ks; d_p = d_ps; d_ec = d_ecs;
        for (i = 0; i < TIMINGS; i++, d_c += clen, d_k += klen, d_p += plen, d_ec += eclen)
        { cycles[i] = cpucycles();
          crypto_kem_enc_derand(d_c, d_k, d_p, d_ec); }
        median_loops[3][loop] = cpucycles_median(cycles, TIMINGS);

      // dec
      t = ts; c = cs; s = ss;
      for (i = 0; i < TIMINGS; i++, t += tlen, c += clen, s += slen)
      { cycles[i] = cpucycles();
        crypto_kem_dec(t, c, s); }
      median_loops[4][loop] = cpucycles_median(cycles, TIMINGS);

      #if defined(ASSERT)
      // 'rand': check that shared_secret from enc matches the one from dec
      k = ks; t = ts;
      for (i = 0; i < TIMINGS; i++, k += klen, t += tlen)
      { assert(memcmp(k, t, CRYPTO_BYTES) == 0); }

      // 'derand':
      d_k = d_ks; t = ts; d_c = d_cs; d_s = d_ss;
      for (i = 0; i < TIMINGS; i++, d_k += klen, t += tlen, d_c += clen, d_s += slen)
      { crypto_kem_dec(t, d_c, d_s);
        assert(memcmp(d_k, t, CRYPTO_BYTES) == 0);
      }
      #endif
    }

    _st_ifnotst(pb_print_1(argc, median_loops, op1_str, op1_str_short))
    _st_store_1(median_runs, run, median_loops)
  }

  // all results must be within 'spec' at the same time
  // does not save 'best' results
  _st_check_1(sd_runs, mean_runs, median_runs)

_st_while_e

_st_print_1(argc, sd_runs, mean_runs, median_runs, op1_str, op1_str_short)

  free(_ps);
  free(_ss);
  free(_ks);
  free(_cs);
  free(_ts);

  free(_d_ps);
  free(_d_ss);
  free(_d_ks);
  free(_d_cs);
  free(_d_kcs);
  free(_d_ecs);

  return 0;
}

