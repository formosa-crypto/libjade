#include <stdio.h>

#include "api.h"
#include "jade_xof.h"

/*
int jade_xof(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);
*/

int main(void)
{
  char *f = {xstr(jade_xof,)};

  printf("-safetyparam \"%s>output,input;output_length,input_length\"",f);

  fflush(stdout);
  return 0;
}

