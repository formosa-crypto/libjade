#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_kem.h"
#include "randombytes.h"
#include "config.h"

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

//

int jade_kem_keypair_derand(
  uint8_t *public_key,
  uint8_t *secret_key,
  const uint8_t *coins
);

int jade_kem_enc_derand(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key,
  const uint8_t *coins
);
*/

int main(void)
{
  uint8_t *public_key;
  uint8_t *secret_key;
  uint8_t *ciphertext;
  uint8_t *shared_secret;
  uint8_t *coins_keypair;
  uint8_t *coins_enc;

  public_key    = malloc(sizeof(uint8_t) * JADE_KEM_PUBLICKEYBYTES);
  secret_key    = malloc(sizeof(uint8_t) * JADE_KEM_SECRETKEYBYTES);
  ciphertext    = malloc(sizeof(uint8_t) * JADE_KEM_CIPHERTEXTBYTES);
  shared_secret = malloc(sizeof(uint8_t) * JADE_KEM_BYTES);
  coins_keypair = malloc(sizeof(uint8_t) * JADE_KEM_KEYPAIRCOINBYTES);
  coins_enc     = malloc(sizeof(uint8_t) * JADE_KEM_ENCCOINBYTES);

  jade_kem_keypair(public_key, secret_key);
  jade_kem_enc(ciphertext, shared_secret, public_key);
  jade_kem_dec(shared_secret, ciphertext, secret_key);

  __jasmin_syscall_randombytes__(coins_keypair, JADE_KEM_KEYPAIRCOINBYTES);
  jade_kem_keypair_derand(public_key, secret_key, coins_keypair);

  __jasmin_syscall_randombytes__(coins_enc, JADE_KEM_ENCCOINBYTES);
  jade_kem_enc_derand(ciphertext, shared_secret, public_key, coins_enc);

  free(public_key);
  free(secret_key);
  free(ciphertext);
  free(shared_secret);
  free(coins_keypair);
  free(coins_enc);

  return 0;
}

