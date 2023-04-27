#ifndef JADE_SIGN_dilithium_dilithium5_amd64_ref_API_H
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_API_H

#define JADE_SIGN_dilithium_dilithium5_amd64_ref_PUBLICKEYBYTES   2592
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_SECRETKEYBYTES   4864
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_BYTES            4595
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_KEYPAIRCOINBYTES 32
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_DETERMINISTIC    1

#define JADE_SIGN_dilithium_dilithium5_amd64_ref_ALGNAME         "Dilithium5"
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_ARCH            "amd64"
#define JADE_SIGN_dilithium_dilithium5_amd64_ref_IMPL            "ref"

#include <stdint.h>

int jade_sign_dilithium_dilithium5_amd64_ref_keypair_derand(
  uint8_t *public_key,
  uint8_t *secret_key,
  const uint8_t *coins
);

int jade_sign_dilithium_dilithium5_amd64_ref_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign_dilithium_dilithium5_amd64_ref(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_dilithium_dilithium5_amd64_ref_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);

#endif

