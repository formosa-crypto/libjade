#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_secretbox.h"

extern void __jasmin_syscall_randombytes__(uint8_t *x, uint64_t xlen);

/*

int jade_secretbox(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t plaintext_length,
  const uint8_t *nonce,
  const uint8_t *key
);

int jade_secretbox_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t ciphertext_length,
  const uint8_t *nonce,
  const uint8_t *key
);

*/

int main(void)
{
  #define PLAINTEXT_LENGTH 3
  uint8_t plaintext[PLAINTEXT_LENGTH] = {0x61, 0x62, 0x63};

  int r;
  uint8_t  ciphertext[JADE_SECRETBOX_ZEROBYTES + PLAINTEXT_LENGTH];
  uint8_t  plaintext_1[JADE_SECRETBOX_ZEROBYTES + PLAINTEXT_LENGTH];
  uint8_t  plaintext_2[JADE_SECRETBOX_ZEROBYTES + PLAINTEXT_LENGTH];
  uint64_t length = JADE_SECRETBOX_ZEROBYTES + PLAINTEXT_LENGTH;
  uint8_t  nonce[JADE_SECRETBOX_NONCEBYTES];
  uint8_t  key[JADE_SECRETBOX_KEYBYTES];

  //
  __jasmin_syscall_randombytes__(nonce, JADE_SECRETBOX_NONCEBYTES);
  __jasmin_syscall_randombytes__(key, JADE_SECRETBOX_KEYBYTES);

  memset(plaintext_1, 0, JADE_SECRETBOX_ZEROBYTES);
  memcpy(&(plaintext_1[JADE_SECRETBOX_ZEROBYTES]), plaintext, sizeof(plaintext));

  //
  r = jade_secretbox(ciphertext, plaintext_1, length, nonce, key);

  assert(r == 0);
  for(int i=0; i<JADE_SECRETBOX_BOXZEROBYTES; i++)
  { assert(ciphertext[i] == 0); }

  //
  r = jade_secretbox_open(plaintext_2, ciphertext, length, nonce, key);

  assert(r == 0);
  for(int i=0; i<JADE_SECRETBOX_ZEROBYTES; i++)
  { assert(plaintext_2[i] == 0); }
  for(int i=0; i<PLAINTEXT_LENGTH; i++)
  { assert(plaintext[i] == plaintext_2[JADE_SECRETBOX_ZEROBYTES + i]); }

  #ifndef NOPRINT
  print_info(JADE_SECRETBOX_ALGNAME, JADE_SECRETBOX_ARCH, JADE_SECRETBOX_IMPL);
  print_str_u8("plaintext", plaintext, PLAINTEXT_LENGTH);
  print_str_u8("prepared_plaintext", plaintext_1, length);
  print_str_u8("nonce", nonce, JADE_SECRETBOX_NONCEBYTES);
  print_str_u8("key", key, JADE_SECRETBOX_KEYBYTES);
  print_str_u8("ciphertext", ciphertext, length);
  print_str_u8("decrypted_plaintext", plaintext_2, length);
  #endif

  //flip one bit of ciphertext so the verification fails
  ciphertext[JADE_SECRETBOX_ZEROBYTES] ^= 1;
  r = jade_secretbox_open(plaintext_2, ciphertext, length, nonce, key);

  assert(r == -1);

  return 0;
}

