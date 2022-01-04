#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>

#define DEBUG_PRINT 1

extern int jade_common_amd64_randombytes(uint8_t *buf, size_t n);
extern int randombytes(uint8_t *buf, size_t n);

void dump(uint8_t *b, size_t n)
{
  size_t i;
  for(i=0; i<n; i++)
  { printf("%02x",b[i]); }
  printf("\n");
}

int main()
{
  size_t n;
  uint8_t buf0[1024], buf1[1024];

  //for(n=1; n<1024; n++) // FIXME (global variables)
  //{ 
  n = 1024;

    memset(buf0, 0, n);
    memset(buf1, 0, n);
    jade_common_amd64_randombytes(buf0, n);
    randombytes(buf1, n);
    if( DEBUG_PRINT && memcmp(buf0,buf1,n) != 0 )
    { dump(buf0, n);
      dump(buf1, n); }

    assert( memcmp(buf0,buf1,n) == 0 );

  //}

  return 0;
}
