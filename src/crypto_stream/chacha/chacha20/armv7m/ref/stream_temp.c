#include <stdint.h>
#include <stdio.h>

extern int jade_stream_chacha_chacha20_armv7m_ref_xor_temporary(
 uint8_t *output,          // output[input_length]
 const uint8_t *input,     // input[input_length]
 uint32_t input_length,    //
 uint8_t **nonce_key // nonce_key[0] == nonce[NONCEBYTES]; nonce_key[1] = key[KEYBYTES]
);

int jade_stream_chacha_chacha20_armv7m_ref_xor(
 uint8_t *output,       // output[output_length]
 uint8_t *input,        // input[input_length]
 uint32_t input_length, //
 uint8_t *nonce,        // nonce[NONCEBYTES]
 uint8_t *key           // key[KEYBYTES]
)
{
  int r;
  uint8_t *nonce_key[2];

  nonce_key[0] = nonce;
  nonce_key[1] = key;

  r = jade_stream_chacha_chacha20_armv7m_ref_xor_temporary(output, input, input_length, nonce_key);

  return r;
}

