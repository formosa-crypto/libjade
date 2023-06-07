#ifndef JADE_XOF_shake128_amd64_avx2_API_H
#define JADE_XOF_shake128_amd64_avx2_API_H

#define JADE_XOF_shake128_amd64_avx2_ALGNAME "SHAKE128"
#define JADE_XOF_shake128_amd64_avx2_ARCH    "amd64"
#define JADE_XOF_shake128_amd64_avx2_IMPL    "avx2"

#include <stdint.h>

int jade_xof_shake128_amd64_avx2(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);

#endif
