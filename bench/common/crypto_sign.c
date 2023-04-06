#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_PUBLICKEYBYTES NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_SECRETKEYBYTES NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_BYTES NAMESPACE(BYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_sign_keypair NAMESPACE_LC(keypair)
#define crypto_sign JADE_NAMESPACE_LC
#define crypto_sign_open NAMESPACE_LC(open)

#define OP1 1
#define OP2 2

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
  int run, loop, r, i;
  uint64_t cycles[TIMINGS];

  uint64_t  median_loops_keypair[OP1][LOOPS];
  uint64_t* median_loops_sign_open[OP2][LOOPS];

#if defined(ST_ON)
  uint64_t   median_runs1[OP1][RUNS]; double  sd_runs1[OP1]; double  mean_runs1[OP1];
  uint64_t** median_runs2[OP2];       double* sd_runs2[OP2]; double* mean_runs2[OP2];
#endif

  char *op_str_keypair[]   = { xstr(crypto_sign_keypair,.csv)};
  char *op_str_sign_open[] = { xstr(crypto_sign,.csv),
                               xstr(crypto_sign_open,.csv) };

  char *op_str_keypair_short[] =
                             { "keypair" };

  uint8_t  *_pks,    *pks,    *pk;    // CRYPTO_PUBLICKEYBYTES
  uint8_t  *_sks,    *sks,    *sk;    // CRYPTO_SECRETKEYBYTES
  uint8_t  *_ms,     *ms,     *m;     // MAXINBYTES
  uint8_t  *_sms,    *sms,    *sm;    // CRYPTO_BYTES + MAXINBYTES
  uint64_t           *smlens, *smlen; // sizeof(uint64_t)
  uint8_t  *_ts,     *ts,     *t;     // MAXINBYTES

  // a_mlen and a_tlen are equal; nonetheless, it improves code readability;
  size_t a_pklen, a_sklen, a_mlen, a_smlen, a_tlen;
  size_t mlen, tlen; // [MININBYTES..MAXINBYTES] x2

  size_t size_inc;

  size_inc = size_inc_in(MININBYTES,MAXINBYTES);

  pb_init_1(argc, op_str_keypair);
  pb_init_2(argc, op_str_sign_open);
  pb_alloc_2(median_loops_sign_open, size_inc);

  _st_alloc_2(median_runs2, size_inc);
  _st_d_alloc_2(sd_runs2, size_inc);
  _st_d_alloc_2(mean_runs2, size_inc);

  a_pklen  = alignedcalloc_step(CRYPTO_PUBLICKEYBYTES);
  a_sklen  = alignedcalloc_step(CRYPTO_SECRETKEYBYTES);
  a_mlen   = alignedcalloc_step(MAXINBYTES);
  a_smlen  = alignedcalloc_step(CRYPTO_BYTES + MAXINBYTES);
  a_tlen   = alignedcalloc_step(MAXINBYTES);

  pks    = alignedcalloc(&_pks, a_pklen * TIMINGS);
  sks    = alignedcalloc(&_sks, a_sklen * TIMINGS);
  ms     = alignedcalloc(&_ms,  a_mlen  * TIMINGS);
  sms    = alignedcalloc(&_sms, a_smlen * TIMINGS);
  ts     = alignedcalloc(&_ts,  a_tlen  * TIMINGS);
  smlens = calloc(sizeof(uint64_t), TIMINGS);

_st_while_b

  for(run = 0; run < RUNS; run++)
  {
    _st_reset_randombytes

    for(loop = 0; loop < LOOPS; loop++)
    {
      // keypair
      pk = pks; sk = sks;
      for (i = 0; i < TIMINGS; i++, pk += a_pklen, sk += a_sklen)
      { cycles[i] = cpucycles();
        crypto_sign_keypair(pk, sk); }
      median_loops_keypair[0][loop] = cpucycles_median(cycles, TIMINGS);

      for (mlen = MININBYTES, r = 0; mlen <= MAXINBYTES; mlen = inc_in(mlen), r += 1)
      {
        // for current mlen, initialize TIMINGS messages with mlen bytes
        m = ms;
        for (i = 0; i < TIMINGS; i++, m += a_mlen)
        { benchrandombytes(m, mlen); }

        // sign
        sm = sms; smlen = smlens; m = ms; sk = sks;
        for (i = 0; i < TIMINGS; i++, sm += a_smlen, smlen++, m += a_mlen, sk += a_sklen)
        { cycles[i] = cpucycles();
          crypto_sign(sm, smlen, m, mlen, sk); }
        median_loops_sign_open[0][loop][r] = cpucycles_median(cycles, TIMINGS);

        // open
        t = ts; sm = sms; smlen = smlens; pk = pks;
        for (i = 0; i < TIMINGS; i++, t += a_tlen, sm += a_smlen, smlen++, pk += a_pklen)
        { cycles[i] = cpucycles();
          crypto_sign_open(t, &tlen, sm, *smlen, pk); }
        median_loops_sign_open[1][loop][r] = cpucycles_median(cycles, TIMINGS);
      }
    }
    _st_ifnotst(pb_print_1(argc, median_loops_keypair, op_str_keypair))
    _st_ifnotst(pb_print_2(argc, median_loops_sign_open, op_str_sign_open))

    _st_store_1(median_runs1, run, median_loops_keypair)
    _st_store_2(median_runs2, run, median_loops_sign_open)
  }

  // all results must be within 'spec' at the same time
  // does not save 'best' results
  _st_check_1_2(sd_runs1, mean_runs1, median_runs1,
                sd_runs2, mean_runs2, median_runs2)

_st_while_e

_st_print_1(argc, sd_runs1, mean_runs1, median_runs1, op_str_keypair, op_str_keypair_short)
_st_print_2(argc, sd_runs2, mean_runs2, median_runs2, op_str_sign_open)

  pb_free_2(median_loops_sign_open);
  _st_free_2(median_runs2, size_inc);
  _st_d_free_2(sd_runs2);
  _st_d_free_2(mean_runs2);
  free(_pks);
  free(_sks);
  free(_ms);
  free(_sms);
  free( smlens);
  free(_ts);

  return 0;
}

