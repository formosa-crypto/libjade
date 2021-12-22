#ifndef JADE_KEM_KYBER_KYBER768_AMD64_AVX2_API_H
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_API_H

#include <stdint.h>

#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_SECRETKEYBYTES  2400
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_PUBLICKEYBYTES  1184
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_CIPHERTEXTBYTES 1088
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_BYTES           32
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_ALGNAME         "Kyber768"

int jade_kem_kyber_kyber768_amd64_avx2_keypair(uint8_t *pk, uint8_t *sk, const uint8_t *randomness);

int jade_kem_kyber_kyber768_amd64_avx2_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk, const uint8_t *coins);

int jade_kem_kyber_kyber768_amd64_avx2_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
