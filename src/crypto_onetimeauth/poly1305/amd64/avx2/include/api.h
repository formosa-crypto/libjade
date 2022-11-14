#ifndef JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_API_H
#define JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_API_H

#define JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_BYTES 16
#define JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_KEYBYTES 32

#define JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_ALGNAME "Poly1305"
#define JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_ARCH    "amd64"
#define JADE_ONETIMEAUTH_POLY1305_AMD64_AVX2_IMPL    "avx2"

#include <stdint.h>

int jade_onetimeauth_poly1305_amd64_avx2(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

int jade_onetimeauth_poly1305_amd64_avx2_verify(
 const uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

#endif
