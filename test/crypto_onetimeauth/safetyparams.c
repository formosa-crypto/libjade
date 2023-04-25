#include <stdio.h>
#include <stddef.h>

#include "files.c"

#include "api.h"
#include "jade_onetimeauth.h"

/*
int jade_onetimeauth(
 uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);

int jade_onetimeauth_verify(
 const uint8_t *mac,
 const uint8_t *input,
 uint64_t input_length,
 const uint8_t *key
);
*/

int main(void)
{
  char *functions[2] = {xstr(jade_onetimeauth,), xstr(jade_onetimeauth_verify,)};

  char *filenames[3]
    = { "onetimeauth.safetyparam",
        xstr(jade_onetimeauth,.safetyparam), xstr(jade_onetimeauth_verify,.safetyparam)
      };

  FILE *files[3];

  f_map_fopen_write(files, filenames, 3);


  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>mac,input,key;%zu,input_length,%zu",
    functions[0],(size_t)JADE_ONETIMEAUTH_BYTES,(size_t)JADE_ONETIMEAUTH_KEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[1],"\"");
    fprintf(files[2],"-safetyparam \"");

  f_fprintf2(files[0], files[2], "%s>mac,input,key;%zu,input_length,%zu",
    functions[1],(size_t)JADE_ONETIMEAUTH_BYTES,(size_t)JADE_ONETIMEAUTH_KEYBYTES);

  f_fprintf2(files[0], files[2], "\"");

  f_map_fclose(files, 3);

  return 0;
}

