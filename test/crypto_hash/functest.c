#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_hash.h"

/*

int jade_hash(uint8_t *output, uint8_t *input, uint64_t input_length);

*/

#define MAXBYTES 32

int main(void)
{
  uint8_t output[JADE_HASH_BYTES];
  uint8_t input[MAXBYTES];
  uint64_t length = 0;

  //
  memset(output, 0, JADE_HASH_BYTES);
  memset(input,  0, MAXBYTES);

  #ifndef NOPRINT
  print_info(JADE_HASH_ALGNAME, JADE_HASH_ARCH, JADE_HASH_IMPL);
  #endif

  //
  for(length=0; length <= MAXBYTES; length++)
  {
    jade_hash(output, input, length);

    #ifndef NOPRINT
    print_str_c_u8("input", length, input, length);
    print_str_c_u8("output", length, output, JADE_HASH_BYTES);
    #endif
  }

  return 0;
}

