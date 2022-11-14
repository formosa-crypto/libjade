#ifndef JADE_HASH_SHA3_512_AMD64_AVX2_API_H
#define JADE_HASH_SHA3_512_AMD64_AVX2_API_H

#define JADE_HASH_SHA3_512_AMD64_AVX2_BYTES 64

#define JADE_HASH_SHA3_512_AMD64_AVX2_ALGNAME "SHA3-512"
#define JADE_HASH_SHA3_512_AMD64_AVX2_ARCH    "amd64"
#define JADE_HASH_SHA3_512_AMD64_AVX2_IMPL    "avx2"

#include <stdint.h>

int jade_hash_sha3_512_amd64_avx2(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);

#endif
