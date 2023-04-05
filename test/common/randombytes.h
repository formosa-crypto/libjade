// this is a 'fake' entry point for randombytes.h to test /*/functest.c (which is part of the distribution, which uses ext/*randombytes.h

#ifndef JASMIN_RANDOMBYTES_H
#define JASMIN_RANDOMBYTES_H

#include <stdint.h>

#include "jasmin_notrandombytes.h"

void randombytes(uint8_t* _x, uint64_t xlen);

#endif


