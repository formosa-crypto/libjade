#ifndef JADE_XOF_SHAKE256_AMD64_REF1_API_H
#define JADE_XOF_SHAKE256_AMD64_REF1_API_H

#define JADE_XOF_SHAKE256_AMD64_REF1_ALGNAME "SHAKE256"
#define JADE_XOF_SHAKE256_AMD64_REF1_ARCH    "amd64"
#define JADE_XOF_SHAKE256_AMD64_REF1_IMPL    "ref1"

#include <stdint.h>

int jade_xof_shake256_amd64_ref1(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);

#endif
