#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_onetimeauth.h"

extern void __jasmin_syscall_randombytes__(uint8_t *x, uint64_t xlen);

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
  uint8_t key[JADE_ONETIMEAUTH_KEYBYTES];

  __jasmin_syscall_randombytes__(key, JADE_ONETIMEAUTH_KEYBYTES);

  r = jade_onetimeauth(mac, input, sizeof(input), key);
    assert(r == 0);

  r = jade_onetimeauth_verify(mac, input, sizeof(input), key);
    assert(r == 0);

  #ifndef NOPRINT
  print_info(JADE_ONETIMEAUTH_ALGNAME, JADE_ONETIMEAUTH_ARCH, JADE_ONETIMEAUTH_IMPL);
  print_str_u8("input", input, sizeof(input));
  print_str_u8("key", key, JADE_ONETIMEAUTH_KEYBYTES);
  print_str_u8("mac", mac, JADE_ONETIMEAUTH_BYTES);
  #endif

  //flip one bit of input so the verification fails
  input[0] ^= 0x1;
  r = jade_onetimeauth_verify(mac, input, sizeof(input), key);
    assert(r == -1);

  return 0;
}

