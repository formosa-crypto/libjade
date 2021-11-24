#ifndef CRYPTOLIB_KYBER512_H
#define CRYPTOLIB_KYBER512_H

#define CRYPTOLIB_KYBER512_SECRETKEYBYTES  1632
#define CRYPTOLIB_KYBER512_PUBLICKEYBYTES  800
#define CRYPTOLIB_KYBER512_CIPHERTEXTBYTES 768
#define CRYPTOLIB_KYBER512_BYTES           32

int CRYPTOLIB_KYBER512_kem_keypair(uint8_t *pk, uint8_t *sk);

int CRYPTOLIB_KYBER512_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int CRYPTOLIB_KYBER512_kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
