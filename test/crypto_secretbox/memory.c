#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_secretbox.h"
#include "randombytes.h"
#include "config.h"

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
  uint8_t *ciphertext;
  uint8_t *plaintext;
  uint64_t plaintext_length;
  uint8_t *nonce;
  uint8_t *key;

  nonce = malloc(sizeof(uint8_t) * JADE_SECRETBOX_NONCEBYTES);
  key = malloc(sizeof(uint8_t) * JADE_SECRETBOX_KEYBYTES);

  __jasmin_syscall_randombytes__(nonce, JADE_SECRETBOX_NONCEBYTES);
  __jasmin_syscall_randombytes__(key, JADE_SECRETBOX_KEYBYTES);

  // open: OK
  for (plaintext_length = MININBYTES; plaintext_length <= MAXINBYTES; plaintext_length++)
  {
    ciphertext = malloc(sizeof(uint8_t) * (JADE_SECRETBOX_ZEROBYTES + plaintext_length));
    plaintext = malloc(sizeof(uint8_t) * (JADE_SECRETBOX_ZEROBYTES + plaintext_length));
    memset(plaintext, 0, sizeof(uint8_t) * plaintext_length);
    
    jade_secretbox(ciphertext, plaintext, plaintext_length, nonce, key);
    jade_secretbox_open(plaintext, ciphertext, plaintext_length, nonce, key);

    free(ciphertext);
    free(plaintext);
    ciphertext = NULL;
    plaintext = NULL;
  }

  // open: !OK
  for (plaintext_length = MININBYTES; plaintext_length <= MAXINBYTES; plaintext_length++)
  {
    ciphertext = malloc(sizeof(uint8_t) * (JADE_SECRETBOX_ZEROBYTES + plaintext_length));
    memset(ciphertext, 0, sizeof(uint8_t) * plaintext_length);
    plaintext = malloc(sizeof(uint8_t) * (JADE_SECRETBOX_ZEROBYTES + plaintext_length));
    
    jade_secretbox_open(plaintext, ciphertext, plaintext_length, nonce, key);

    free(ciphertext);
    free(plaintext);
    ciphertext = NULL;
    plaintext = NULL;
  }

  free(nonce);
  free(key);

  return 0;
}

