#include <stdio.h>

#include "api.h"
#include "jade_stream.h"

int main(void)
{
  printf("{\n");

  printf(" \"JADE_STREAM_ALGNAME\": \"%s\",\n", JADE_STREAM_ALGNAME);
  printf(" \"JADE_STREAM_ARCH\": \"%s\",\n", JADE_STREAM_ARCH);
  printf(" \"JADE_STREAM_IMPL\": \"%s\"", JADE_STREAM_IMPL);

  printf(" \"JADE_STREAM_NONCEBYTES\": %u,\n", JADE_STREAM_NONCEBYTES);
  printf(" \"JADE_STREAM_KEYBYTES\": %u,\n", JADE_STREAM_KEYBYTES);

  printf("\n}\n");

  return 0;
}
