#ifndef JADE_KEM_KYBER_KYBER512_AMD64_REF_H
#define JADE_KEM_KYBER_KYBER512_AMD64_REF_H

#define JADE_KEM_KYBER_KYBER512_SECRETKEYBYTES  2400
#define JADE_KEM_KYBER_KYBER512_PUBLICKEYBYTES  1184
#define JADE_KEM_KYBER_KYBER512_CIPHERTEXTBYTES 1088
#define JADE_KEM_KYBER_KYBER512_BYTES           32

int jade_kem_kyber_kyber512_amd64_ref_keypair(uint8_t *pk, uint8_t *sk);

int jade_kem_kyber_kyber512_amd64_ref_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int jade_kem_kyber_kyber512_amd64_ref_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
