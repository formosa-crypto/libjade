// this file is not big endian friendly;
// adapted from SUPERCOP implementations;

#include <inttypes.h>
#include <string.h>
#include "notrandombytes.h"


// ////////////////////////////////////////////////////////////////////////////


#define ROTATE(v,c) ((v << c) | (v >> (32-c)))
#define QUARTERROUND(a,b,c,d) \
  a = a + b; d = ROTATE((d ^ a),16); \
  c = c + d; b = ROTATE((b ^ c),12); \
  a = a + b; d = ROTATE((d ^ a), 8); \
  c = c + d; b = ROTATE((b ^ c), 7);

static void chacha20_core(uint8_t output[64], const uint32_t input[16])
{
  uint32_t x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;
  int i;

  x0 = input[0];
  x1 = input[1];
  x2 = input[2];
  x3 = input[3];
  x4 = input[4];
  x5 = input[5];
  x6 = input[6];
  x7 = input[7];
  x8 = input[8];
  x9 = input[9];
  x10 = input[10];
  x11 = input[11];
  x12 = input[12];
  x13 = input[13];
  x14 = input[14];
  x15 = input[15];

  for (i = 20;i > 0;i -= 2) {
    QUARTERROUND( x0, x4, x8,x12)
    QUARTERROUND( x1, x5, x9,x13)
    QUARTERROUND( x2, x6,x10,x14)
    QUARTERROUND( x3, x7,x11,x15)
    QUARTERROUND( x0, x5,x10,x15)
    QUARTERROUND( x1, x6,x11,x12)
    QUARTERROUND( x2, x7, x8,x13)
    QUARTERROUND( x3, x4, x9,x14)
  }

  x0  += input[0] ;
  x1  += input[1] ;
  x2  += input[2] ;
  x3  += input[3] ;
  x4  += input[4] ;
  x5  += input[5] ;
  x6  += input[6] ;
  x7  += input[7] ;
  x8  += input[8] ;
  x9  += input[9] ;
  x10 += input[10];
  x11 += input[11];
  x12 += input[12];
  x13 += input[13];
  x14 += input[14];
  x15 += input[15];

  *((uint32_t*) (output + 0 )) = x0;
  *((uint32_t*) (output + 4 )) = x1;
  *((uint32_t*) (output + 8 )) = x2;
  *((uint32_t*) (output + 12)) = x3;
  *((uint32_t*) (output + 16)) = x4;
  *((uint32_t*) (output + 20)) = x5;
  *((uint32_t*) (output + 24)) = x6;
  *((uint32_t*) (output + 28)) = x7;
  *((uint32_t*) (output + 32)) = x8;
  *((uint32_t*) (output + 36)) = x9;
  *((uint32_t*) (output + 40)) = x10;
  *((uint32_t*) (output + 44)) = x11;
  *((uint32_t*) (output + 48)) = x12;
  *((uint32_t*) (output + 52)) = x13;
  *((uint32_t*) (output + 56)) = x14;
  *((uint32_t*) (output + 60)) = x15;
}

static const uint8_t sigma[16] = "expand 32-byte k";

static void chacha20_init(uint32_t x[16], const uint8_t n[8], const uint8_t k[32])
{
  x[0]  = *((uint32_t*) (sigma + 0));
  x[1]  = *((uint32_t*) (sigma + 4));
  x[2]  = *((uint32_t*) (sigma + 8));
  x[3]  = *((uint32_t*) (sigma + 12));

  x[4]  = *((uint32_t*) (k + 0 ));
  x[5]  = *((uint32_t*) (k + 4 ));
  x[6]  = *((uint32_t*) (k + 8 ));
  x[7]  = *((uint32_t*) (k + 12));
  x[8]  = *((uint32_t*) (k + 16));
  x[9]  = *((uint32_t*) (k + 20));
  x[10] = *((uint32_t*) (k + 24));
  x[11] = *((uint32_t*) (k + 28));

  x[12] = 0;
  x[13] = 0;
  x[14] = *((uint32_t*) (n + 0));
  x[15] = *((uint32_t*) (n + 4));
}


static void chacha20(uint8_t *c, uint64_t clen, const uint8_t n[8], const uint8_t k[32])
{
  uint32_t x[16];
  uint8_t output[64];
  uint64_t i;

  chacha20_init(x,n,k);
  while(clen > 0)
  {
    chacha20_core(output, x);
    *((uint64_t*) (x + 12)) += 1;

    if(clen >= 64)
    { for(i=0; i<64; i++)
      { c[i] = output[i]; }
      clen -= 64;
      c += 64;
    }
    else
    { for(i=0; i<clen; i++)
      { c[i] = output[i]; }
      return;
    }
  }
}


// ////////////////////////////////////////////////////////////////////////////


#define NONCEBYTES 8
#define KEYBYTES 32
#define OUTPUTBYTES 736

static const uint8_t nonce[NONCEBYTES] = {0};

static int crypto_rng(
        uint8_t *r, /* random output */
        uint8_t *n, /* new key */
  const uint8_t *g  /* old key */
)
{
  unsigned char x[KEYBYTES + OUTPUTBYTES];
  chacha20(x,sizeof x,nonce,g);
  memcpy(n,x,KEYBYTES);
  memcpy(r,x + KEYBYTES,OUTPUTBYTES);
  return 0;
}


// ////////////////////////////////////////////////////////////////////////////


static uint8_t g[KEYBYTES];
static uint8_t r[OUTPUTBYTES];
static uint64_t pos = OUTPUTBYTES;

static void randombytes_internal(uint8_t *x, uint64_t xlen)
{
  while (xlen > 0) {
    if (pos == OUTPUTBYTES) {
      crypto_rng(r,g,g);
      pos = 0;
    }
    *x++ = r[pos]; xlen -= 1;
    r[pos++] = 0;
  }
}


// ////////////////////////////////////////////////////////////////////////////


void notrandombytes(unsigned char *x, uint64_t xlen)
{
  randombytes_internal(x,xlen);
}


