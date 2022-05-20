#ifndef JADE_STREAM_CHACHA_CHACHA20_AMD64_MMX_API_H
#define JADE_STREAM_CHACHA_CHACHA20_AMD64_MMX_API_H

#define JADE_STREAM_CHACHA_CHACHA20_AMD64_MMX_KEYBYTES 32
#define JADE_STREAM_CHACHA_CHACHA20_AMD64_MMX_NONCEBYTES 8
#define JADE_STREAM_CHACHA_CHACHA20_AMD64_MMX_ALGNAME "ChaCha20"

#include <stdint.h>

int jade_stream_chacha_chacha20_amd64_mmx_xor(
 uint8_t *ciphertext,
 uint8_t *plaintext,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

int jade_stream_chacha_chacha20_amd64_mmx(
 uint8_t *stream,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

#endif
