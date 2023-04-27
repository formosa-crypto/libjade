#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_onetimeauth.h"
#include "randombytes.h"
#include "config.h"

/*
int jade_onetimeauth(
 uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

int jade_onetimeauth_verify(
 const uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);
*/

int main(void)
{
  uint8_t *mac;
  uint8_t *input;
  uint64_t input_length;
  uint8_t *key;

  mac = malloc(sizeof(uint8_t) * JADE_ONETIMEAUTH_BYTES);
  
  key = malloc(sizeof(uint8_t) * JADE_ONETIMEAUTH_KEYBYTES);
  __jasmin_syscall_randombytes__(key, JADE_ONETIMEAUTH_KEYBYTES);

  // verify: OK
  for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
  {
    input = malloc(sizeof(uint8_t) * input_length);
    memset(input, 0, sizeof(uint8_t) * input_length);

    jade_onetimeauth(mac, input, input_length, key);
    jade_onetimeauth_verify(mac, input, input_length, key);

    free(input);
    input = NULL;
  }

  // verify: !OK
  for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
  {
    input = malloc(sizeof(uint8_t) * input_length);
    memset(input, 0, sizeof(uint8_t) * input_length);

    __jasmin_syscall_randombytes__(mac, JADE_ONETIMEAUTH_BYTES);
    jade_onetimeauth_verify(mac, input, input_length, key);

    free(input);
    input = NULL;
  }

  free(mac);
  free(key);

  return 0;
}

