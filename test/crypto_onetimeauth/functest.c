#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_onetimeauth.h"
#include "print.h"

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
  int r;
  uint8_t mac[JADE_ONETIMEAUTH_BYTES];
  uint8_t input[] = {0x61, 0x62, 0x63};
  uint8_t _key[JADE_ONETIMEAUTH_KEYBYTES];
  uint8_t* key = _key;

  key = __jasmin_syscall_randombytes__(key, JADE_ONETIMEAUTH_KEYBYTES);

  r = jade_onetimeauth(mac, input, sizeof(input), key);
    assert(r == 0);

  r = jade_onetimeauth_verify(mac, input, sizeof(input), key);
    assert(r == 0);

  print_info(JADE_ONETIMEAUTH_ALGNAME, JADE_ONETIMEAUTH_ARCH, JADE_ONETIMEAUTH_IMPL);
  print_str_u8("input", input, sizeof(input));
  print_str_u8("key", key, JADE_ONETIMEAUTH_KEYBYTES);
  print_str_u8("mac", mac, JADE_ONETIMEAUTH_BYTES);

  //flip one bit of input so the verification fails
  input[0] ^= 0x1;
  r = jade_onetimeauth_verify(mac, input, sizeof(input), key);
    assert(r == -1);

  return 0;
}

