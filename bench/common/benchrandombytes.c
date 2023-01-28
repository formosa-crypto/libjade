#ifndef BENCHRANDOMBYTES_C
#define BENCHRANDOMBYTES_C

#include <inttypes.h>
#include <stdlib.h>

extern uint8_t* __jasmin_syscall_randombytes__(uint8_t* x, uint64_t xlen);

static uint8_t* benchrandombytes(uint8_t* x, uint64_t xlen)
{
  x = __jasmin_syscall_randombytes__(x, xlen);
  return x;
}

#endif
