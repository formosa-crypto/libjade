#ifndef RANDOMBYTES_H
#define RANDOMBYTES_H

// replace this with chacha20

#include <stdint.h>
#include <stddef.h>

typedef uint32_t uint32;

int randombytes(uint8_t *x, size_t xlen);

#endif

