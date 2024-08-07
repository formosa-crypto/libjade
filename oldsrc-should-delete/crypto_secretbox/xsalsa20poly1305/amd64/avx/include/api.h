#ifndef JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_API_H
#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_API_H

#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_KEYBYTES 32
#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_NONCEBYTES 24
#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_ZEROBYTES 32
#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_BOXZEROBYTES 16

#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_ALGNAME "XSalsa20/20Poly1305"
#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_ARCH    "amd64"
#define JADE_SECRETBOX_xsalsa20poly1305_amd64_avx_IMPL    "avx"

#include <stdint.h>

int jade_secretbox_xsalsa20poly1305_amd64_avx(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t plaintext_length,
  const uint8_t *nonce,
  const uint8_t *key
);

int jade_secretbox_xsalsa20poly1305_amd64_avx_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t ciphertext_length,
  const uint8_t *nonce,
  const uint8_t *key
);

#endif
