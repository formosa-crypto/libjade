#ifndef JADE_SCALARMULT_curve25519_amd64_ref4_API_H
#define JADE_SCALARMULT_curve25519_amd64_ref4_API_H

#define JADE_SCALARMULT_curve25519_amd64_ref4_BYTES 32
#define JADE_SCALARMULT_curve25519_amd64_ref4_SCALARBYTES 32

#define JADE_SCALARMULT_curve25519_amd64_ref4_ALGNAME "Curve25519"
#define JADE_SCALARMULT_curve25519_amd64_ref4_ARCH    "amd64"
#define JADE_SCALARMULT_curve25519_amd64_ref4_IMPL    "ref4"

#include <stdint.h>

int jade_scalarmult_curve25519_amd64_ref4(
 uint8_t *q,
 const uint8_t *n,
 const uint8_t *p
);

int jade_scalarmult_curve25519_amd64_ref4_base(
 uint8_t *q,
 const uint8_t *n
);

#endif
