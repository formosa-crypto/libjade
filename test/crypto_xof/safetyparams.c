#include <stdio.h>

#include "files.c"

#include "api.h"
#include "jade_xof.h"

/*
int jade_xof(
 uint8_t *output,
 uint64_t output_length,
 const uint8_t *input,
 uint64_t input_length
);
*/

int main(void)
{
  char *functions[1] = {xstr(jade_xof,)};

  char *filenames[2]
    = { "xof.safetyparam",
        xstr(jade_xof,.safetyparam)
      };

  FILE *files[2];

  f_map_fopen_write(files, filenames, 2);

  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>output,input;output_length,input_length",
    functions[0]);

  f_fprintf2(files[0], files[1], "\"");

  f_map_fclose(files, 2);

  return 0;
}

