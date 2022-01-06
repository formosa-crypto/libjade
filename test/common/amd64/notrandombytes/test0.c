#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>

#define MAX_TEST_BYTES (1024*1024)
#define DEBUG_PRINT 1

extern int jade_common_amd64_randombytes(uint8_t *buf, uint32_t *in, size_t n);
extern int jade_common_amd64_randombytes1(uint8_t *buf, uint32_t *in, size_t n);
extern int randombytes(uint8_t *buf, size_t n);

void dump(char *s, uint8_t *b, size_t n)
{
  size_t i;
  printf("%s ", s);
  for(i=0; i<n; i++)
  { printf("%02x",b[i]); }
  printf("\n");
}

void dumps0(uint32_t *s)
{
  int i;
  printf("s0 \n - %016lx - \n", *(uint64_t*)s);
  printf(" - ");
  for(i=12; i<(12+8); i++)
  { printf("%08x ", s[i]); }
  printf("-\n - %08x -\n", s[20]);
}

void dumps1(uint32_t *s)
{
  int i;
  printf("s1 \n - %016lx - \n", *(uint64_t*)s);
  printf(" - ");
  for(i=2; i<(2+8); i++)
  { printf("%08x ", s[i]); }
  printf("-\n - %08x -\n", s[10]);
}

int main()
{
  size_t n;
  uint32_t state0[12+8+1];
  uint32_t state1[2+8+1];
  uint8_t buf0[1024], buf1[1024], buf2[1024];

  memset(state0, 0, sizeof(state0));
  memset(state1, 0, sizeof(state1));

  for(n=4; n<1024; n++)
  {
    memset(buf0, 0, n);
    memset(buf1, 0, n);
    memset(buf2, 0, n);

    jade_common_amd64_randombytes(buf0, state0, n);
    jade_common_amd64_randombytes1(buf1, state1, n);
    randombytes(buf2, n);

    if( DEBUG_PRINT &&
       ( memcmp(buf0,buf1,n) != 0 || memcmp(buf0,buf2,n) != 0))
    { dumps0(state0);
      dumps1(state1);
    }

    assert( memcmp(buf0,buf2,n) == 0 );
    assert( memcmp(buf1,buf2,n) == 0 );
  }
  printf("OK\n");

  return 0;
}
