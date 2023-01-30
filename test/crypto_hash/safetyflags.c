#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_hash.h"

/*
int jade_hash(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);
*/

int main(void)
{
  char *f = {xstr(jade_hash,)};

  printf("-safetyparam \"%s>hash,input;%zu,input_length\"",
    f, (size_t)JADE_HASH_BYTES);

  fflush(stdout);
  return 0;
}
