#ifndef JADE_ONETIMEAUTH_poly1305_amd64_avx_API_H
#define JADE_ONETIMEAUTH_poly1305_amd64_avx_API_H

#define JADE_ONETIMEAUTH_poly1305_amd64_avx_BYTES 16
#define JADE_ONETIMEAUTH_poly1305_amd64_avx_KEYBYTES 32

#define JADE_ONETIMEAUTH_poly1305_amd64_avx_ALGNAME "Poly1305"
#define JADE_ONETIMEAUTH_poly1305_amd64_avx_ARCH    "amd64"
#define JADE_ONETIMEAUTH_poly1305_amd64_avx_IMPL    "avx"

#include <stdint.h>

int jade_onetimeauth_poly1305_amd64_avx(
 uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

int jade_onetimeauth_poly1305_amd64_avx_verify(
 const uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

#endif
