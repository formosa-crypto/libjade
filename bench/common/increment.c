#ifndef INCREMENT_C
#define INCREMENT_C

#include <stdlib.h>
#include "namespace.h"



// iter by 1
static size_t inc_1(size_t len)
{
  return len += 1;
}

static size_t size_inc_1(size_t start, size_t end)
{
  return end - start + 1;
}



// iter by <<1
static size_t inc_2(size_t len)
{
  if(len == 0)
  { return 1; }
  return len << 1;
}

static size_t size_inc_2(size_t start, size_t end)
{
  size_t i, r=0;
  for(i = start; i <= end; i = inc_2(i))
  { r += 1; }
  return r;
}



// iter 32 values in between each 2^n (plots)
static size_t inc_3(size_t len)
{
  size_t b;
  b = len;
  b |= b >> 1;
  b |= b >> 2;
  b |= b >> 4;
  b |= b >> 8;
  b |= b >> 16;
  b |= b >> 32;
  b  = ((b + 1) >> 1) | (b & (((size_t)1) << 63));
  b = (b >> 5 == 0) ? 1 : b >> 5;
  return len + b;
}

static size_t size_inc_3(size_t start, size_t end)
{
  size_t i, r=0;
  for(i = start; i <= end; i = inc_3(i))
  { r += 1; }
  return r;
}




#ifndef INC_IN
#define INC_IN 2
#endif

#ifndef INC_OUT
#define INC_OUT 2
#endif

#define inc_in EVALUATOR(inc,INC_IN)
#define size_inc_in EVALUATOR(size_inc,INC_IN)

#define inc_out EVALUATOR(inc,INC_OUT)
#define size_inc_out EVALUATOR(size_inc,INC_OUT)

#endif
