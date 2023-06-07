#include <stdio.h>

#include "api.h"
#include "jade_kem.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_KEM_ALGNAME\": \"%s\",\n", JADE_KEM_ALGNAME);
  printf(" \"JADE_KEM_ARCH\": \"%s\",\n", JADE_KEM_ARCH);
  printf(" \"JADE_KEM_IMPL\": \"%s\",\n", JADE_KEM_IMPL);

  printf(" \"JADE_KEM_SECRETKEYBYTES\": %u,\n", JADE_KEM_SECRETKEYBYTES);
  printf(" \"JADE_KEM_PUBLICKEYBYTES\": %u,\n", JADE_KEM_PUBLICKEYBYTES);
  printf(" \"JADE_KEM_CIPHERTEXTBYTES\": %u,\n", JADE_KEM_CIPHERTEXTBYTES);

  printf(" \"JADE_KEM_KEYPAIRCOINBYTES\": %u,\n", JADE_KEM_KEYPAIRCOINBYTES);
  printf(" \"JADE_KEM_ENCCOINBYTES\": %u,\n", JADE_KEM_ENCCOINBYTES);

  printf(" \"JADE_KEM_BYTES\": %u", JADE_KEM_BYTES);

  printf("\n}\n");

  return 0;
}
