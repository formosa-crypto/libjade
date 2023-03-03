#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_stream.h"
#include "randombytes.h"

/*
int jade_stream_xor(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *nonce,
 const uint8_t *key
);

int jade_stream(
 uint8_t *stream,
 uint64_t stream_length,
 const uint8_t *nonce,
 const uint8_t *key
);
*/

int main(void)
{
  int r;

  #define PLAINTEXT_LENGTH 3
  uint8_t plaintext_1[PLAINTEXT_LENGTH] = {0x61, 0x62, 0x63};
  uint8_t plaintext_2[PLAINTEXT_LENGTH];
  uint8_t ciphertext[PLAINTEXT_LENGTH];
  uint8_t stream[PLAINTEXT_LENGTH];
  uint64_t length = PLAINTEXT_LENGTH;
  uint8_t _nonce[JADE_STREAM_NONCEBYTES];
  uint8_t _key[JADE_STREAM_KEYBYTES];
  uint8_t* nonce = _nonce;
  uint8_t* key = _key;

  //
  nonce = __jasmin_syscall_randombytes__(nonce, JADE_STREAM_NONCEBYTES);
  key = __jasmin_syscall_randombytes__(key, JADE_STREAM_KEYBYTES);

  //
  r = jade_stream(stream, length, nonce, key);
    assert(r == 0);

  //
  r = jade_stream_xor(ciphertext, plaintext_1, length, nonce, key);
    assert(r == 0);

  //
  r = jade_stream_xor(plaintext_2, ciphertext, length, nonce, key);
    assert(r == 0);
    for(int i=0; i<PLAINTEXT_LENGTH; i++)
    { assert(plaintext_1[i] == plaintext_2[i]);
      assert(ciphertext[i] == (plaintext_1[i] ^ stream[i]));
    }

  #ifndef NOPRINT
  print_info(JADE_STREAM_ALGNAME, JADE_STREAM_ARCH, JADE_STREAM_IMPL);
  print_str_u8("plaintext", plaintext_1, length);
  print_str_u8("nonce", nonce, JADE_STREAM_NONCEBYTES);
  print_str_u8("key", key, JADE_STREAM_KEYBYTES);
  print_str_u8("stream", stream, length);
  print_str_u8("ciphertext", ciphertext, length);
  #endif

  return 0;
}

