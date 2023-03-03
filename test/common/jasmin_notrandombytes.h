#ifndef JASMIN_NOTRANDOMBYTES_H
#define JASMIN_NOTRANDOMBYTES_H

#include <stdint.h>

uint8_t* __jasmin_syscall_randombytes__(uint8_t* _x, uint64_t xlen) __asm__("__jasmin_syscall_randombytes__");

#endif
