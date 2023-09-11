#include <assert.h>
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
  int r;
  uint8_t public_key[JADE_KEM_PUBLICKEYBYTES];
  uint8_t secret_key[JADE_KEM_SECRETKEYBYTES];

  uint8_t shared_secret[JADE_KEM_BYTES];
  uint8_t ciphertext[JADE_KEM_CIPHERTEXTBYTES];

  uint8_t keypair_coins[JADE_KEM_KEYPAIRCOINBYTES];
  uint8_t enc_coins[JADE_KEM_ENCCOINBYTES];

  __jasmin_syscall_randombytes__(keypair_coins, JADE_KEM_KEYPAIRCOINBYTES);
  r = jade_kem_keypair_derand(public_key, secret_key, keypair_coins);
    assert(r == 0);

  __jasmin_syscall_randombytes__(enc_coins, JADE_KEM_ENCCOINBYTES);
  r = jade_kem_enc_derand(ciphertext, shared_secret, public_key, enc_coins);
    assert(r == 0);

  r = jade_kem_dec(shared_secret, ciphertext, secret_key);
    assert(r == 0);

  // TODO: some hash, to be replaced by the actual checksum
  printf("5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03");

  return 0;
}

