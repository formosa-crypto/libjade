#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_kem.h"

/*
int jade_kem_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_kem_enc(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key
);

int jade_kem_dec(
  uint8_t *shared_secret,
  const uint8_t *ciphertext,
  const uint8_t *secret_key
);
*/

int main(void)
{
  char *f[] = {xstr(jade_kem_keypair,), xstr(jade_kem_enc,), xstr(jade_kem_dec,)};

  printf("-safetyparam \"%s>public_key,secret_key;%zu,%zu",
    f[0],(size_t)JADE_KEM_PUBLICKEYBYTES,(size_t)JADE_KEM_SECRETKEYBYTES);

  printf("|%s>ciphertext,shared_secret,public_key;%zu,%zu,%zu\"",
    f[1],(size_t)JADE_KEM_CIPHERTEXTBYTES,(size_t)JADE_KEM_BYTES,(size_t)JADE_KEM_PUBLICKEYBYTES);

  printf("|%s>shared_secret,ciphertext,secret_key;%zu,%zu,%zu\"",
    f[2],(size_t)JADE_KEM_BYTES,(size_t)JADE_KEM_CIPHERTEXTBYTES,(size_t)JADE_KEM_SECRETKEYBYTES);

  fflush(stdout);
  return 0;
}

