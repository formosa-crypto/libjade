#include <stdio.h>

#include "api.h"
#include "jade_xof.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_XOF_ALGNAME\": \"%s\",\n", JADE_XOF_ALGNAME);
  printf(" \"JADE_XOF_ARCH\": \"%s\",\n", JADE_XOF_ARCH);
  printf(" \"JADE_XOF_IMPL\": \"%s\"", JADE_XOF_IMPL);

  printf("\n}\n");

  return 0;
}
