#ifndef JADE_STREAM_chacha_chacha20_armv7m_ref_API_H
#define JADE_STREAM_chacha_chacha20_armv7m_ref_API_H

#define JADE_STREAM_chacha_chacha20_armv7m_ref_KEYBYTES 32
#define JADE_STREAM_chacha_chacha20_armv7m_ref_NONCEBYTES 8

#define JADE_STREAM_chacha_chacha20_armv7m_ref_ALGNAME "ChaCha20"
#define JADE_STREAM_chacha_chacha20_armv7m_ref_ARCH    "ARMv7-M"
#define JADE_STREAM_chacha_chacha20_armv7m_ref_IMPL    "ref"

#include <stdint.h>

int jade_stream_chacha_chacha20_armv7m_ref_xor(
 uint8_t *output,       // output[output_length]
 const uint8_t *input,  // input[input_length]
 uint32_t input_length, //
 const uint8_t *nonce,  // nonce[NONCEBYTES]
 const uint8_t *key     // key[KEYBYTES]
);

int jade_stream_chacha_chacha20_armv7m_ref(
 uint8_t *stream,        // stream[stream_length]
 uint32_t stream_length,
 const uint8_t *nonce,   // nonce[NONCEBYTES]
 const uint8_t *key      // key[KEYBYTES]
);

#endif
