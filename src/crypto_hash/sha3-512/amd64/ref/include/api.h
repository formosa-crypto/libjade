#ifndef JADE_HASH_sha3_512_amd64_ref_API_H
#define JADE_HASH_sha3_512_amd64_ref_API_H

#define JADE_HASH_sha3_512_amd64_ref_BYTES 64

#define JADE_HASH_sha3_512_amd64_ref_ALGNAME "SHA3-512"
#define JADE_HASH_sha3_512_amd64_ref_ARCH    "amd64"
#define JADE_HASH_sha3_512_amd64_ref_IMPL    "ref"

#include <stdint.h>

int jade_hash_sha3_512_amd64_ref(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);

#endif
