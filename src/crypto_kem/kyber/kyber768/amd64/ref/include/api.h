#ifndef JADE_KEM_KYBER_KYBER768_AMD64_REF_API_H
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_API_H

#include <stdint.h>

#define JADE_KEM_KYBER_KYBER768_AMD64_REF_SECRETKEYBYTES  2400
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_PUBLICKEYBYTES  1184
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_CIPHERTEXTBYTES 1088
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_BYTES           32

#define JADE_KEM_KYBER_KYBER768_AMD64_REF_ALGNAME         "Kyber768"
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_ARCH            "amd64"
#define JADE_KEM_KYBER_KYBER768_AMD64_REF_IMPL            "ref"

int jade_kem_kyber_kyber768_amd64_ref_keypair(uint8_t *pk, uint8_t *sk);

int jade_kem_kyber_kyber768_amd64_ref_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int jade_kem_kyber_kyber768_amd64_ref_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
