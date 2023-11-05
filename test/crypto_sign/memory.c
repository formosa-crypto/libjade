#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "api.h"
#include "namespace.h"
#include "jade_sign.h"
#include "randombytes.h"
#include "config.h"

int main(void)
{
  int r;
  uint8_t *public_key;
  uint8_t *secret_key;
  uint8_t *signed_message;
  size_t signed_message_length;
  uint8_t *message;
  size_t message_length;

  public_key = malloc(sizeof(uint8_t) * JADE_SIGN_PUBLICKEYBYTES);
  secret_key = malloc(sizeof(uint8_t) * JADE_SIGN_SECRETKEYBYTES);

  jade_sign_keypair(public_key, secret_key);

  for (message_length = MININBYTES; message_length <= MAXINBYTES; message_length++)
  {
    message = malloc(sizeof(uint8_t) * message_length);
    memset(message, 0, message_length);
    signed_message = malloc(sizeof(uint8_t) * (message_length + JADE_SIGN_BYTES));

    r = jade_sign(signed_message, &signed_message_length, message, message_length, secret_key);
    assert(r == 0);

    r = jade_sign_open(message, &message_length, signed_message, signed_message_length, public_key);
    assert(r == 0);

    free(message);
    free(signed_message);
    message = NULL;
    signed_message = NULL;
  }

  free(public_key);
  free(secret_key);

  return 0;
}

