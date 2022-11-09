#ifndef JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_API_H
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_API_H

#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_KEYBYTES 32
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_NONCEBYTES 24
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_ZEROBYTES 32
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_BOXZEROBYTES 16

#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_ALGNAME "XSalsa20/20Poly1305"
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_ARCH    "amd64"
#define JADE_SECRETBOX_XSALSA20POLY1305_AMD64_REF_IMPL    "ref"

#include <stdint.h>

int jade_secretbox_xsalsa20poly1305_amd64_ref(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t length,
  const uint8_t *nonce, /*NONCEBYTES*/
  const uint8_t *key /*KEYBYTES*/
);

int jade_secretbox_xsalsa20poly1305_amd64_ref_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t length,
  const uint8_t *nonce, /*NONCEBYTES*/
  const uint8_t *key /*KEYBYTES*/
);

#endif
