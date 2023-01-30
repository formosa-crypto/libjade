#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_secretbox.h"

/*
int jade_secretbox(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t length,
  const uint8_t *nonce,
  const uint8_t *key
);

int jade_secretbox_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t length,
  const uint8_t *nonce,
  const uint8_t *key
);
*/

int main(void)
{
  char *f[] = {xstr(jade_secretbox,), xstr(jade_secretbox_open,)};

  printf("-safetyparam \"%s>ciphertext,plaintext,nonce,key;length,length,%zu,%zu",
    f[0],(size_t)JADE_SECRETBOX_NONCEBYTES,(size_t)JADE_SECRETBOX_KEYBYTES);

  printf("|%s>plaintext,ciphertext,nonce,key;length,length,%zu,%zu\"",
    f[1],(size_t)JADE_SECRETBOX_NONCEBYTES,(size_t)JADE_SECRETBOX_KEYBYTES);

  fflush(stdout);
  return 0;
}
