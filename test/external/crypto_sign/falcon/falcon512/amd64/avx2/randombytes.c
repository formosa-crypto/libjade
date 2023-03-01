
#include <stdint.h>
#include <string.h>
#include <stddef.h>
#include <stdio.h>

extern unsigned long long randomness;

#include "randombytes.h"

#define CHACHA20_KEYBYTES 32
#define CHACHA20_NONCEBYTES 8

#define crypto_rng_KEYBYTES 32
#define crypto_rng_OUTPUTBYTES 736

//
#define crypto_stream crypto_stream_chacha20
#define KEYBYTES CHACHA20_KEYBYTES
#define NONCEBYTES CHACHA20_NONCEBYTES
#define OUTPUTBYTES crypto_rng_OUTPUTBYTES

unsigned char __attribute__((aligned (16)))keybytes[crypto_rng_KEYBYTES] = {
  0x49, 0x54, 0xcc, 0x49, 0xa4, 0x94, 0xba, 0x0,
  0x41, 0x76, 0x78, 0x17, 0x5f, 0xb9, 0xfb, 0x23,
  0x18, 0x91, 0x65, 0xb7, 0x90, 0xb4, 0x9f, 0x65,
  0x91, 0x6c, 0xe4, 0xc1, 0xde, 0xac, 0xf4, 0x6c
};
unsigned char __attribute__((aligned (16)))outbytes[crypto_rng_OUTPUTBYTES];
unsigned long long pos = crypto_rng_OUTPUTBYTES;

#define ROUNDS 20


typedef uint32_t uint32;

static inline uint32 load_littleendian(const unsigned char *x)
{
  return *((uint32_t*)x);
}

static inline void store_littleendian(unsigned char *x,uint32 u)
{
  *((uint32_t*)x) = u;
}

static inline uint32 rotate(uint32 a, int d)
{
  return (a << d) | (a >> (32 - d));
}

static void quarterround(uint32_t *ptr_a, uint32_t *ptr_b, uint32_t *ptr_c, uint32_t *ptr_d)
{
  uint32_t a, b, c, d;
  a = *ptr_a;
  b = *ptr_b;
  c = *ptr_c;
  d = *ptr_d;

  a = a + b;
  d = d ^ a;
  d = rotate(d, 16);

  c = c + d;
  b = b ^ c;
  b = rotate(b, 12);

  a = a + b;
  d = d ^ a;
  d = rotate(d, 8);

  c = c + d;
  b = b ^ c;
  b = rotate(b, 7);

  *ptr_a = a;
  *ptr_b = b;
  *ptr_c = c;
  *ptr_d = d;

}


static int crypto_core_chacha20(
        unsigned char *out,
  const unsigned char *in,
  const unsigned char *k,
  const unsigned char *c
)
{
  uint32 x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;
  uint32 j0, j1, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15;
  int i;

    j0  = x0  = load_littleendian( c +  0);
    j1  = x1  = load_littleendian( c +  4);
    j2  = x2  = load_littleendian( c +  8);
    j3  = x3  = load_littleendian( c + 12);
    j4  = x4  = load_littleendian( k +  0);
    j5  = x5  = load_littleendian( k +  4);
    j6  = x6  = load_littleendian( k +  8);
    j7  = x7  = load_littleendian( k + 12);
    j8  = x8  = load_littleendian( k + 16);
    j9  = x9  = load_littleendian( k + 20);
    j10 = x10 = load_littleendian( k + 24);
    j11 = x11 = load_littleendian( k + 28);
    j12 = x12 = load_littleendian(in +  8);
    j13 = x13 = load_littleendian(in + 12);
    j14 = x14 = load_littleendian(in +  0);
    j15 = x15 = load_littleendian(in +  4);

  for (i = ROUNDS;i > 0;i -= 2) {
    quarterround(&x0, &x4, &x8,&x12);
    quarterround(&x1, &x5, &x9,&x13);
    quarterround(&x2, &x6,&x10,&x14);
    quarterround(&x3, &x7,&x11,&x15);
    quarterround(&x0, &x5,&x10,&x15);
    quarterround(&x1, &x6,&x11,&x12);
    quarterround(&x2, &x7, &x8,&x13);
    quarterround(&x3, &x4, &x9,&x14);
  }

  x0 += j0;
  x1 += j1;
  x2 += j2;
  x3 += j3;
  x4 += j4;
  x5 += j5;
  x6 += j6;
  x7 += j7;
  x8 += j8;
  x9 += j9;
  x10 += j10;
  x11 += j11;
  x12 += j12;
  x13 += j13;
  x14 += j14;
  x15 += j15;

  store_littleendian(out + 0,x0);
  store_littleendian(out + 4,x1);
  store_littleendian(out + 8,x2);
  store_littleendian(out + 12,x3);
  store_littleendian(out + 16,x4);
  store_littleendian(out + 20,x5);
  store_littleendian(out + 24,x6);
  store_littleendian(out + 28,x7);
  store_littleendian(out + 32,x8);
  store_littleendian(out + 36,x9);
  store_littleendian(out + 40,x10);
  store_littleendian(out + 44,x11);
  store_littleendian(out + 48,x12);
  store_littleendian(out + 52,x13);
  store_littleendian(out + 56,x14);
  store_littleendian(out + 60,x15);

  return 0;
}

static const unsigned char sigma[16] = "expand 32-byte k";

static int crypto_stream_chacha20(unsigned char *c,unsigned long long clen, const unsigned char *n, const unsigned char *k)
{
  unsigned char block[64];
  unsigned char kcopy[32];

  uint64_t inx6[6][2];

  if (!clen)
    return 0;

  for (size_t i = 0;i < 32;++i)
    kcopy[i] = k[i];
  for(size_t i = 0; i < 6; i++){
    inx6[i][0] = *(uint64_t*)n;
    inx6[i][1] = i;
  }

  while (clen >= 64) {
    crypto_core_chacha20(c, (unsigned char*)inx6, kcopy, sigma);

    inx6[0][1]++;

    clen -= 64;
    c += 64;
  }

  if (clen) {
    crypto_core_chacha20(block, (unsigned char*)inx6, kcopy, sigma);
    for (size_t i = 0;i < clen;++i)
      c[i] = block[i];
  }
  return 0;
}



unsigned char __attribute__((aligned (16)))nonce[NONCEBYTES] = {0};

static int crypto_rng(
        unsigned char *r, /* random output */
        unsigned char *n, /* new key */
  const unsigned char *g  /* old key */
)
{
  unsigned char __attribute__((aligned (16)))x[KEYBYTES + OUTPUTBYTES];
  crypto_stream(x,sizeof x,nonce,g);
  memcpy(n,x,KEYBYTES);
  memcpy(r,x + KEYBYTES,OUTPUTBYTES);
  return 0;
}

static void randombytes_internal(uint8_t *x, size_t xlen){

  while (xlen > 0) {
    unsigned long long ready;

    if (pos == crypto_rng_OUTPUTBYTES) {
      while (xlen > crypto_rng_OUTPUTBYTES) {
        crypto_rng(x,keybytes,keybytes);
        x += crypto_rng_OUTPUTBYTES;
        xlen -= crypto_rng_OUTPUTBYTES;
      }
      if (xlen == 0) return;

      crypto_rng(outbytes,keybytes,keybytes);
      pos = 0;
    }

    ready = crypto_rng_OUTPUTBYTES - pos;
    if (xlen <= ready) ready = xlen;
    memcpy(x,outbytes + pos,ready);
    memset(outbytes + pos,0,ready);
    x += ready;
    xlen -= ready;
    pos += ready;
  }

}

int randombytes(uint8_t *x, size_t xlen)
{
  randombytes_internal(x,xlen);
  randomness += xlen;
  return 0;
}




