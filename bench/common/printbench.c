#ifndef PRINTBENCH_H
#define PRINTBENCH_H

#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>

void alloc_3(uint64_t* results[OP][LOOPS], size_t _x)
{
  size_t o, l;
  for (o=0; o<OP; o++)
  { for (l=0; l<LOOPS; l++)
    { results[o][l] = (uint64_t*) malloc(sizeof(uint64_t) * _x); }
  }
}

void free_3(uint64_t* results[OP][LOOPS])
{
  size_t o, l;
  for (o=0; o<OP; o++)
  { for (l=0; l<LOOPS; l++)
    { free(results[o][l]); }
  }
}

void alloc_4(uint64_t** results[OP][LOOPS], size_t _x, size_t _y)
{
  size_t o, l, x;
  for (o=0; o<OP; o++)
  { for (l=0; l<LOOPS; l++)
    { results[o][l] = (uint64_t**) malloc(sizeof(uint64_t*) * _x);
      for (x=0; x<_x; x++)
      { results[o][l][x] = (uint64_t*) malloc(sizeof(uint64_t) * _y); }
    }
  }
}

void free_4(uint64_t** results[OP][LOOPS], size_t _x)
{
  size_t o, l, x;
  for (o=0; o<OP; o++)
  { for (l=0; l<LOOPS; l++)
    { for (x=0; x<_x; x++)
      { free(results[o][l][x]); } 
      free(results[o][l]);
    }
  }
}

static void cpucycles_fprintf_2(uint64_t results[OP][LOOPS], char *op_str[])
{
  int op, loop;
  uint64_t min;
  FILE *f;

  // get min median of LOOP runs
  for (op = 0; op < OP; op++)
  { min = results[op][0];
    for (loop = 1; loop < LOOPS; loop++)
    { if (min > results[op][loop])
      { min = results[op][loop]; } }
    results[op][0] = min;
  }

  // print to file
  for (op = 0; op < OP; op++)
  { f = fopen(op_str[op], "w");
    loop = 0;
    fprintf(f, "%" PRIu64 "\n", results[op][loop]);
    fclose(f);
  }
}

#ifdef MINBYTES
#ifdef MAXBYTES
static void cpucycles_fprintf_3(uint64_t* results[OP][LOOPS], char *op_str[])
{
  int op, loop, r;
  uint64_t len, min;
  double cpb;
  FILE *f;

  // get min median of LOOP runs
  for (len = MINBYTES, r=0; len <= MAXBYTES; len += inc(len), r +=1)
  { for (op = 0; op < OP; op++)
    { min = results[op][0][r];
      for (loop = 1; loop < LOOPS; loop++)
      { if (min > results[op][loop][r])
        { min = results[op][loop][r]; } }
      results[op][0][r] = min;
    }
  }

  // print to file
  for (op = 0; op < OP; op++)
  { f = fopen(op_str[op], "w");
    loop = 0;
    for (len = MINBYTES, r=0; len <= MAXBYTES; len += inc(len), r +=1)
    { cpb = ((double)results[op][loop][r]) / ((double)len);
      fprintf(f, "%" PRIu64 ", %" PRIu64 ", %.2f\n", len, results[op][loop][r], cpb ); }
    fclose(f);
  }
}
#endif
#endif

#ifdef MINOUTBYTES
#ifdef MAXOUTBYTES
#ifdef MINBYTES
#ifdef MAXBYTES
static void cpucycles_fprintf_4(uint64_t** results[OP][LOOPS], char *op_str[])
{
  int op, loop, r0, r1;
  uint64_t outlen, inlen, min;
  double cpb;
  FILE *f;

  // get min median of LOOP runs
  for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen += inc_out(outlen), r0 += 1)
  { for (inlen = MINBYTES, r1 = 0; inlen <= MAXBYTES; inlen += inc(inlen), r1 += 1)
    { for (op = 0; op < OP; op++)
      { min = results[op][0][r0][r1];
        for (loop = 1; loop < LOOPS; loop++)
        { if (min > results[op][loop][r0][r1])
          { min = results[op][loop][r0][r1]; } }
        results[op][0][r0][r1] = min;
      }
    }
  }

  // print to file
  for (op = 0; op < OP; op++)
  { f = fopen(op_str[op], "w");
    loop = 0;
    for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen += inc_out(outlen), r0 += 1)
    { for (inlen = MINBYTES, r1 = 0; inlen <= MAXBYTES; inlen += inc(inlen), r1 += 1)
      { cpb = ((double)results[op][loop][r0][r1]) / ((double)inlen); // cycles per input byte
        fprintf(f, "%" PRIu64 ", %" PRIu64 ", %" PRIu64 ", %.2f\n", outlen, inlen, results[op][loop][r0][r1], cpb ); }
    }
    fclose(f);
  }
}
#endif
#endif
#endif
#endif

#endif

