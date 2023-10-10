#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "api.h"
#include "namespace.h"
#include "jade_secretbox.h"
#include "randombytes.h"
#include "config.h"

int main(void)
{
  int r;
  uint8_t *ciphertext;
  uint8_t *plaintext;
  size_t plaintext_length;
  size_t ciphertext_length;
  uint8_t *nonce;
  uint8_t *key;

  nonce = malloc(sizeof(uint8_t) * JADE_SECRETBOX_NONCEBYTES);
  key = malloc(sizeof(uint8_t) * JADE_SECRETBOX_KEYBYTES);

  __jasmin_syscall_randombytes__(nonce, JADE_SECRETBOX_NONCEBYTES);
  __jasmin_syscall_randombytes__(key, JADE_SECRETBOX_KEYBYTES);

  // open: OK
  for (plaintext_length = JADE_SECRETBOX_ZEROBYTES + MININBYTES; plaintext_length <= JADE_SECRETBOX_ZEROBYTES + MAXINBYTES; plaintext_length++)
  {
    ciphertext = malloc(sizeof(uint8_t) * plaintext_length);
    plaintext = malloc(sizeof(uint8_t) * plaintext_length);
    memset(plaintext, 0, sizeof(uint8_t) * plaintext_length);
    
    r = jade_secretbox(ciphertext, plaintext, plaintext_length, nonce, key);
    assert(r == 0);

    r = jade_secretbox_open(plaintext, ciphertext, plaintext_length, nonce, key);
    assert(r == 0);

    free(ciphertext);
    free(plaintext);
    ciphertext = NULL;
    plaintext = NULL;
  }

  // open: !OK
  for (ciphertext_length = JADE_SECRETBOX_ZEROBYTES + MININBYTES; ciphertext_length <= JADE_SECRETBOX_ZEROBYTES + MAXINBYTES; ciphertext_length++)
  {
    ciphertext = malloc(sizeof(uint8_t) * ciphertext_length);
    plaintext = malloc(sizeof(uint8_t) * ciphertext_length);
    memset(ciphertext, 0, sizeof(uint8_t) * ciphertext_length);
    
    r = jade_secretbox_open(plaintext, ciphertext, ciphertext_length, nonce, key);
    assert(r == -1);

    free(ciphertext);
    free(plaintext);
    ciphertext = NULL;
    plaintext = NULL;
  }

  free(nonce);
  free(key);

  return 0;
}

