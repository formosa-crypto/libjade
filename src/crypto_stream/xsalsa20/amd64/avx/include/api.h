#ifndef JADE_STREAM_xsalsa20_amd64_avx_API_H
#define JADE_STREAM_xsalsa20_amd64_avx_API_H

#define JADE_STREAM_xsalsa20_amd64_avx_KEYBYTES 32
#define JADE_STREAM_xsalsa20_amd64_avx_NONCEBYTES 24

#define JADE_STREAM_xsalsa20_amd64_avx_ALGNAME "XSalsa20/20"
#define JADE_STREAM_xsalsa20_amd64_avx_ARCH    "amd64"
#define JADE_STREAM_xsalsa20_amd64_avx_IMPL    "avx"

#include <stdint.h>

int jade_stream_xsalsa20_amd64_avx_xor(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *nonce,
 const uint8_t *key
);

int jade_stream_xsalsa20_amd64_avx(
 uint8_t *stream,
 uint64_t stream_length,
 const uint8_t *nonce,
 const uint8_t *key
);

#endif
