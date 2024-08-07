#ifndef JADE_STREAM_salsa20_salsa20_amd64_ref_API_H
#define JADE_STREAM_salsa20_salsa20_amd64_ref_API_H

#define JADE_STREAM_salsa20_salsa20_amd64_ref_KEYBYTES 32
#define JADE_STREAM_salsa20_salsa20_amd64_ref_NONCEBYTES 8

#define JADE_STREAM_salsa20_salsa20_amd64_ref_ALGNAME "Salsa20/20"
#define JADE_STREAM_salsa20_salsa20_amd64_ref_ARCH    "amd64"
#define JADE_STREAM_salsa20_salsa20_amd64_ref_IMPL    "ref"

#include <stdint.h>

int jade_stream_salsa20_salsa20_amd64_ref_xor(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *nonce,
 const uint8_t *key
);

int jade_stream_salsa20_salsa20_amd64_ref(
 uint8_t *stream,
 uint64_t stream_length,
 const uint8_t *nonce,
 const uint8_t *key
);

#endif
