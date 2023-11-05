#include <stdio.h>
#include <stddef.h>

#include "files.c"

#include "api.h"
#include "jade_scalarmult.h"

int main(void)
{
  char *functions[] = {xstr(jade_scalarmult,), xstr(jade_scalarmult_base,)};

  char *filenames[3]
    = { "scalarmult.safetyparam",
        xstr(jade_scalarmult,.safetyparam), xstr(jade_scalarmult_base,.safetyparam)
      };

  FILE *files[3];

  f_map_fopen_write(files, filenames, 3);


  //
  f_fprintf2(files[0], files[1], "-safetyparam \"");


  f_fprintf2(files[0], files[1], "%s>q,n,p;%zu,%zu,%zu",
    functions[0],(size_t)JADE_SCALARMULT_BYTES,(size_t)JADE_SCALARMULT_SCALARBYTES,(size_t)JADE_SCALARMULT_BYTES);

    fprintf(files[0],"|");
    fprintf(files[1],"\"");
    fprintf(files[2],"-safetyparam \"");

  f_fprintf2(files[0], files[2], "%s>q,n;%zu,%zu",
    functions[1],(size_t)JADE_SCALARMULT_BYTES,(size_t)JADE_SCALARMULT_SCALARBYTES);

  f_fprintf2(files[0], files[2], "\"");

  f_map_fclose(files, 3);

  return 0;
}
