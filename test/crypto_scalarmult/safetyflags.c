#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_scalarmult.h"

/*
int jade_scalarmult(
 uint8_t *q,
 const uint8_t *n,
 const uint8_t *p
);

int jade_scalarmult_base(
 uint8_t *q,
 const uint8_t *n
);
*/

int main(void)
{
  char *f[] = {xstr(jade_scalarmult,), xstr(jade_scalarmult_base,)};

  printf("-safetyparam \"%s>q,n,p;%zu,%zu,%zu",
    f[0],(size_t)JADE_SCALARMULT_BYTES,(size_t)JADE_SCALARMULT_SCALARBYTES,(size_t)JADE_SCALARMULT_BYTES);

  printf("|%s>q,n;%zu,%zu\"",
    f[1],(size_t)JADE_SCALARMULT_BYTES,(size_t)JADE_SCALARMULT_SCALARBYTES);

  fflush(stdout);
  return 0;
}
