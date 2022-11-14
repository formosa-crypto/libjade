#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "print.h"

#include "api.h"
#include "jade_xof.h"

/*

int jade_xof_shake256_amd64_ref(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);

*/

int main(void)
{
  int r;

  #define INPUT_LENGTH 3
  #define OUTPUT_LENGTH 12
  uint8_t input[INPUT_LENGTH] = {0x61, 0x62, 0x63};
  uint8_t output[OUTPUT_LENGTH];

  //
  r = jade_xof(output, OUTPUT_LENGTH, input, INPUT_LENGTH);
    assert(r == 0);

  #ifndef NOPRINT
  print_info(JADE_XOF_ALGNAME, JADE_XOF_ARCH, JADE_XOF_IMPL);
  print_str_u8("input", input, INPUT_LENGTH);
  print_str_u8("output", output, OUTPUT_LENGTH);
  #endif

  return 0;
}

