// adapted from SUPERCOP implementations;

#include <inttypes.h>
#include <string.h>
#include "randombytes.h"


// ////////////////////////////////////////////////////////////////////////////


#define ROTATE(v,c) ((v << c) | (v >> (32-c)))
#define QUARTERROUND(a,b,c,d) \
  a = a + b; d = ROTATE((d ^ a),16); \
  c = c + d; b = ROTATE((b ^ c),12); \
  a = a + b; d = ROTATE((d ^ a), 8); \
  c = c + d; b = ROTATE((b ^ c), 7);

static void chacha20_core(uint32_t output[16], const uint32_t input[16])
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

  output[0 ] = x0;
  output[1 ] = x1;
  output[2 ] = x2;
  output[3 ] = x3;
  output[4 ] = x4;
  output[5 ] = x5;
  output[6 ] = x6;
  output[7 ] = x7;
  output[8 ] = x8;
  output[9 ] = x9;
  output[10] = x10;
  output[11] = x11;
  output[12] = x12;
  output[13] = x13;
  output[14] = x14;
  output[15] = x15;
}

static const uint8_t sigma[16] = "expand 32-byte k";

static void chacha20_init(uint32_t x[16], const uint8_t n[8], const uint8_t k[32])
{
  #define LU8U32(p, i) ((((uint32_t)p[i+3])<<24) | (((uint32_t)p[i+2])<<16) | (((uint32_t)p[i+1])<<8) |(((uint32_t)p[i])<<0))

  x[0]  = LU8U32(sigma, 0);
  x[1]  = LU8U32(sigma, 4);
  x[2]  = LU8U32(sigma, 8);
  x[3]  = LU8U32(sigma, 12);

  x[4]  = LU8U32(k, 0 );
  x[5]  = LU8U32(k, 4 );
  x[6]  = LU8U32(k, 8 );
  x[7]  = LU8U32(k, 12);
  x[8]  = LU8U32(k, 16);
  x[9]  = LU8U32(k, 20);
  x[10] = LU8U32(k, 24);
  x[11] = LU8U32(k, 28);

  x[12] = 0;
  x[13] = 0;
  x[14] = LU8U32(n, 0);
  x[15] = LU8U32(n, 4);

  #undef LU8U32
}


static void chacha20(uint8_t *c, size_t clen, const uint8_t n[8], const uint8_t k[32])
{
  uint32_t x[16], output[16];
  size_t i;

  chacha20_init(x,n,k);
  while(clen > 0)
  {
    chacha20_core(output, x);
    x[12] += 1;
    if(x[12] == 0){ x[13] += 1; }

    if(clen >= 64)
    { for(i=0; i<64; i++)
      { c[i] = ((uint8_t*)output)[i]; }
      clen -= 64;
      c += 64;
    }
    else
    { for(i=0; i<clen; i++)
      { c[i] = ((uint8_t*)output)[i]; }
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
  uint8_t x[KEYBYTES + OUTPUTBYTES];
  chacha20(x,sizeof x,nonce,g);
  memcpy(n,x,KEYBYTES);
  memcpy(r,x + KEYBYTES,OUTPUTBYTES);
  return 0;
}


// ////////////////////////////////////////////////////////////////////////////


static uint8_t g0[KEYBYTES];
static uint8_t g1[KEYBYTES];

static uint8_t r0[OUTPUTBYTES];
static uint8_t r1[OUTPUTBYTES];

static size_t pos0 = OUTPUTBYTES;
static size_t pos1 = OUTPUTBYTES;

static void randombytes_internal(
  uint8_t *x, size_t xlen,
  uint8_t *g, uint8_t *r,
  size_t *pos
)
{
  while (xlen > 0)
  {
    if ((*pos) == OUTPUTBYTES)
    { crypto_rng(r,g,g);
      *pos = 0;
    }

    *x = r[*pos]; x += 1;
    xlen -= 1;
    r[*pos] = 0; *pos += 1;
  }
}


// ////////////////////////////////////////////////////////////////////////////

void resetrandombytes(void)
{
  pos0 = OUTPUTBYTES;
  memset(g0, 0, KEYBYTES);
}

void randombytes(uint8_t* x, size_t xlen)
{
  randombytes_internal(x,xlen,g0,r0,&pos0);
}

// ////////

void resetrandombytes1(void)
{
  pos1 = OUTPUTBYTES;
  memset(g1, 0, KEYBYTES);
}

void randombytes1(uint8_t* x, size_t xlen)
{
  randombytes_internal(x,xlen,g1,r1,&pos1);
}

// ////////

uint8_t* __jasmin_syscall_randombytes__(uint8_t* x, size_t xlen)
{
  randombytes(x, xlen);
  return x;
}

