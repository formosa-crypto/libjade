#ifndef JADE_SCALARMULT_CURVE25519_AMD64_REF4_API_H
#define JADE_SCALARMULT_CURVE25519_AMD64_REF4_API_H

#define JADE_SCALARMULT_CURVE25519_AMD64_REF4_BYTES 32
#define JADE_SCALARMULT_CURVE25519_AMD64_REF4_SCALARBYTES 32
#define JADE_SCALARMULT_CURVE25519_AMD64_REF4_ALGNAME "Curve25519"

#include <stdint.h>

int jade_scalarmult_curve25519_amd64_ref4(
 uint8_t *r,
 uint8_t *k,
 uint8_t *u
);

int jade_scalarmult_curve25519_amd64_ref4_base(
 uint8_t *r,
 uint8_t *k
);

int jade_scalarmult_curve25519_amd64_ref4_base(
 uint8_t *r,
 uint8_t *k
)
{
  uint8_t basepoint[32] = {9};
  int res = jade_scalarmult_curve25519_amd64_ref4(r,k,basepoint);
  return res;
}

#endif
