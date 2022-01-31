#ifndef JADE_STREAM_CHACHA_CHACHA12_AMD64_REF_API_H
#define JADE_STREAM_CHACHA_CHACHA12_AMD64_REF_API_H

#define JADE_STREAM_CHACHA_CHACHA12_AMD64_REF_KEYBYTES 32
#define JADE_STREAM_CHACHA_CHACHA12_AMD64_REF_NONCEBYTES 8
#define JADE_STREAM_CHACHA_CHACHA12_AMD64_REF_ALGNAME "ChaCha12"

#include <stdint.h>

int jade_stream_chacha_chacha12_amd64_ref(
 uint8_t *ciphertext,
 uint8_t *plaintext,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

#endif
