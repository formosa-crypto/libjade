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
  int loop, r, i;
  uint64_t cycles[TIMINGS];
  uint64_t* results[OP][LOOPS];
  char *op_str[] = {xstr(crypto_secretbox,.csv),
                    xstr(crypto_secretbox_open,.csv),
                    xstr(crypto_secretbox_open,_forgery.csv)};

  uint8_t *_ciphertext, *ciphertext; // MAXINBYTES + CRYPTO_ZEROBYTES
  uint8_t *_plaintext, *plaintext; // MAXINBYTES + CRYPTO_ZEROBYTES
  uint8_t *_nonce, *nonce; // CRYPTO_NONCEBYTES
  uint8_t *_key, *key; // CRYPTO_KEYBYTES
  size_t len;

  pb_alloc_2(results, size_inc_in(MININBYTES,MAXINBYTES));

  ciphertext = alignedcalloc(&_ciphertext, MAXINBYTES + CRYPTO_ZEROBYTES);
  plaintext = alignedcalloc(&_plaintext, MAXINBYTES + CRYPTO_ZEROBYTES);
  nonce = alignedcalloc(&_nonce, CRYPTO_NONCEBYTES);
  key = alignedcalloc(&_key, CRYPTO_KEYBYTES);

  for(loop = 0; loop < LOOPS; loop++)
  { for (len = MININBYTES, r = 0; len <= MAXINBYTES; len = inc_in(len), r += 1)
    {
      benchrandombytes(plaintext + CRYPTO_ZEROBYTES, len);
      benchrandombytes(nonce, CRYPTO_NONCEBYTES);
      benchrandombytes(key, CRYPTO_KEYBYTES);

      // secretbox
      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_secretbox(ciphertext, plaintext, len + CRYPTO_ZEROBYTES, nonce, key); }
      results[0][loop][r] = cpucycles_median(cycles, TIMINGS);

      // secretbox_open
      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_secretbox_open(plaintext, ciphertext, len + CRYPTO_ZEROBYTES, nonce, key); }
      results[1][loop][r] = cpucycles_median(cycles, TIMINGS);

      // secretbox_open - forgery
      ciphertext[CRYPTO_ZEROBYTES] += 1;
      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_secretbox_open(plaintext, ciphertext, len + CRYPTO_ZEROBYTES, nonce, key); }
      results[2][loop][r] = cpucycles_median(cycles, TIMINGS);
    }
  }

  pb_print_2(argc, results, op_str);
  pb_free_2(results);

  free(_ciphertext);
  free(_plaintext);
  free(_nonce);
  free(_key);

  return 0;
}

