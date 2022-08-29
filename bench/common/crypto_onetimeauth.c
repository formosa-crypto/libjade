#include "api.h"
#include "randombytes.h"
#include "namespace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//

#define CRYPTO_BYTES NAMESPACE(BYTES)
#define CRYPTO_KEYBYTES NAMESPACE(KEYBYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_onetimeauth_verify NAMESPACE_LC(verify)
#define crypto_onetimeauth JADE_NAMESPACE_LC

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

#define OP 2

//

#include "cpucycles.c"
#include "increment.c"
#define inc_in inc_32
#include "printbench2.c"
#include "alignedcalloc.c"

//

int main(int argc, char**argv)
{
  int loop, r, i;
  uint64_t cycles[TIMINGS];
  uint64_t* results[OP][LOOPS];
  char *op_str[] = {xstr(crypto_onetimeauth,.csv),
                    xstr(crypto_onetimeauth_verify,.csv)};

  uint8_t *_out, *out; // CRYPTO_BYTES
  uint8_t *_in, *in; // MAXINBYTES
  uint8_t *_key, *key; // CRYPTO_KEYBYTES
  size_t len;

  pb_alloc_2(results, size_inc_32(MININBYTES,MAXINBYTES));

  out = alignedcalloc(&_out, CRYPTO_BYTES);
  in = alignedcalloc(&_in, MAXINBYTES);
  key = alignedcalloc(&_key, MAXINBYTES);

  for(loop = 0; loop < LOOPS; loop++)
  { for (len = MININBYTES, r = 0; len <= MAXINBYTES; len += inc_in(len), r += 1)
    { for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_onetimeauth(out, in, len, key); }
      results[0][loop][r] = cpucycles_median(cycles, TIMINGS);

      for (i = 0; i < TIMINGS; i++)
      { cycles[i] = cpucycles();
        crypto_onetimeauth_verify(out, in, len, key); }
      results[1][loop][r] = cpucycles_median(cycles, TIMINGS);
    }
  }

  pb_print_2(argc, results, op_str);
  pb_free_2(results);

  free(_in);
  free(_out);
  free(_key);

  return 0;
}

