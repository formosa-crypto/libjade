#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_onetimeauth.h"

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
  char *f[] = {xstr(jade_onetimeauth,), xstr(jade_onetimeauth_verify,)};

  printf("-safetyparam \"%s>mac,input,key;%zu,input_length,%zu",
    f[0],(size_t)JADE_ONETIMEAUTH_BYTES,(size_t)JADE_ONETIMEAUTH_KEYBYTES);

  printf("|%s>mac,input,key;%zu,input_length,%zu\"",
    f[1],(size_t)JADE_ONETIMEAUTH_BYTES,(size_t)JADE_ONETIMEAUTH_KEYBYTES);

  fflush(stdout);
  return 0;
}

