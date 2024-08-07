#ifndef JADE_SCALARMULT_curve25519_amd64_ref5_API_H
#define JADE_SCALARMULT_curve25519_amd64_ref5_API_H

#define JADE_SCALARMULT_curve25519_amd64_ref5_BYTES 32
#define JADE_SCALARMULT_curve25519_amd64_ref5_SCALARBYTES 32

#define JADE_SCALARMULT_curve25519_amd64_ref5_ALGNAME "Curve25519"
#define JADE_SCALARMULT_curve25519_amd64_ref5_ARCH    "amd64"
#define JADE_SCALARMULT_curve25519_amd64_ref5_IMPL    "ref5"

#include <stdint.h>

int jade_scalarmult_curve25519_amd64_ref5(
 uint8_t *q,
 const uint8_t *n,
 const uint8_t *p
);

int jade_scalarmult_curve25519_amd64_ref5_base(
 uint8_t *q,
 const uint8_t *n
);

#endif
