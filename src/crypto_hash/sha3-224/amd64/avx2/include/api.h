#ifndef JADE_HASH_sha3_224_amd64_avx2_API_H
#define JADE_HASH_sha3_224_amd64_avx2_API_H

#define JADE_HASH_sha3_224_amd64_avx2_BYTES 28

#define JADE_HASH_sha3_224_amd64_avx2_ALGNAME "SHA3-224"
#define JADE_HASH_sha3_224_amd64_avx2_ARCH    "amd64"
#define JADE_HASH_sha3_224_amd64_avx2_IMPL    "avx2"

#include <stdint.h>

int jade_hash_sha3_224_amd64_avx2(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);

#endif
