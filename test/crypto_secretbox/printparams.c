#include <stdio.h>

#include "api.h"
#include "jade_secretbox.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_SECRETBOX_ALGNAME\": \"%s\",\n", JADE_SECRETBOX_ALGNAME);
  printf(" \"JADE_SECRETBOX_ARCH\": \"%s\",\n", JADE_SECRETBOX_ARCH);
  printf(" \"JADE_SECRETBOX_IMPL\": \"%s\"", JADE_SECRETBOX_IMPL);

  printf(" \"JADE_SECRETBOX_NONCEBYTES\": %u,\n", JADE_SECRETBOX_NONCEBYTES);
  printf(" \"JADE_SECRETBOX_KEYBYTES\": %u,\n", JADE_SECRETBOX_KEYBYTES);
  printf(" \"JADE_SECRETBOX_ZEROBYTES\": %u,\n", JADE_SECRETBOX_ZEROBYTES);
  printf(" \"JADE_SECRETBOX_BOXZEROBYTES\": %u,\n", JADE_SECRETBOX_BOXZEROBYTES);

  printf("\n}\n");

  return 0;
}
