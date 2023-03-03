#ifndef NOTRANDOMBYTES_H
#define NOTRANDOMBYTES_H

#include <stdint.h>

void resetrandombytes(void);
void randombytes(uint8_t* x, uint64_t xlen);

#endif
