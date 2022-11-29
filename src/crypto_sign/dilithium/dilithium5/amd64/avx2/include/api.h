#ifndef JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_API_H
#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_API_H

#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_PUBLICKEYBYTES  2592
#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_SECRETKEYBYTES  4864
#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_BYTES           4595
#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_DETERMINISTIC   1

#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_ALGNAME         "Dilithium5"
#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_ARCH            "amd64"
#define JADE_SIGN_DILITHIUM_DILITHIUM5_AMD64_AVX2_IMPL            "avx2"

#include <stdint.h>

int jade_sign_dilithium_dilithium5_amd64_avx2_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign_dilithium_dilithium5_amd64_avx2(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_dilithium_dilithium5_amd64_avx2_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);

#endif

