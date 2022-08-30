#include "api.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_KEYBYTES NAMESPACE(KEYBYTES)
#define CRYPTO_NONCEBYTES NAMESPACE(NONCEBYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_stream_xor NAMESPACE_LC(xor)
#define crypto_stream JADE_NAMESPACE_LC

//

#ifndef LOOPS
#define LOOPS 5
#endif

#ifndef MININBYTES
#define MININBYTES 32
#endif

#ifndef MAXINBYTES
#define MAXINBYTES 16384
#endif

#ifndef TIMINGS
#define TIMINGS 10000
#endif

#define OP 2

//

#include "cpucycles.c"
#include "increment.c"
#include "printbench2.c"
#include "alignedcalloc.c"
#include "benchrandombytes.c"

//

int main(int argc, char**argv)
{
  int loop, r, i;
  uint64_t cycles[TIMINGS];
  uint64_t* results[OP][LOOPS];
  char *op_str[] = {xstr(crypto_stream,.csv),
                    xstr(crypto_stream_xor,.csv)};

  uint8_t *_ciphertext, *ciphertext; // MAXINBYTES
  uint8_t *_plaintext, *plaintext; // MAXINBYTES
  uint8_t *_nonce, *nonce; // CRYPTO_NONCEBYTES
  uint8_t *_key, *key; // CRYPTO_KEYBYTES
  size_t len;

  pb_alloc_2(results, size_inc_in(MININBYTES,MAXINBYTES));

  ciphertext = alignedcalloc(&_ciphertext, MAXINBYTES);
  plaintext = alignedcalloc(&_plaintext, MAXINBYTES);
  nonce = alignedcalloc(&_nonce, CRYPTO_NONCEBYTES);
  key = alignedcalloc(&_key, CRYPTO_KEYBYTES);

  for(loop = 0; loop < LOOPS; loop++)
  { for (len = MININBYTES, r = 0; len <= MAXINBYTES; len = inc_in(len), r += 1)
    {
      benchrandombytes(plaintext, len);
      benchrandombytes(nonce, CRYPTO_NONCEBYTES);
      benchrandombytes(key, CRYPTO_KEYBYTES);

      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_stream(ciphertext, len, nonce, key); }
      results[0][loop][r] = cpucycles_median(cycles, TIMINGS);

      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_stream_xor(ciphertext, plaintext, len, nonce, key); }
      results[1][loop][r] = cpucycles_median(cycles, TIMINGS);
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

