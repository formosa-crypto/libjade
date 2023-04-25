#include <stdio.h>
#include <stddef.h>

#include "files.c"

#include "api.h"
#include "jade_secretbox.h"

/*
int jade_secretbox(
  uint8_t *ciphertext,
  const uint8_t *plaintext,
  uint64_t length,
  const uint8_t *nonce,
  const uint8_t *key
);

int jade_secretbox_open(
  uint8_t *plaintext,
  const uint8_t *ciphertext,
  uint64_t length,
  const uint8_t *nonce,
  const uint8_t *key
);
*/

int main(void)
{
  char *functions[] = {xstr(jade_secretbox,), xstr(jade_secretbox_open,)};

  char *filenames[3]
    = { "secretbox.safetyparam",
        xstr(jade_secretbox,.safetyparam), xstr(jade_secretbox_open,.safetyparam)
      };

  FILE *files[3];

  f_map_fopen_write(files, filenames, 3);


  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>ciphertext,plaintext,nonce,key;length,length,%zu,%zu",
    functions[0],(size_t)JADE_SECRETBOX_NONCEBYTES,(size_t)JADE_SECRETBOX_KEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[1],"\"");
    fprintf(files[2],"-safetyparam \"");

  f_fprintf2(files[0], files[2], "%s>plaintext,ciphertext,nonce,key;length,length,%zu,%zu\"",
    functions[1],(size_t)JADE_SECRETBOX_NONCEBYTES,(size_t)JADE_SECRETBOX_KEYBYTES);

  f_fprintf2(files[0], files[2], "\"");

  f_map_fclose(files, 3);

  return 0;
}
