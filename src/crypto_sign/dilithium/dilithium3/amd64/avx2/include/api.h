#ifndef JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_API_H
#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_API_H

#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_PUBLICKEYBYTES  1952
#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_SECRETKEYBYTES  4016
#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_BYTES           3293
#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_DETERMINISTIC   1

#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_ALGNAME         "Dilithium3"
#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_ARCH            "amd64"
#define JADE_SIGN_DILITHIUM_DILITHIUM3_AMD64_AVX2_IMPL            "avx2"

#include <stdint.h>

int jade_sign_dilithium_dilithium3_amd64_avx2_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign_dilithium_dilithium3_amd64_avx2(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_dilithium_dilithium3_amd64_avx2_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);

#endif

