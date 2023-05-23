#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "api.h"

#include "jade_hash.h"
#include "print.h"

int main(void)
{
  int r;
  uint8_t hash[JADE_HASH_BYTES];
  uint8_t input[] = {0x61, 0x62, 0x63};

  //
  r = jade_hash(hash, input, sizeof(input));
    assert(r == 0);

  print_info(JADE_HASH_ALGNAME, JADE_HASH_ARCH, JADE_HASH_IMPL);
  print_str_u8("input", input, sizeof(input));
  print_str_u8("hash", hash, JADE_HASH_BYTES);

  return 0;
}

