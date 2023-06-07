#ifndef JADE_KEM_kyber_kyber768_amd64_ref_API_H
#define JADE_KEM_kyber_kyber768_amd64_ref_API_H

#include <stdint.h>

#define JADE_KEM_kyber_kyber768_amd64_ref_SECRETKEYBYTES   2400
#define JADE_KEM_kyber_kyber768_amd64_ref_PUBLICKEYBYTES   1184
#define JADE_KEM_kyber_kyber768_amd64_ref_CIPHERTEXTBYTES  1088
#define JADE_KEM_kyber_kyber768_amd64_ref_KEYPAIRCOINBYTES 64
#define JADE_KEM_kyber_kyber768_amd64_ref_ENCCOINBYTES     32
#define JADE_KEM_kyber_kyber768_amd64_ref_BYTES            32

#define JADE_KEM_kyber_kyber768_amd64_ref_ALGNAME         "Kyber768"
#define JADE_KEM_kyber_kyber768_amd64_ref_ARCH            "amd64"
#define JADE_KEM_kyber_kyber768_amd64_ref_IMPL            "ref"

int jade_kem_kyber_kyber768_amd64_ref_keypair_derand(
  uint8_t *public_key,
  uint8_t *secret_key,
  const uint8_t *coins
);

int jade_kem_kyber_kyber768_amd64_ref_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_kem_kyber_kyber768_amd64_ref_enc_derand(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key,
  const uint8_t *coins
);

int jade_kem_kyber_kyber768_amd64_ref_enc(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key
);

int jade_kem_kyber_kyber768_amd64_ref_dec(
  uint8_t *shared_secret,
  const uint8_t *ciphertext,
  const uint8_t *secret_key
);

#endif
