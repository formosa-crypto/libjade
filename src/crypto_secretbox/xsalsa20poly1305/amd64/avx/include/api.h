#ifndef JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_API_H
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_API_H

#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_KEYBYTES 32
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_NONCEBYTES 24
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_ZEROBYTES 32
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_BOXZEROBYTES 16

#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_ALGNAME "XSalsa20/20Poly1305"
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_ARCH    "amd64"
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_AVX_IMPL    "avx"

#include <stdint.h>

int jade_secretbox_xsalsa20poly1305_amd64_avx(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t length,
  const uint8_t *nonce, /*NONCEBYTES*/
  const uint8_t *key /*KEYBYTES*/
);

int jade_secretbox_xsalsa20poly1305_amd64_avx_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t length,
  const uint8_t *nonce, /*NONCEBYTES*/
  const uint8_t *key /*KEYBYTES*/
);

#endif
