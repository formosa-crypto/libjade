#ifndef INCREMENT_H
#define INCREMENT_H

// +1 @ {1..63} ; +2 @ {64..127}; +4 @ {128..256} 
static uint64_t _inc_32_1(uint64_t len)
{
  uint64_t b = 0;
  len >>= 1;
  while(len){ b += 1; len >>=1;  }
  if(b < 6)
  { return 1; }
  b -= 5;
  b = 1 << b;
  return b;
}

//== _inc_32_1
static uint64_t _inc_32_2(uint64_t len)
{
  uint64_t b;
  b = len;
  b |= b >> 1;
  b |= b >> 2;
  b |= b >> 4;
  b |= b >> 8;
  b |= b >> 16;
  b |= b >> 32;
  b  = ((b + 1) >> 1) | (b & (((uint64_t)1) << 63));
  b = (b >> 5 == 0) ? 1 : b >> 5;
  return b;
}

static size_t inc_32(size_t len)
{
  return _inc_32_2(len);
}

static size_t size_inc_32(size_t start, size_t end)
{
  size_t i, r=0;
  for(i = start; i <= end; i+= inc_32(i))
  { r += 1; }
  return r;
}

//

static uint64_t inc_4(uint64_t len)
{
  uint64_t b;
  b = len;
  b |= b >> 1;
  b |= b >> 2;
  b |= b >> 4;
  b |= b >> 8;
  b |= b >> 16;
  b |= b >> 32;
  b  = ((b + 1) >> 1) | (b & (((uint64_t)1) << 63));
  b = (b >> 5 == 0) ? 8 : b >> 2;
  return b;
}

static size_t size_inc_4(size_t start, size_t end)
{
  size_t i, r=0;
  for(i = start; i <= end; i+= inc_4(i))
  { r += 1; }
  return r;
}

#endif

