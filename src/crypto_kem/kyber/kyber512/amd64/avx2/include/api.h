#ifndef JADE_KEM_KYBER_KYBER512_AMD64_AVX2_H
#define JADE_KEM_KYBER_KYBER512_AMD64_AVX2_H

#define JADE_KEM_KYBER_KYBER512_SECRETKEYBYTES  1632
#define JADE_KEM_KYBER_KYBER512_PUBLICKEYBYTES  800
#define JADE_KEM_KYBER_KYBER512_CIPHERTEXTBYTES 768
#define JADE_KEM_KYBER_KYBER512_BYTES           32

int jade_kem_kyber_kyber512_amd64_avx2_keypair(uint8_t *pk, uint8_t *sk);

int jade_kem_kyber_kyber512_amd64_avx2_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int jade_kem_kyber_kyber512_amd64_avx2_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
