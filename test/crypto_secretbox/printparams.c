#include <stdio.h>

#include "api.h"
#include "namespace.h"

int main(void)
{
  printf("{\n");
  printf(" \"CRYPTO_NONCEBYTES\": %u,\n",    NAMESPACE(NONCEBYTES));
  printf(" \"CRYPTO_KEYBYTES\": %u,\n",      NAMESPACE(KEYBYTES));
  printf(" \"CRYPTO_ZEROBYTES\": %u,\n",     NAMESPACE(ZEROBYTES));
  printf(" \"CRYPTO_BOXZEROBYTES\": %u,\n",  NAMESPACE(BOXZEROBYTES));

  printf(" \"CRYPTO_ALGNAME\": \"%s\",\n", NAMESPACE(ALGNAME));
  printf(" \"CRYPTO_ARCH\": \"%s\",\n", NAMESPACE(ARCH));
  printf(" \"CRYPTO_IMPL\": \"%s\"\n}\n", NAMESPACE(IMPL));

  return 0;
}
