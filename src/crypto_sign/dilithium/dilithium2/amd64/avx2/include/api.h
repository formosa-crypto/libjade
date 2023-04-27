#ifndef JADE_SIGN_dilithium_dilithium2_amd64_avx2_API_H
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_API_H

#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_PUBLICKEYBYTES   1312
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_SECRETKEYBYTES   2528
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_BYTES            2420
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_KEYPAIRCOINBYTES 32
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_DETERMINISTIC    1

#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_ALGNAME         "Dilithium2"
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_ARCH            "amd64"
#define JADE_SIGN_dilithium_dilithium2_amd64_avx2_IMPL            "avx2"

#include <stdint.h>

int jade_sign_dilithium_dilithium2_amd64_avx2_keypair_derand(
  uint8_t *public_key,
  uint8_t *secret_key,
  const uint8_t *coins
);

int jade_sign_dilithium_dilithium2_amd64_avx2_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign_dilithium_dilithium2_amd64_avx2(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_dilithium_dilithium2_amd64_avx2_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);

#endif

