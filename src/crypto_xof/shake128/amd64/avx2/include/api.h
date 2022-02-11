#ifndef JADE_XOF_SHAKE128_AMD64_AVX2_API_H
#define JADE_XOF_SHAKE128_AMD64_AVX2_API_H

//TODO REMOVE BYTES
#define JADE_XOF_SHAKE128_AMD64_AVX2_BYTES 168
#define JADE_XOF_SHAKE128_AMD64_AVX2_ALGNAME "SHAKE128"

#include <stdint.h>

int jade_xof_shake128_amd64_avx2(
 uint8_t *out,
 uint64_t outlen,
 uint8_t *in,
 uint64_t inlen
);

#endif
