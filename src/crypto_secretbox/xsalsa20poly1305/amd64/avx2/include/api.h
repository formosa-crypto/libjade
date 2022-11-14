#ifndef JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_API_H
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_API_H

#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_KEYBYTES 32
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_NONCEBYTES 24
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_ZEROBYTES 32
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_BOXZEROBYTES 16

#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_ALGNAME "XSalsa20/20Poly1305"
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_ARCH    "amd64"
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX2_IMPL    "avx2"

#include <stdint.h>

int jade_secretbox_xsalsa20poly1305_amd64_avx2(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t plaintext_length,
  const uint8_t *nonce,
  const uint8_t *key
);

int jade_secretbox_xsalsa20poly1305_amd64_avx2_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t ciphertext_length,
  const uint8_t *nonce,
  const uint8_t *key
);

#endif
