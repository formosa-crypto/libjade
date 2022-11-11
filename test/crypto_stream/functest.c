#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_stream.h"

/*
int jade_stream_xor(
 uint8_t *ciphertext,
 uint8_t *plaintext,
 uint64_t length,
 uint8_t *nonce,
 uint8_t *key
);

int jade_stream(
 uint8_t *stream,
 uint64_t length,
 uint8_t *nonce,
 uint8_t *key
);
*/

#define MAXBYTES 32

int main(void)
{
  uint8_t ciphertext_1[MAXBYTES];
  uint8_t ciphertext_2[MAXBYTES];
  uint8_t stream[MAXBYTES]
  uint8_t plaintext_1[MAXBYTES];
  uint8_t plaintext_2[MAXBYTES];
  uint64_t length = 0;
  uint8_t nonce[JADE_STREAM_NONCEBYTES];
  uint8_t key[JADE_STREAM_KEYBYTES];

  memset(ciphertext_1, 0, MAXBYTES);
  memset(ciphertext_2, 0, MAXBYTES);
  memset(stream, 0, MAXBYTES);
  memset(plaintext_1, 0, MAXBYTES);
  memset(plaintext_2, 0, MAXBYTES);
  memset(nonce, 0, JADE_STREAM_NONCEBYTES);
  memset(key, 0, JADE_STREAM_KEYBYTES);

  #ifndef NOPRINT
  print_info(JADE_STREAM_ALGNAME, JADE_STREAM_ARCH, JADE_STREAM_IMPL);
  #endif

  //
  for(length=0; length<=MAXBYTES; length++)
  {
    jade_stream(stream, length, nonce, key);
    jade_stream_xor(ciphertext_1, plaintext_1, length, nonce, key);
    jade_stream_xor(ciphertext_1, plaintext_1, length, nonce, key);

    #ifndef NOPRINT
    print_str_c_u8("input", length, input, length);
    print_str_c_u8("hash", length, hash, JADE_HASH_BYTES);
    #endif
  }

  return 0;
}

