#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_scalarmult.h"
#include "randombytes.h"
#include "config.h"

int main(void)
{
  uint8_t *public_key = malloc(sizeof(uint8_t) * JADE_SCALARMULT_BYTES);
  uint8_t *secret_key = malloc(sizeof(uint8_t) * JADE_SCALARMULT_SCALARBYTES);
  uint8_t *secret = malloc(sizeof(uint8_t) * JADE_SCALARMULT_BYTES);

  __jasmin_syscall_randombytes__(secret_key, JADE_SCALARMULT_SCALARBYTES);
  jade_scalarmult_base(public_key, secret_key);
  jade_scalarmult(secret, secret_key, public_key);

  free(public_key);
  free(secret_key);
  free(secret);

  return 0;
}

