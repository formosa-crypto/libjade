#include <stdio.h>

#include "api.h"
#include "jade_onetimeauth.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_ONETIMEAUTH_ALGNAME\": \"%s\",\n", JADE_ONETIMEAUTH_ALGNAME);
  printf(" \"JADE_ONETIMEAUTH_ARCH\": \"%s\",\n", JADE_ONETIMEAUTH_ARCH);
  printf(" \"JADE_ONETIMEAUTH_IMPL\": \"%s\"", JADE_ONETIMEAUTH_IMPL);

  printf(" \"JADE_ONETIMEAUTH_BYTES\": %u,\n", JADE_ONETIMEAUTH_BYTES);
  printf(" \"JADE_ONETIMEAUTH_KEYBYTES\": %u,\n", JADE_ONETIMEAUTH_KEYBYTES);

  printf("\n}\n");

  return 0;
}
