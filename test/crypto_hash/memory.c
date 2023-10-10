#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_hash.h"
#include "config.h"

int main(void)
{
  uint8_t *hash;
  uint8_t *input;
  size_t input_length;

  hash = malloc(sizeof(uint8_t) * JADE_HASH_BYTES);

  for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
  {
    input = malloc(sizeof(uint8_t) * input_length);
    memset(input, 0, sizeof(uint8_t) * input_length);

    jade_hash(hash, input, input_length);

    free(input);
    input = NULL;
  }

  free(hash);
  
  return 0;
}

