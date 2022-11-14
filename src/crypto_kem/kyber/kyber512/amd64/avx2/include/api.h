#ifndef JADE_KEM_KYBER_KYBER512_AMD64_AVX2_API_H
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_API_H

#include <stdint.h>

#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_SECRETKEYBYTES  1632
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_PUBLICKEYBYTES  800
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_CIPHERTEXTBYTES 768
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_BYTES           32

#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_ALGNAME         "Kyber512"
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_ARCH            "amd64"
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_IMPL            "avx2"

int jade_kem_kyber_kyber512_amd64_avx2_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_kem_kyber_kyber512_amd64_avx2_enc(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key
);

int jade_kem_kyber_kyber512_amd64_avx2_dec(
  uint8_t *shared_secret,
  const uint8_t *ciphertext,
  const uint8_t *secret_key
);

#endif
