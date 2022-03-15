/*
 * Adapted from SUPERCOP.
 * Public domain.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>


#ifndef CANARY_LENGTH
#define CANARY_LENGTH 16
#endif

// ////////////////////////////////////////////////////////////////////////////

#define FOR(i,n) for (i = 0;i < n;++i)

static uint32_t L32(uint32_t x, int c) { return (x << c) | ((x&0xffffffff) >> (32 - c)); }

static uint32_t ld32(const uint8_t *x)
{
  uint32_t u = x[3];
  u = (u<<8)|x[2];
  u = (u<<8)|x[1];
  return (u<<8)|x[0];
}

static void st32(uint8_t *x, uint32_t u)
{
  int i;
  FOR(i,4) { x[i] = u; u >>= 8; }
}

static const uint8_t sigma[17] = "expand 32-byte k";

static void core(uint8_t *out, const uint8_t *in, const uint8_t *k)
{
  uint32_t w[16], x[16], y[16], t[4];
  int i, j, m;

  FOR(i,4) {
    x[5*i] = ld32(sigma+4*i);
    x[1+i] = ld32(k+4*i);
    x[6+i] = ld32(in+4*i);
    x[11+i] = ld32(k+16+4*i);
  }

  FOR(i,16) y[i] = x[i];

  FOR(i,20) {
    FOR(j,4) {
      FOR(m,4) t[m] = x[(5*j+4*m)%16];
      t[1] ^= L32(t[0]+t[3], 7);
      t[2] ^= L32(t[1]+t[0], 9);
      t[3] ^= L32(t[2]+t[1],13);
      t[0] ^= L32(t[3]+t[2],18);
      FOR(m,4) w[4*j+(j+m)%4] = t[m];
    }
    FOR(m,16) x[m] = w[m];
  }

  FOR(i,16) st32(out + 4 * i,x[i] + y[i]);
}

static void salsa20(uint8_t *c, uint64_t b, const uint8_t *n, const uint8_t *k)
{
  uint8_t z[16], x[64];
  uint32_t u;
  uint64_t i;

  if (!b) return;
  FOR(i,16) z[i] = 0;
  FOR(i,8) z[i] = n[i];
  while (b >= 64) {
    core(x,z,k);
    FOR(i,64) c[i] = x[i];
    u = 1;
    for (i = 8;i < 16;++i) {
      u += (uint32_t) z[i];
      z[i] = u;
      u >>= 8;
    }
    b -= 64;
    c += 64;
  }
  if (b) {
    core(x,z,k);
    FOR(i,b) c[i] = x[i];
  }
}

static void increment(uint8_t *n)
{
  if (!++n[0])
    if (!++n[1])
      if (!++n[2])
        if (!++n[3])
          if (!++n[4])
            if (!++n[5])
              if (!++n[6])
                if (!++n[7])
                { return; }
}

// ////////////////////////////////////////////////////////////////////////////


static void testvector(unsigned char *x, uint64_t xlen)
{
  static const unsigned char testvector_k[33] = "generate inputs for test vectors";
  static unsigned char testvector_n[8]; // TODO REFACTOR
  salsa20(x,xlen,testvector_n,testvector_k);
  increment(testvector_n);
}

unsigned long long myrandom(void)
{
  unsigned char x[8];
  unsigned long long result;
  testvector(x,8);
  result = x[7];
  result = (result<<8)|x[6];
  result = (result<<8)|x[5];
  result = (result<<8)|x[4];
  result = (result<<8)|x[3];
  result = (result<<8)|x[2];
  result = (result<<8)|x[1];
  result = (result<<8)|x[0];
  return result;
}

// ////////////////////////////////////////////////////////////////////////////

static void canary(uint8_t *x, uint64_t xlen)
{
  static const uint8_t canary_k[33] = "generate pad to catch overwrites";
  static uint8_t canary_n[8]; // TODO REFACTOR
  salsa20(x,xlen,canary_n,canary_k);
  increment(canary_n);
}

void double_canary(uint8_t *x2, uint8_t *x, uint64_t xlen)
{
  canary(x - CANARY_LENGTH, CANARY_LENGTH);
  canary(x + xlen, CANARY_LENGTH);
  memcpy(x2 - CANARY_LENGTH, x - CANARY_LENGTH, CANARY_LENGTH);
  memcpy(x2 + xlen, x + xlen, CANARY_LENGTH);
}

void input_prepare(uint8_t *x2, uint8_t *x, uint64_t xlen)
{
  testvector(x, xlen);
  canary(x - CANARY_LENGTH, CANARY_LENGTH);
  canary(x + xlen, CANARY_LENGTH);
  memcpy(x2 - CANARY_LENGTH, x - CANARY_LENGTH, xlen + (2*CANARY_LENGTH));
}

void input_compare(const uint8_t *x2, const uint8_t *x, uint64_t xlen, const char *fun)
{
  if (memcmp(x2 - CANARY_LENGTH, x - CANARY_LENGTH, xlen + 32))
  { fprintf(stderr,"%s overwrites input\n",fun);
    exit(111);
  }
}

void output_prepare(uint8_t *x2, uint8_t *x, uint64_t xlen)
{
  canary(x - CANARY_LENGTH, xlen + (2*CANARY_LENGTH));
  memcpy(x2 - CANARY_LENGTH, x - CANARY_LENGTH, xlen + (2*CANARY_LENGTH));
}

void output_compare(const uint8_t *x2, const uint8_t *x, uint64_t xlen, const char *fun)
{
  if (memcmp(x2 - CANARY_LENGTH, x - CANARY_LENGTH, CANARY_LENGTH))
  { fprintf(stderr,"%s writes before output\n",fun);
    exit(111);
  }
  if (memcmp(x2 + xlen, x + xlen, CANARY_LENGTH))
  { fprintf(stderr,"%s writes after output\n",fun);
    exit(111);
  }
}

// ////////////////////////////////////////////////////////////////////////////

void checksum(uint8_t *checksum_state, uint8_t *x, uint64_t xlen)
{
  uint8_t block[16];
  uint64_t i;

  while (xlen >= 16)
  { core(checksum_state, x, checksum_state);
    x += 16;
    xlen -= 16;
  }
  FOR(i,16) block[i] = 0;
  FOR(i,xlen) block[i] = x[i];
  block[xlen] = 1;
  checksum_state[0] ^= 1;
  core(checksum_state,block,checksum_state);
}

// ////////////////////////////////////////////////////////////////////////////

static void printword(const char *s)
{
  if (!*s) putchar('-');
  while (*s)
  { if (*s == ' ') putchar('_');
    else if (*s == '\t') putchar('_');
    else if (*s == '\r') putchar('_');
    else if (*s == '\n') putchar('_');
    else putchar(*s);
    ++s;
  }
  //putchar(' ');
}

void fail(const char *why)
{
  fprintf(stderr,"%s\n",why);
  exit(111);
}

// ////////////////////////////////////////////////////////////////////////////

uint8_t* alignedcalloc(void** c, uint64_t len)
{
  uint8_t *x;
  uint64_t i;

  x = (uint8_t *) calloc(1,len + 256);
  if (!x) fail("out of memory");
  if(c) *c = (void*) x; // copy original pointer to *c
  for (i = 0;i < len + 256;++i) x[i] = rand();
  x += 64;
  x += 63 & (-(unsigned long) x);
  for (i = 0;i < len;++i) x[i] = 0;
  return x;
}

// ////////////////////////////////////////////////////////////////////////////

int try_anything_main(void)
{
  long long i;
  uint8_t checksum_state[64];
  char checksum_hex[65];
  state *s;

  memset(checksum_state, 0, sizeof(checksum_state));
  memset(checksum_hex, 0, sizeof(checksum_hex)); 

  s = preallocate();
  allocate(s);
  srand(getpid()); // CHECKME
  unalign(s);
  test(checksum_state, s);
  deallocate(&s);

  for (i = 0;i < 32;++i) {
    checksum_hex[2 * i] = "0123456789abcdef"[15 & (checksum_state[i] >> 4)];
    checksum_hex[2 * i + 1] = "0123456789abcdef"[15 & checksum_state[i]];
  }
  checksum_hex[2 * i] = 0;
  printword(checksum_hex);
  //printf("\n");

  return 0;
}


