#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_xof.h"
#include "randombytes.h"
#include "config.h"

int main(void)
{
  uint8_t *output;
  size_t output_length;
  uint8_t *input;
  size_t input_length;

  for (output_length = MINOUTBYTES; output_length <= MAXOUTBYTES; output_length++)
  { 
    output = malloc(sizeof(uint8_t) * output_length);

    for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
    {
      input = malloc(sizeof(uint8_t) * input_length);
      memset(input, 0, sizeof(uint8_t) * input_length);

      jade_xof(output, output_length, input, input_length);

      free(input);
      input = NULL;
    }

    free(output);
    output = NULL;
  }

  return 0;
}
