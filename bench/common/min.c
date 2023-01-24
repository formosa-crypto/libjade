#ifndef MIN_C
#define MIN_C

#include <inttypes.h>

#include "increment.c"

#if defined(OP1)
static void min_1(uint64_t results[OP1][LOOPS])
{
  int op, loop;
  uint64_t min;

  // write min median of LOOP in results[op][0]
  for (op = 0; op < OP1; op++)
  { min = results[op][0];
    for (loop = 1; loop < LOOPS; loop++)
    { if (min > results[op][loop])
      { min = results[op][loop]; } }
    results[op][0] = min;
  }
}
#endif

#if defined(OP2)
static void min_2(uint64_t* results[OP2][LOOPS])
{
  int op, loop, r;
  uint64_t len, min;

  // get min median of LOOP runs
  for (len = MININBYTES, r=0; len <= MAXINBYTES; len = inc_in(len), r +=1)
  { for (op = 0; op < OP2; op++)
    { min = results[op][0][r];
      for (loop = 1; loop < LOOPS; loop++)
      { if (min > results[op][loop][r])
        { min = results[op][loop][r]; } }
      results[op][0][r] = min;
    }
  }
}
#endif

#if defined(OP3)
static void min_3(uint64_t** results[OP3][LOOPS])
{
  int op, loop, r0, r1;
  uint64_t outlen, inlen, min;

  // get min median of LOOP runs
  for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen = inc_out(outlen), r0 += 1)
  { for (inlen = MININBYTES, r1 = 0; inlen <= MAXINBYTES; inlen = inc_in(inlen), r1 += 1)
    { for (op = 0; op < OP3; op++)
      { min = results[op][0][r0][r1];
        for (loop = 1; loop < LOOPS; loop++)
        { if (min > results[op][loop][r0][r1])
          { min = results[op][loop][r0][r1]; } }
        results[op][0][r0][r1] = min;
      }
    }
  }
}
#endif

#endif
