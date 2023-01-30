#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_sign.h"

/*
int jade_sign_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);
*/

int main(void)
{
  char *f[] = {xstr(jade_sign_keypair,), xstr(jade_sign,), xstr(jade_sign_open,)};

  printf("-safetyparam \"%s>public_key,secret_key;%zu,%zu",
    f[0],(size_t)JADE_SIGN_PUBLICKEYBYTES,(size_t)JADE_SIGN_SECRETKEYBYTES);

  printf("|%s>signed_message,signed_message_length,message,secret_key;%zu+message_length,%zu,message_length,%zu",
    f[1],(size_t)JADE_SIGN_BYTES,(size_t)(sizeof(uint64_t)),(size_t)JADE_SIGN_SECRETKEYBYTES);

  printf("|%s>message,message_length,signed_message,public_key;signed_message_length-%zu,%zu,signed_message_length,%zu\"",
    f[2],(size_t)JADE_SIGN_BYTES,(size_t)(sizeof(uint64_t)),(size_t)JADE_SIGN_PUBLICKEYBYTES);

  fflush(stdout);
  return 0;
}

