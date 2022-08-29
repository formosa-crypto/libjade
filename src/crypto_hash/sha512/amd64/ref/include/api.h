#ifndef JADE_HASH_SHA512_AMD64_REF_API_H
#define JADE_HASH_SHA512_AMD64_REF_API_H

#define JADE_HASH_SHA512_AMD64_REF_BYTES 64
#define JADE_HASH_SHA512_AMD64_REF_ALGNAME "SHA512"

#include <stdint.h>

int jade_hash_sha512_amd64_ref(
 uint8_t *out,
 uint8_t *in,
 uint64_t length
);

#endif
