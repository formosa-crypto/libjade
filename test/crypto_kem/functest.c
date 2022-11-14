#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

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
  uint8_t public_key[JADE_KEM_PUBLICKEYBYTES];
  uint8_t secret_key[JADE_KEM_SECRETKEYBYTES];
  uint8_t shared_secret_1[JADE_KEM_BYTES];
  uint8_t ciphertext[JADE_KEM_CIPHERTEXTBYTES];
  uint8_t shared_secret_2[JADE_KEM_BYTES];

  //
  memset(public_key,      0, JADE_KEM_PUBLICKEYBYTES);
  memset(secret_key,      0, JADE_KEM_SECRETKEYBYTES);
  memset(shared_secret_1, 0, JADE_KEM_BYTES);
  memset(ciphertext,      0, JADE_KEM_CIPHERTEXTBYTES);
  memset(shared_secret_2, 0, JADE_KEM_BYTES);

  //
  jade_kem_keypair(public_key, secret_key);

  //
  jade_kem_enc(ciphertext, shared_secret_1, public_key);

  //
  jade_kem_dec(shared_secret_2, ciphertext, secret_key);

  //
  assert(memcmp(shared_secret_1, shared_secret_2, JADE_KEM_BYTES) == 0);
  #ifndef NOPRINT
  print_info(JADE_KEM_ALGNAME, JADE_KEM_ARCH, JADE_KEM_IMPL);
  print_str_u8("public_key", public_key, JADE_KEM_PUBLICKEYBYTES);
  print_str_u8("secret_key", secret_key, JADE_KEM_SECRETKEYBYTES);
  print_str_u8("shared_secret", shared_secret_1, JADE_KEM_BYTES);
  print_str_u8("ciphertext", ciphertext, JADE_KEM_CIPHERTEXTBYTES);
  #endif

  return 0;
}

