#ifndef PRINTBENCH2_C
#define PRINTBENCH2_C

#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>

void pb_alloc_2(uint64_t* results[OP][LOOPS], size_t _x)
{
  size_t o, l;
  for (o=0; o<OP; o++)
  { for (l=0; l<LOOPS; l++)
    { results[o][l] = (uint64_t*) malloc(sizeof(uint64_t) * _x); }
  }
}

void pb_free_2(uint64_t* results[OP][LOOPS])
{
  size_t o, l;
  for (o=0; o<OP; o++)
  { for (l=0; l<LOOPS; l++)
    { free(results[o][l]); }
  }
}

static void pb_print_2(int argc, uint64_t* results[OP][LOOPS], char *op_str[])
{
  int op, loop, r;
  uint64_t len, min;
  double cpb;
  FILE *f;

  // get min median of LOOP runs
  for (len = MININBYTES, r=0; len <= MAXINBYTES; len += inc_in(len), r +=1)
  { for (op = 0; op < OP; op++)
    { min = results[op][0][r];
      for (loop = 1; loop < LOOPS; loop++)
      { if (min > results[op][loop][r])
        { min = results[op][loop][r]; } }
      results[op][0][r] = min;
    }
  }

  // print to file
  f = stdout;
  for (op = 0; op < OP; op++)
  { if(argc == 1) { f = fopen(op_str[op], "w"); }
    loop = 0;
    for (len = MININBYTES, r=0; len <= MAXINBYTES; len += inc_in(len), r +=1)
    { if(len == 0)
      { fprintf(f, "%" PRIu64 ", %" PRIu64 ", undef\n", len, results[op][loop][r]); }
      else
      { cpb = ((double)results[op][loop][r]) / ((double)len);
        fprintf(f, "%" PRIu64 ", %" PRIu64 ", %.2f\n", len, results[op][loop][r], cpb );
      }
    }
    if(argc == 1) { fclose(f); }
  }
}

#endif
