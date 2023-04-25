#ifndef JADE_XOF_shake256_amd64_ref_API_H
#define JADE_XOF_shake256_amd64_ref_API_H

#define JADE_XOF_shake256_amd64_ref_ALGNAME "SHAKE256"
#define JADE_XOF_shake256_amd64_ref_ARCH    "amd64"
#define JADE_XOF_shake256_amd64_ref_IMPL    "ref"

#include <stdint.h>

int jade_xof_shake256_amd64_ref(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);

#endif
