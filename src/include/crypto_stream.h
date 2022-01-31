#ifndef CRYPTO_STREAM_API_H
#define CRYPTO_STREAM_API_H

#define CRYPTO_STREAM_KEYBYTES KEYBYTES
#define CRYPTO_STREAM_NONCEBYTES NONCEBYTES
#define CRYPTO_STREAM_ALGNAME ALGNAME

#include <stdint.h>

int crypto_stream(
 uint8_t *ciphertext,
 uint8_t *plaintext,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

#endif
