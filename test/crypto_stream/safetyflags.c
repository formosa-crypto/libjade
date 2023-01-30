#include <stdio.h>
#include <stddef.h>

#include "api.h"
#include "jade_stream.h"

/*
int jade_stream(
 uint8_t *stream,
 uint64_t stream_length,
 const uint8_t *nonce,
 const uint8_t *key
);

int jade_stream_xor(
 uint8_t *output,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *nonce,
 const uint8_t *key
);
*/

int main(void)
{
  char *f[] = {xstr(jade_stream,), xstr(jade_stream_xor,)};

  printf("-safetyparam \"%s>stream,nonce,key;stream_length,%zu,%zu",
    f[0],(size_t)JADE_STREAM_NONCEBYTES,(size_t)JADE_STREAM_KEYBYTES);

  printf("|%s>output,input,nonce,key;input_length,input_length,%zu,%zu\"",
    f[1],(size_t)JADE_STREAM_NONCEBYTES,(size_t)JADE_STREAM_KEYBYTES);

  fflush(stdout);
  return 0;
}
