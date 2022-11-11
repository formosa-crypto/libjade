#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_xof.h"

/*

int jade_xof(
  uint8_t *output,
  uint64_t output_length,
  uint8_t *input,
  uint64_t input_length
);

*/

#define MAXOUTBYTES 64
#define MAXINBYTES 32

int main(void)
{
  uint8_t hash[MAXOUTBYTES];
  uint64_t hash_length = 0;
  uint8_t input[MAXINBYTES];
  uint64_t input_length = 0;

  //
  memset(hash, 0, MAXOUTBYTES);
  memset(input, 0, MAXINBYTES);

  #ifndef NOPRINT
  print_info(JADE_XOF_ALGNAME, JADE_XOF_ARCH, JADE_XOF_IMPL);
  #endif

  //
  for(hash_length=16; hash_length <= MAXOUTBYTES; hash_length *= 2)
  { for(input_length=0; input_length <= MAXINBYTES; input_length++)
    {
      jade_xof(hash, hash_length, input, input_length);

      #ifndef NOPRINT
      print_str_c_c_u8("input", hash_length, input_length, input, input_length);
      print_str_c_c_u8("hash", hash_length, input_length, hash, hash_length);
      #endif
    }
  }

  return 0;
}

