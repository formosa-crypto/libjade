#ifndef JADE_XOF_shake256_amd64_mmx1_API_H
#define JADE_XOF_shake256_amd64_mmx1_API_H

#define JADE_XOF_shake256_amd64_mmx1_ALGNAME "SHAKE256"
#define JADE_XOF_shake256_amd64_mmx1_ARCH    "amd64"
#define JADE_XOF_shake256_amd64_mmx1_IMPL    "mmx1"

#include <stdint.h>

int jade_xof_shake256_amd64_mmx1(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);

#endif
