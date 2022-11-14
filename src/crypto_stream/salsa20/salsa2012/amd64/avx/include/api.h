#ifndef JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_API_H
#define JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_API_H

#define JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_KEYBYTES 32
#define JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_NONCEBYTES 8

#define JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_ALGNAME "Salsa20/12"
#define JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_ARCH    "amd64"
#define JADE_STREAM_SALSA20_SALSA2012_AMD64_AVX_IMPL    "avx"

#include <stdint.h>

int jade_stream_salsa20_salsa2012_amd64_avx_xor(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *nonce,
 const uint8_t *key
);

int jade_stream_salsa20_salsa2012_amd64_avx(
 uint8_t *stream,
 uint64_t stream_length,
 const uint8_t *nonce,
 const uint8_t *key
);


#endif
