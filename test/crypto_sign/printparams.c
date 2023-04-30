#include <stdio.h>

#include "api.h"
#include "jade_sign.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_SIGN_ALGNAME\": \"%s\",\n", JADE_SIGN_ALGNAME);
  printf(" \"JADE_SIGN_ARCH\": \"%s\",\n", JADE_SIGN_ARCH);
  printf(" \"JADE_SIGN_IMPL\": \"%s\"", JADE_SIGN_IMPL);

  printf(" \"JADE_SIGN_SECRETKEYBYTES\": %u,\n", JADE_SIGN_SECRETKEYBYTES);
  printf(" \"JADE_SIGN_PUBLICKEYBYTES\": %u,\n", JADE_SIGN_PUBLICKEYBYTES);
  printf(" \"JADE_SIGN_BYTES\": %u,\n", JADE_SIGN_BYTES);
  printf(" \"JADE_SIGN_KEYPAIRCOINBYTES\": %u,\n", JADE_SIGN_KEYPAIRCOINBYTES);

  printf("\n}\n");

  return 0;
}
