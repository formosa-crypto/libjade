#include <stdint.h>
#include <string.h>
#include <assert.h>

#include <stdio.h>

#include "print.h"

#include "api.h"
#include "jade_sign.h"

/*

int jade_sign_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign_ref(
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
  int r;
  uint8_t public_key[JADE_SIGN_PUBLICKEYBYTES];
  uint8_t secret_key[JADE_SIGN_SECRETKEYBYTES];

  #define MESSAGE_LENGTH 3
  uint8_t message_1[MESSAGE_LENGTH] = {0x61, 0x62, 0x63};
  uint8_t message_2[MESSAGE_LENGTH];
  uint64_t message_length;

  uint8_t signed_message[JADE_SIGN_BYTES + MESSAGE_LENGTH];
  uint64_t signed_message_length;

  //
  r = jade_sign_keypair(public_key, secret_key);
    assert(r == 0);

  //
  r = jade_sign(signed_message, &signed_message_length, message_1, MESSAGE_LENGTH, secret_key);
    assert(r == 0);
    assert(signed_message_length == (JADE_SIGN_BYTES + MESSAGE_LENGTH));

  //
  r = jade_sign_open(message_2, &message_length, signed_message, signed_message_length, public_key);
    assert(r == 0);
    for(int i=0; i<MESSAGE_LENGTH; i++)
    { assert(message_1[i] == message_2[i]); }

  #ifndef NOPRINT
  print_info(JADE_SIGN_ALGNAME, JADE_SIGN_ARCH, JADE_SIGN_IMPL);
  print_str_u8("public_key", public_key, JADE_SIGN_PUBLICKEYBYTES);
  print_str_u8("secret_key", secret_key, JADE_SIGN_SECRETKEYBYTES);
  print_str_u8("message", message_1, MESSAGE_LENGTH);
  print_str_u8("signed_message", signed_message, signed_message_length);
  #endif

  //flip one bit of the signed message so the verification fails
  signed_message[JADE_SIGN_BYTES] ^= 0x1;
  r = jade_sign_open(message_2, &message_length, signed_message, signed_message_length, public_key); 
    assert(r == -1);

  return 0;
}

