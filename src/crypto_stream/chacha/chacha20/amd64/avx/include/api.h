#ifndef JADE_STREAM_CHACHA_CHACHA20_AMD64_AVX_API_H
#define JADE_STREAM_CHACHA_CHACHA20_AMD64_AVX_API_H

#define JADE_STREAM_CHACHA_CHACHA20_AMD64_AVX_KEYBYTES 32
#define JADE_STREAM_CHACHA_CHACHA20_AMD64_AVX_NONCEBYTES 8
#define JADE_STREAM_CHACHA_CHACHA20_AMD64_AVX_ALGNAME "ChaCha20"

#include <stdint.h>

int jade_stream_chacha_chacha20_amd64_avx(
 uint8_t *ciphertext,
 uint8_t *plaintext,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

#endif
