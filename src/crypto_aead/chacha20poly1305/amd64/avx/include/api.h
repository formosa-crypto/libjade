#ifndef JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_API_H
#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_API_H

#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_KEYBYTES 32
#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_NONCEBYTES 24
#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_ZEROBYTES 32
#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_BOXZEROBYTES 16

#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_ALGNAME "Chacha20/Poly1305"
#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_ARCH    "amd64"
#define JADE_AEAD_CHACHA20POLY1305_AMD64_AVX_IMPL    "avx"

#include <stdint.h>

int jade_aead_chacha20poly1305_amd64_avx(
  uint8_t *ciphertext,
  const uint8_t *adata_plaintext,
  uint64_t adata_length,
  uint64_t plaintext_length,
  const uint8_t *nonce,
  const uint8_t *key
);


int jade_aead_chacha20poly1305_amd64_avx_open(
  uint8_t *plaintext,
  const uint8_t *ad_ciphertext,
  uint64_t ad_length,
  uint64_t ciphertext_length,
  const uint8_t *nonce,
  const uint8_t *key
);


#endif
