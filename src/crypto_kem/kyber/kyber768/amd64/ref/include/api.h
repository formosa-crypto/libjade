#ifndef JADE_KEM_KYBER_KYBER768_AMD64_REF_H
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_H

#define JADE_KEM_KYBER_KYBER768_AMD64_REF_SECRETKEYBYTES  2400
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_PUBLICKEYBYTES  1184
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_CIPHERTEXTBYTES 1088
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_BYTES           32

int cryptolib_kyber768_amd64_ref_kem_keypair(uint8_t *pk, uint8_t *sk);

int cryptolib_kyber768_amd64_ref_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int cryptolib_kyber768_amd64_ref_kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
