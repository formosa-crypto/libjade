#include <stdio.h>

#include "api.h"
#include "jade_scalarmult.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_SCALARMULT_ALGNAME\": \"%s\",\n", JADE_SCALARMULT_ALGNAME);
  printf(" \"JADE_SCALARMULT_ARCH\": \"%s\",\n", JADE_SCALARMULT_ARCH);
  printf(" \"JADE_SCALARMULT_IMPL\": \"%s\"", JADE_SCALARMULT_IMPL);

  printf(" \"JADE_SCALARMULT_BYTES\": %u,\n", JADE_SCALARMULT_BYTES);
  printf(" \"JADE_SCALARMULT_SCALARBYTES\": %u,\n", JADE_SCALARMULT_SCALARBYTES);

  printf("\n}\n");

  return 0;
}
