#ifndef CRYPTOLIB_KYBER768_AMD64_REF_H
#define CRYPTOLIB_KYBER768_AMD64_REF_H

#define CRYPTOLIB_KYBER768_SECRETKEYBYTES  2400
#define CRYPTOLIB_KYBER768_PUBLICKEYBYTES  1184
#define CRYPTOLIB_KYBER768_CIPHERTEXTBYTES 1088
#define CRYPTOLIB_KYBER768_BYTES           32

int cryptolib_kyber768_amd64_ref_kem_keypair(uint8_t *pk, uint8_t *sk);

int cryptolib_kyber768_amd64_ref_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int cryptolib_kyber768_amd64_ref_kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
