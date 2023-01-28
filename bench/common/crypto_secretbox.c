#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_KEYBYTES NAMESPACE(KEYBYTES)
#define CRYPTO_NONCEBYTES NAMESPACE(NONCEBYTES)
#define CRYPTO_ZEROBYTES NAMESPACE(ZEROBYTES)
#define CRYPTO_BOXZEROBYTES NAMESPACE(BOXZEROBYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_secretbox_open NAMESPACE_LC(open)
#define crypto_secretbox JADE_NAMESPACE_LC

#define OP2 3

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
  uint64_t* median_loops[OP2][LOOPS];

#if defined(ST_ON)
  uint64_t** median_runs[OP2]; // op -> mlen -> runs
  double*    sd_runs[OP2];
  double*    mean_runs[OP2];
#endif

  char *op2_str[] = {xstr(crypto_secretbox,.csv),
                     xstr(crypto_secretbox_open,.csv),
                     xstr(crypto_secretbox_open,_forgery.csv)};

  uint8_t *_ciphertext, *ciphertext; // MAXINBYTES + CRYPTO_ZEROBYTES
  uint8_t *_plaintext, *plaintext; // MAXINBYTES + CRYPTO_ZEROBYTES
  uint8_t *_nonce, *nonce; // CRYPTO_NONCEBYTES
  uint8_t *_key, *key; // CRYPTO_KEYBYTES
  size_t len;

  size_t size_inc;

  size_inc = size_inc_in(MININBYTES,MAXINBYTES);

  pb_init_2(argc, op2_str);
  pb_alloc_2(median_loops, size_inc);

  _st_alloc_2(median_runs, size_inc);
  _st_d_alloc_2(sd_runs, size_inc);
  _st_d_alloc_2(mean_runs, size_inc);

  ciphertext = alignedcalloc(&_ciphertext, MAXINBYTES + CRYPTO_ZEROBYTES);
  plaintext = alignedcalloc(&_plaintext, MAXINBYTES + CRYPTO_ZEROBYTES);
  nonce = alignedcalloc(&_nonce, CRYPTO_NONCEBYTES);
  key = alignedcalloc(&_key, CRYPTO_KEYBYTES);

_st_while_b

  for(run = 0; run < RUNS; run++)
  {
    _st_reset_notrandombytes

    for(loop = 0; loop < LOOPS; loop++)
    {
      for (len = MININBYTES, r = 0; len <= MAXINBYTES; len = inc_in(len), r += 1)
      {
        benchrandombytes(plaintext + CRYPTO_ZEROBYTES, len);
        benchrandombytes(nonce, CRYPTO_NONCEBYTES);
        benchrandombytes(key, CRYPTO_KEYBYTES);

        // secretbox
        for (i = 0; i < TIMINGS; i++)
        { cycles[i] = cpucycles();
          crypto_secretbox(ciphertext, plaintext, len + CRYPTO_ZEROBYTES, nonce, key); }
        median_loops[0][loop][r] = cpucycles_median(cycles, TIMINGS);

        // secretbox_open
        for (i = 0; i < TIMINGS; i++)
        { cycles[i] = cpucycles();
          crypto_secretbox_open(plaintext, ciphertext, len + CRYPTO_ZEROBYTES, nonce, key); }
        median_loops[1][loop][r] = cpucycles_median(cycles, TIMINGS);

        // secretbox_open - forgery
        ciphertext[CRYPTO_ZEROBYTES] += 1;
        for (i = 0; i < TIMINGS; i++)
        { cycles[i] = cpucycles();
          crypto_secretbox_open(plaintext, ciphertext, len + CRYPTO_ZEROBYTES, nonce, key); }
        median_loops[2][loop][r] = cpucycles_median(cycles, TIMINGS);
      }
    }
    _st_ifnotst(pb_print_2(argc, median_loops, op2_str))
    _st_store_2(median_runs, run, median_loops)
  }

  // all results must be within 'spec' at the same time
  // does not save 'best' results
  _st_check_2(sd_runs, mean_runs, median_runs)

_st_while_e

_st_print_2(argc, sd_runs, mean_runs, median_runs, op2_str)

  pb_free_2(median_loops);
  _st_free_2(median_runs, size_inc);
  _st_d_free_2(sd_runs);
  _st_d_free_2(mean_runs);
  free(_ciphertext);
  free(_plaintext);
  free(_nonce);
  free(_key);

  return 0;
}

