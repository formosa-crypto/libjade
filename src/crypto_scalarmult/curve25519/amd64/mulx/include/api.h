#ifndef JADE_SCALARMULT_curve25519_amd64_mulx_API_H
#define JADE_SCALARMULT_curve25519_amd64_mulx_API_H

#define JADE_SCALARMULT_curve25519_amd64_mulx_BYTES 32
#define JADE_SCALARMULT_curve25519_amd64_mulx_SCALARBYTES 32

#define JADE_SCALARMULT_curve25519_amd64_mulx_ALGNAME "Curve25519"
#define JADE_SCALARMULT_curve25519_amd64_mulx_ARCH    "amd64"
#define JADE_SCALARMULT_curve25519_amd64_mulx_IMPL    "mulx"

#include <stdint.h>

int jade_scalarmult_curve25519_amd64_mulx(
 uint8_t *q,
 const uint8_t *n,
 const uint8_t *p
);

int jade_scalarmult_curve25519_amd64_mulx_base(
 uint8_t *q,
 const uint8_t *n
);

#endif
