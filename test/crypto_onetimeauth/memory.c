#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "api.h"
#include "namespace.h"
#include "jade_onetimeauth.h"
#include "randombytes.h"
#include "config.h"

int main(void)
{
  int r;
  uint8_t *mac;
  uint8_t *input;
  size_t input_length;
  uint8_t *key;

  mac = malloc(sizeof(uint8_t) * JADE_ONETIMEAUTH_BYTES);
  key = malloc(sizeof(uint8_t) * JADE_ONETIMEAUTH_KEYBYTES);
  __jasmin_syscall_randombytes__(key, JADE_ONETIMEAUTH_KEYBYTES);

  // verify: OK
  for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
  {
    input = malloc(sizeof(uint8_t) * input_length);
    memset(input, 0, sizeof(uint8_t) * input_length);

    r = jade_onetimeauth(mac, input, input_length, key);
    assert(r == 0);

    r = jade_onetimeauth_verify(mac, input, input_length, key);
    assert(r == 0);

    free(input);
    input = NULL;
  }

  memset(mac, 0, sizeof(uint8_t) * JADE_ONETIMEAUTH_BYTES);

  // verify: !OK
  for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
  {
    input = malloc(sizeof(uint8_t) * input_length);
    memset(input, 0, sizeof(uint8_t) * input_length);

    r = jade_onetimeauth_verify(mac, input, input_length, key);
    assert(r == -1);

    free(input);
    input = NULL;
  }

  free(mac);
  free(key);

  return 0;
}

