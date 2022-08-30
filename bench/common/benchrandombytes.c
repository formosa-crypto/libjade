#ifndef BENCHRANDOMBYTES_C
#define BENCHRANDOMBYTES_C

#include <inttypes.h>
#include <stdlib.h>

extern void __jasmin_syscall_randombytes__(uint8_t *x, uint64_t xlen);

static void benchrandombytes(uint8_t *x, uint64_t xlen)
{
  __jasmin_syscall_randombytes__(x, xlen);
}

#endif
