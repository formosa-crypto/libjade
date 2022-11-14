#ifndef JADE_HASH_SHA256_AMD64_REF_API_H
#define JADE_HASH_SHA256_AMD64_REF_API_H

#define JADE_HASH_SHA256_AMD64_REF_BYTES 32

#define JADE_HASH_SHA256_AMD64_REF_ALGNAME "SHA256"
#define JADE_HASH_SHA256_AMD64_REF_ARCH    "amd64"
#define JADE_HASH_SHA256_AMD64_REF_IMPL    "ref"

#include <stdint.h>

int jade_hash_sha256_amd64_ref(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);

#endif
