#ifndef JADE_HASH_SHA3_224_AMD64_BMI1_API_H
#define JADE_HASH_SHA3_224_AMD64_BMI1_API_H

#define JADE_HASH_SHA3_224_AMD64_BMI1_BYTES 28
#define JADE_HASH_SHA3_224_AMD64_BMI1_ALGNAME "SHA3-224"
#define JADE_HASH_SHA3_224_AMD64_BMI1_ARCH    "amd64"
#define JADE_HASH_SHA3_224_AMD64_BMI1_IMPL    "bmi1"

#include <stdint.h>

int jade_hash_sha3_224_amd64_bmi1(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);

#endif
