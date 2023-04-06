#ifndef PRINTBENCH_C
#define PRINTBENCH_C

#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>

#include "min.c"

// ////////////////////////////////////////////////////////////////////////////

#if defined(OP1)
static void pb_init_1(int argc, char *op_str[])
{
  int op;
  FILE *f;

  if(argc == 1)
  { for (op = 0; op < OP1; op++)
    { f = fopen(op_str[op], "w");
      fclose(f);
    }
  }
}

static void pb_print_1(
  int argc,
  uint64_t results[OP1][LOOPS],
  char *op_str[],
  char *op_str_short[])
{
  int op, loop;
  FILE *f;

  min_1(results);

  // print to file
  f = stdout;
  for (op = 0; op < OP1; op++)
  { if(argc == 1) { f = fopen(op_str[op], "a"); }
    else          { fprintf(f, "%s, ", op_str_short[op]); }
    loop = 0;
    fprintf(f, "%" PRIu64 "\n", results[op][loop]);
    if(argc == 1) { fclose(f); }
  }
}
#endif

// ////////////////////////////////////////////////////////////////////////////

#if defined(OP2)
static void pb_init_2(int argc, char *op_str[])
{
  int op;
  FILE *f;

  if(argc == 1)
  { for (op = 0; op < OP2; op++)
    { f = fopen(op_str[op], "w");
      fclose(f);
    }
  }
}

static void pb_alloc_2(uint64_t* results[OP2][LOOPS], size_t _x)
{
  size_t o, l;
  for (o=0; o<OP2; o++)
  { for (l=0; l<LOOPS; l++)
    { results[o][l] = (uint64_t*) malloc(sizeof(uint64_t) * _x); }
  }
}

static void pb_free_2(uint64_t* results[OP2][LOOPS])
{
  size_t o, l;
  for (o=0; o<OP2; o++)
  { for (l=0; l<LOOPS; l++)
    { free(results[o][l]); }
  }
}

static void pb_print_2(int argc, uint64_t* results[OP2][LOOPS], char *op_str[])
{
  int op, loop, r;
  uint64_t len;
  double cpb;
  FILE *f;

  min_2(results);

  // print to file
  f = stdout;
  for (op = 0; op < OP2; op++)
  { if(argc == 1) { f = fopen(op_str[op], "a"); }
    loop = 0;
    for (len = MININBYTES, r=0; len <= MAXINBYTES; len = inc_in(len), r +=1)
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

// ////////////////////////////////////////////////////////////////////////////

#if defined(OP3)
static void pb_init_3(int argc, char *op_str[])
{
  int op;
  FILE *f;

  if(argc == 1)
  { for (op = 0; op < OP3; op++)
    { f = fopen(op_str[op], "w");
      fclose(f);
    }
  }
}

static void pb_alloc_3(uint64_t** results[OP3][LOOPS], size_t _x, size_t _y)
{
  size_t o, l, x;
  for (o=0; o<OP3; o++)
  { for (l=0; l<LOOPS; l++)
    { results[o][l] = (uint64_t**) malloc(sizeof(uint64_t*) * _x);
      for (x=0; x<_x; x++)
      { results[o][l][x] = (uint64_t*) malloc(sizeof(uint64_t) * _y); }
    }
  }
}

static void pb_free_3(uint64_t** results[OP3][LOOPS], size_t _x)
{
  size_t o, l, x;
  for (o=0; o<OP3; o++)
  { for (l=0; l<LOOPS; l++)
    { for (x=0; x<_x; x++)
      { free(results[o][l][x]); }
      free(results[o][l]);
    }
  }
}

static void pb_print_3(int argc, uint64_t** results[OP3][LOOPS], char *op_str[])
{
  int op, loop, r0, r1;
  uint64_t outlen, inlen;
  double cpb;
  FILE *f;

  min_3(results);

  // print to file
  f = stdout;
  for (op = 0; op < OP3; op++)
  { if(argc == 1) { f = fopen(op_str[op], "a"); }
    loop = 0;
    for (outlen = MINOUTBYTES, r0 = 0; outlen <= MAXOUTBYTES; outlen = inc_out(outlen), r0 += 1)
    { for (inlen = MININBYTES, r1 = 0; inlen <= MAXINBYTES; inlen = inc_in(inlen), r1 += 1)
      { if(inlen == 0)
        { fprintf(f, "%" PRIu64 ", %" PRIu64 ", %" PRIu64 ", undef\n", outlen, inlen, results[op][loop][r0][r1]); }
        else
        { cpb = ((double)results[op][loop][r0][r1]) / ((double)inlen); // cycles per input byte
          fprintf(f, "%" PRIu64 ", %" PRIu64 ", %" PRIu64 ", %.2f\n", outlen, inlen, results[op][loop][r0][r1], cpb );
        }
      }
    }
    if(argc == 1) { fclose(f); }
  }
}
#endif

#endif
