#ifndef JADE_STREAM_chacha_chacha12_amd64_avx2_API_H
#define JADE_STREAM_chacha_chacha12_amd64_avx2_API_H

#define JADE_STREAM_chacha_chacha12_amd64_avx2_KEYBYTES 32
#define JADE_STREAM_chacha_chacha12_amd64_avx2_NONCEBYTES 8

#define JADE_STREAM_chacha_chacha12_amd64_avx2_ALGNAME "ChaCha12"
#define JADE_STREAM_chacha_chacha12_amd64_avx2_ARCH    "amd64"
#define JADE_STREAM_chacha_chacha12_amd64_avx2_IMPL    "avx2"

#include <stdint.h>

int jade_stream_chacha_chacha12_amd64_avx2_xor(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *nonce,
 const uint8_t *key
);

int jade_stream_chacha_chacha12_amd64_avx2(
 uint8_t *stream,
 uint64_t stream_length,
 const uint8_t *nonce,
 const uint8_t *key
);

#endif
