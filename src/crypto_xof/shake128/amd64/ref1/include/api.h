#ifndef JADE_XOF_shake128_amd64_ref1_API_H
#define JADE_XOF_shake128_amd64_ref1_API_H

#define JADE_XOF_shake128_amd64_ref1_ALGNAME "SHAKE128"
#define JADE_XOF_shake128_amd64_ref1_ARCH    "amd64"
#define JADE_XOF_shake128_amd64_ref1_IMPL    "ref1"

#include <stdint.h>

int jade_xof_shake128_amd64_ref1(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);

#endif
