#include <stdio.h>
#include <stddef.h>

#include "files.c"

#include "api.h"
#include "jade_kem.h"

/*

int jade_kem_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_kem_enc(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key
);

int jade_kem_dec(
  uint8_t *shared_secret,
  const uint8_t *ciphertext,
  const uint8_t *secret_key
);

//

int jade_kem_keypair_derand(
  uint8_t *public_key,
  uint8_t *secret_key,
  const uint8_t *coins
);

int jade_kem_enc_derand(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key,
  const uint8_t *coins
);

*/

int main(void)
{
  char *functions[5]
    = { xstr(jade_kem_keypair,), xstr(jade_kem_enc,), xstr(jade_kem_dec,),
        xstr(jade_kem_keypair_derand,), xstr(jade_kem_enc_derand,)
      };

  char *filenames[6]
    = { "kem.safetyparam",
        xstr(jade_kem_keypair,.safetyparam), xstr(jade_kem_enc,.safetyparam), xstr(jade_kem_dec,.safetyparam),
        xstr(jade_kem_keypair_derand,.safetyparam), xstr(jade_kem_enc_derand,.safetyparam)
      };

  FILE *files[6];

  f_map_fopen_write(files, filenames, 6);


  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");

  f_fprintf2(files[0], files[1], "%s>public_key,secret_key;%zu,%zu",
    functions[0],(size_t)JADE_KEM_PUBLICKEYBYTES,(size_t)JADE_KEM_SECRETKEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[1],"\"");
    fprintf(files[2],"-safetyparam \"");

  f_fprintf2(files[0], files[2], "%s>ciphertext,shared_secret,public_key;%zu,%zu,%zu",
    functions[1],(size_t)JADE_KEM_CIPHERTEXTBYTES,(size_t)JADE_KEM_BYTES,(size_t)JADE_KEM_PUBLICKEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[2],"\"");
    fprintf(files[3],"-safetyparam \"");

  f_fprintf2(files[0],files[3], "%s>shared_secret,ciphertext,secret_key;%zu,%zu,%zu",
    functions[2],(size_t)JADE_KEM_BYTES,(size_t)JADE_KEM_CIPHERTEXTBYTES,(size_t)JADE_KEM_SECRETKEYBYTES);

    fprintf(files[0],"|");
    fprintf(files[3],"\"");
    fprintf(files[4],"-safetyparam \"");

  f_fprintf2(files[0],files[4], "%s>public_key,secret_key,coins;%zu,%zu,%zu",
    functions[3],(size_t)JADE_KEM_PUBLICKEYBYTES,(size_t)JADE_KEM_SECRETKEYBYTES,(size_t)JADE_KEM_KEYPAIRCOINBYTES);

    fprintf(files[0],"|");
    fprintf(files[4],"\"");
    fprintf(files[5],"-safetyparam \"");

  f_fprintf2(files[0], files[5], "%s>ciphertext,shared_secret,public_key,coins;%zu,%zu,%zu,%zu",
    functions[4],(size_t)JADE_KEM_CIPHERTEXTBYTES,(size_t)JADE_KEM_BYTES,(size_t)JADE_KEM_PUBLICKEYBYTES,(size_t)JADE_KEM_ENCCOINBYTES);

  f_fprintf2(files[0],files[5], "\"");

  f_map_fclose(files, 6);

  return 0;
}

