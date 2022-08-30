#ifndef PRINTBENCH1_C
#define PRINTBENCH1_C

#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>

static void pb_print_1(int argc, uint64_t results[OP][LOOPS], char *op_str[])
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
  f = stdout;
  for (op = 0; op < OP; op++)
  { if(argc == 1) { f = fopen(op_str[op], "w"); }
    loop = 0;
    fprintf(f, "%" PRIu64 "\n", results[op][loop]);
    if(argc == 1) { fclose(f); }
  }
}

#endif
