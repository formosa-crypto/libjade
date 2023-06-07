#include <stdio.h>
#include <stddef.h>

#include "files.c"

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
  char *functions[2] = {xstr(jade_stream,), xstr(jade_stream_xor,)};

  char *filenames[3]
    = { "stream.safetyparam",
        xstr(jade_stream,.safetyparam), xstr(jade_stream_xor,.safetyparam)
      };

  FILE *files[3];

  f_map_fopen_write(files, filenames, 3);


  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>stream,nonce,key;stream_length,%zu,%zu",
    functions[0],(size_t)JADE_STREAM_NONCEBYTES,(size_t)JADE_STREAM_KEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[1],"\"");
    fprintf(files[2],"-safetyparam \"");

  f_fprintf2(files[0], files[2], "%s>output,input,nonce,key;input_length,input_length,%zu,%zu",
    functions[1],(size_t)JADE_STREAM_NONCEBYTES,(size_t)JADE_STREAM_KEYBYTES);

  f_fprintf2(files[0], files[2], "\"");

  f_map_fclose(files, 3);

  return 0;
}
