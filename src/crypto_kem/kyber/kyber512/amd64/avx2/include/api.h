#ifndef JADE_KEM_KYBER_KYBER512_AMD64_AVX2_API_H
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_API_H

#include <stdint.h>

#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_SECRETKEYBYTES  1632
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_PUBLICKEYBYTES  800
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_CIPHERTEXTBYTES 768
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_BYTES           32
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_ALGNAME         "Kyber512"

int jade_kem_kyber_kyber512_amd64_avx2_keypair(uint8_t *pk, uint8_t *sk, const uint8_t *randomness);

int jade_kem_kyber_kyber512_amd64_avx2_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk, const uint8_t *coins);

int jade_kem_kyber_kyber512_amd64_avx2_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
