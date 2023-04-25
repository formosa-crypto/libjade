#include <stdio.h>
#include <stddef.h>

#include "files.c"

#include "api.h"
#include "jade_sign.h"

/*
int jade_sign_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);
*/

int main(void)
{
  char *functions[3] = {xstr(jade_sign_keypair,), xstr(jade_sign,), xstr(jade_sign_open,)};

  char *filenames[4]
    = { "sign.safetyparam",
        xstr(jade_sign_keypair,.safetyparam), xstr(jade_sign,.safetyparam), xstr(jade_sign_open,.safetyparam)  
      };      

  FILE *files[4];

  f_map_fopen_write(files, filenames, 4);


  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>public_key,secret_key;%zu,%zu",
    functions[0],(size_t)JADE_SIGN_PUBLICKEYBYTES,(size_t)JADE_SIGN_SECRETKEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[1],"\"");
    fprintf(files[2],"-safetyparam \"");

  f_fprintf2(files[0], files[2], "%s>signed_message,signed_message_length,message,secret_key;%zu+message_length,%zu,message_length,%zu",
    functions[1],(size_t)JADE_SIGN_BYTES,(size_t)(sizeof(uint64_t)),(size_t)JADE_SIGN_SECRETKEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[2],"\"");
    fprintf(files[3],"-safetyparam \"");

  f_fprintf2(files[0],files[3], "%s>message,message_length,signed_message,public_key;signed_message_length-%zu,%zu,signed_message_length,%zu",
    functions[2],(size_t)JADE_SIGN_BYTES,(size_t)(sizeof(uint64_t)),(size_t)JADE_SIGN_PUBLICKEYBYTES);

  f_fprintf2(files[0],files[3], "\"");

  f_map_fclose(files, 4);

  return 0;
}

