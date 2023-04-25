#ifndef JADE_HASH_sha3_512_amd64_ref1_API_H
#define JADE_HASH_sha3_512_amd64_ref1_API_H

#define JADE_HASH_sha3_512_amd64_ref1_BYTES 64

#define JADE_HASH_sha3_512_amd64_ref1_ALGNAME "SHA3-512"
#define JADE_HASH_sha3_512_amd64_ref1_ARCH    "amd64"
#define JADE_HASH_sha3_512_amd64_ref1_IMPL    "ref1"

#include <stdint.h>

int jade_hash_sha3_512_amd64_ref1(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);

#endif
