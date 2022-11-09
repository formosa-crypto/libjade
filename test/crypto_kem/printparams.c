#include <stdio.h>

#include "api.h"
#include "namespace.h"

int main(void)
{
  printf("{\n");
  printf(" \"CRYPTO_SECRETKEYBYTES\": %u,\n", NAMESPACE(SECRETKEYBYTES));
  printf(" \"CRYPTO_PUBLICKEYBYTES\": %u,\n", NAMESPACE(PUBLICKEYBYTES));
  printf(" \"CRYPTO_CIPHERTEXTBYTES\": %u,\n", NAMESPACE(CIPHERTEXTBYTES));
  printf(" \"CRYPTO_BYTES\": %u,\n", NAMESPACE(BYTES));

  printf(" \"CRYPTO_ALGNAME\": \"%s\",\n", NAMESPACE(ALGNAME));
  printf(" \"CRYPTO_ARCH\": \"%s\",\n", NAMESPACE(ARCH));
  printf(" \"CRYPTO_IMPL\": \"%s\"\n}\n", NAMESPACE(IMPL));

  return 0;
}
