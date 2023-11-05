#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_stream.h"
#include "randombytes.h"
#include "config.h"

int main(void)
{
  uint8_t *output;
  uint8_t *input;
  size_t input_length;
  uint8_t *nonce;
  uint8_t *key;

  nonce = malloc(sizeof(uint8_t) * JADE_STREAM_NONCEBYTES);
  key = malloc(sizeof(uint8_t) * JADE_STREAM_KEYBYTES);

  __jasmin_syscall_randombytes__(nonce, JADE_STREAM_NONCEBYTES);
  __jasmin_syscall_randombytes__(key, JADE_STREAM_KEYBYTES);


  for (input_length = MININBYTES; input_length <= MAXINBYTES; input_length++)
  {
    input = malloc(sizeof(uint8_t) * input_length);
    memset(input, 0, sizeof(uint8_t) * input_length);
    output = malloc(sizeof(uint8_t) * input_length);

    jade_stream_xor(output, input, input_length, nonce, key);
    jade_stream(input, input_length, nonce, key);

    free(input);
    free(output);
    input = NULL;
    output = NULL;
  }

  free(nonce);
  free(key);

  return 0;
}

