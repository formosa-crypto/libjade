#include "notrandombytes.h"
#include "jasmin_notrandombytes.h"

uint8_t* __jasmin_syscall_randombytes__(uint8_t* x, uint64_t xlen)
{
  randombytes(x, xlen);
  return x;
}
