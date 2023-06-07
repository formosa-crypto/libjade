#ifndef JADE_ONETIMEAUTH_poly1305_amd64_ref_API_H
#define JADE_ONETIMEAUTH_poly1305_amd64_ref_API_H

#define JADE_ONETIMEAUTH_poly1305_amd64_ref_BYTES 16
#define JADE_ONETIMEAUTH_poly1305_amd64_ref_KEYBYTES 32

#define JADE_ONETIMEAUTH_poly1305_amd64_ref_ALGNAME "Poly1305"
#define JADE_ONETIMEAUTH_poly1305_amd64_ref_ARCH    "amd64"
#define JADE_ONETIMEAUTH_poly1305_amd64_ref_IMPL    "ref"

#include <stdint.h>

int jade_onetimeauth_poly1305_amd64_ref(
 uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

int jade_onetimeauth_poly1305_amd64_ref_verify(
 const uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

#endif
