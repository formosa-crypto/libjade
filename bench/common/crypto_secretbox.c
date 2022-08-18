#include "api.h"
#include "randombytes.h"
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
#define TIMINGS 1024
#endif

#define OP 3

//

#include "cpucycles.c"
#include "increment.c"

#define inc_in inc_32

#define PRINTBENCH_2 1
#include "printbench.c"
#undef PRINTBENCH_2

//

int main(int argc, char**argv)
{
  int loop, r, i;

  char *op_str[] = {xstr(crypto_secretbox,.csv),
                    xstr(crypto_secretbox_open,.csv),
                    xstr(crypto_secretbox_open,_forgery.csv)};

  uint8_t ciphertext[MAXINBYTES + CRYPTO_ZEROBYTES],
          plaintext[MAXINBYTES + CRYPTO_ZEROBYTES],
          nonce[CRYPTO_NONCEBYTES],
          key[CRYPTO_KEYBYTES];

  size_t len;

  uint64_t cycles[TIMINGS];
  uint64_t* results[OP][LOOPS];

  alloc_2(results, size_inc_32(MININBYTES,MAXINBYTES));

  for(loop = 0; loop < LOOPS; loop++)
  { for (len = MININBYTES, r = 0; len <= MAXINBYTES; len += inc_in(len), r += 1)
    { 
      // secretbox
      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_secretbox(ciphertext, plaintext , len + CRYPTO_ZEROBYTES, nonce, key); }
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

  cpucycles_fprintf_2(argc, results, op_str);
  free_2(results);

  return 0;
}

