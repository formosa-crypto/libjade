#ifndef JADE_KEM_frodo_frodo976shake_amd64_ref_API_H
#define JADE_KEM_frodo_frodo976shake_amd64_ref_API_H

#include <stdint.h>

#define JADE_KEM_frodo_frodo976shake_amd64_ref_SECRETKEYBYTES   31296
#define JADE_KEM_frodo_frodo976shake_amd64_ref_PUBLICKEYBYTES   15632
#define JADE_KEM_frodo_frodo976shake_amd64_ref_CIPHERTEXTBYTES  15792
#define JADE_KEM_frodo_frodo976shake_amd64_ref_KEYPAIRCOINBYTES 88
#define JADE_KEM_frodo_frodo976shake_amd64_ref_ENCCOINBYTES     72
#define JADE_KEM_frodo_frodo976shake_amd64_ref_BYTES            24

#define JADE_KEM_frodo_frodo976shake_amd64_ref_ALGNAME         "Frodo976shake"
#define JADE_KEM_frodo_frodo976shake_amd64_ref_ARCH            "amd64"
#define JADE_KEM_frodo_frodo976shake_amd64_ref_IMPL            "ref"

// kem api
int jade_kem_frodo_frodo976shake_amd64_ref_keypair_derand(uint8_t *public_key,
                                                           uint8_t *secret_key,
                                                           uint8_t *coins);

int jade_kem_frodo_frodo976shake_amd64_ref_keypair(uint8_t *public_key,
                                                    uint8_t *secret_key);

int jade_kem_frodo_frodo976shake_amd64_ref_enc_derand(uint8_t *ciphertext,
                                                       uint8_t *shared_secret,
                                                       uint8_t *public_key,
                                                       uint8_t *coins);

int jade_kem_frodo_frodo976shake_amd64_ref_enc(uint8_t *ciphertext,
                                                uint8_t *shared_secret,
                                                uint8_t *public_key);

int jade_kem_frodo_frodo976shake_amd64_ref_dec(uint8_t *shared_secret,
                                                uint8_t *ciphertext,
                                                uint8_t *secret_key);

#endif
