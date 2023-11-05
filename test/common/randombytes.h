#ifndef NOTRANDOMBYTES_H
#define NOTRANDOMBYTES_H

#include <stdint.h>
#include <stddef.h>

void resetrandombytes(void);
void randombytes(uint8_t* x, size_t xlen);

void resetrandombytes1(void);
void randombytes1(uint8_t* x, size_t xlen);

//

uint8_t* __jasmin_syscall_randombytes__(uint8_t* _x, size_t xlen) __asm__("__jasmin_syscall_randombytes__");


#endif


