#include <stdint.h>

#include "randombytes.h"

uint8_t* __jasmin_syscall_randombytes__(uint8_t* _x, uint64_t xlen);

void randombytes(uint8_t* x, uint64_t xlen)
{
  __jasmin_syscall_randombytes__(x, xlen);
}


