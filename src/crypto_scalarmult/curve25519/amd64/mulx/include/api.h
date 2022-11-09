#ifndef JADE_SCALARMULT_CURVE25519_AMD64_MULX_API_H
#define JADE_SCALARMULT_CURVE25519_AMD64_MULX_API_H

#define JADE_SCALARMULT_CURVE25519_AMD64_MULX_BYTES 32
#define JADE_SCALARMULT_CURVE25519_AMD64_MULX_SCALARBYTES 32

#define JADE_SCALARMULT_CURVE25519_AMD64_MULX_ALGNAME "Curve25519"
#define JADE_SCALARMULT_CURVE25519_AMD64_MULX_ARCH    "amd64"
#define JADE_SCALARMULT_CURVE25519_AMD64_MULX_IMPL    "mulx"

#include <stdint.h>

int jade_scalarmult_curve25519_amd64_mulx(
 uint8_t *r,
 uint8_t *k,
 uint8_t *u
);

int jade_scalarmult_curve25519_amd64_mulx_base(
 uint8_t *r,
 uint8_t *k
);

#endif
