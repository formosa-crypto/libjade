#ifndef JADE_HASH_SHA512_AMD64_REF_API_H
#define JADE_HASH_SHA512_AMD64_REF_API_H

#define JADE_HASH_SHA512_AMD64_REF_BYTES 64

#define JADE_HASH_SHA512_AMD64_REF_ALGNAME "SHA512"
#define JADE_HASH_SHA512_AMD64_REF_ARCH    "amd64"
#define JADE_HASH_SHA512_AMD64_REF_IMPL    "ref"

#include <stdint.h>

int jade_hash_sha512_amd64_ref(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length
);

#endif
