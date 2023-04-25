#include <stdio.h>
#include <stddef.h>

#include "files.c"

#include "api.h"
#include "jade_hash.h"

/*
int jade_hash(
 uint8_t *hash,
 const uint8_t *input,
 uint64_t input_length
);
*/

int main(void)
{
  char *functions[1] = {xstr(jade_hash,)};

  char *filenames[2]
    = { "hash.safetyparam",
        xstr(jade_hash,.safetyparam)
      };

  FILE *files[2];

  f_map_fopen_write(files, filenames, 2);

  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>hash,input;%zu,input_length",
    functions[0], (size_t)JADE_HASH_BYTES);

  f_fprintf2(files[0], files[1], "\"");

  f_map_fclose(files, 2);

  return 0;
}
