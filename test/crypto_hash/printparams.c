#include <stdio.h>

#include "api.h"
#include "jade_hash.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_HASH_ALGNAME\": \"%s\",\n", JADE_HASH_ALGNAME);
  printf(" \"JADE_HASH_ARCH\": \"%s\",\n", JADE_HASH_ARCH);
  printf(" \"JADE_HASH_IMPL\": \"%s\"", JADE_HASH_IMPL);

  printf(" \"JADE_HASH_BYTES\": %u,\n", JADE_HASH_BYTES);

  printf("\n}\n");

  return 0;
}
