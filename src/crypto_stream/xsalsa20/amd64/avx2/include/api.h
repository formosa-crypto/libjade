#ifndef JADE_STREAM_XSALSA20_AMD64_AVX2_API_H
#define JADE_STREAM_XSALSA20_AMD64_AVX2_API_H

#define JADE_STREAM_XSALSA20_AMD64_AVX2_KEYBYTES 32
#define JADE_STREAM_XSALSA20_AMD64_AVX2_NONCEBYTES 24

#define JADE_STREAM_XSALSA20_AMD64_AVX2_ALGNAME "XSalsa20/20"
#define JADE_STREAM_XSALSA20_AMD64_AVX2_ARCH    "amd64"
#define JADE_STREAM_XSALSA20_AMD64_AVX2_IMPL    "avx2"

#include <stdint.h>

int jade_stream_xsalsa20_amd64_avx2_xor(
 uint8_t *ciphertext,
 uint8_t *plaintext,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

int jade_stream_xsalsa20_amd64_avx2(
 uint8_t *stream,
 uint64_t length,
 uint8_t *nonce, /*NONCEBYTES*/
 uint8_t *key /*KEYBYTES*/
);

#endif
