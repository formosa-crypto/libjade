#ifndef LIBJADE_RANDOMBYTES_H
#define LIBJADE_RANDOMBYTES_H

#include <stdint.h>

uint8_t* __jasmin_syscall_randombytes__(uint8_t* x, uint64_t xlen);
//asm("__jasmin_syscall_randombytes__");

#endif
