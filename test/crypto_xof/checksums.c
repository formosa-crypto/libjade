/*
 * Adapted from SUPERCOP.
 * Public domain.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "try-anything.h"
#include "api.h"
#include "namespace.h"

// ////////////////////////////////////////////////////////////////////////////

typedef struct state {
  uint8_t *h;
  uint8_t *m;
  uint8_t *h2;
  uint8_t *m2;
  uint64_t hlen;
  uint64_t mlen;
  void* free[4];
} state;

state* preallocate(void);
void allocate(state*);
void deallocate(state**);
void unalign(state*);
void realign(state*);
void test(unsigned char*,state *);

// ////////////////////////////////////////////////////////////////////////////

#define crypto_xof JADE_NAMESPACE_LC

// ////////////////////////////////////////////////////////////////////////////

#define TUNE_BYTES 1536

#ifdef SMALL
 #define LOOPS 64
 #define MAXTEST_BYTES 128
 #define MAXTEST_OUTPUTBYTES 128
#else
 #define LOOPS 512
 #define MAXTEST_BYTES 4096
 #define MAXTEST_OUTPUTBYTES 1024
#endif

// ////////////////////////////////////////////////////////////////////////////

state* preallocate(void)
{
  state *s = calloc(sizeof(state), 1);
  return s;
}

// ////////////////////////////////////////////////////////////////////////////

void allocate(state *s)
{
  uint64_t alloclen = 0;

  if (alloclen < TUNE_BYTES) alloclen = TUNE_BYTES;
  if (alloclen < MAXTEST_BYTES) alloclen = MAXTEST_BYTES;
  if (alloclen < MAXTEST_OUTPUTBYTES) alloclen = MAXTEST_OUTPUTBYTES;
  s->h  = alignedcalloc(&(s->free[0]), alloclen);
  s->m  = alignedcalloc(&(s->free[1]), alloclen);
  s->h2 = alignedcalloc(&(s->free[2]), alloclen);
  s->m2 = alignedcalloc(&(s->free[3]), alloclen);
  s->hlen = 0;
}

void deallocate(state **_s)
{
  int i;
  state *s = *_s;

  for(i=0; i<4; i++)
  { free(s->free[i]); }
  free(s);
  *_s = NULL;
}

void unalign(state *s)
{
  ++(s->h);
  ++(s->m);
  ++(s->h2);
  ++(s->m2);
}

void realign(state *s)
{
  --(s->h);
  --(s->m);
  --(s->h2);
  --(s->m2);
}


void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long loop;
  int result;
  state s = *_s;

  for (loop = 0;loop < LOOPS;++loop) {
    for (s.hlen = 1; s.hlen < MAXTEST_OUTPUTBYTES; ++s.hlen) {
      s.mlen = myrandom() % (MAXTEST_BYTES + 1);
      
      output_prepare(s.h2, s.h, s.hlen);
      input_prepare(s.m2, s.m, s.mlen);
      result = crypto_xof(s.h, s.hlen, s.m, s.mlen);
      if (result != 0) fail("crypto_xof returns nonzero");
      checksum(checksum_state, s.h, s.hlen);
      output_compare(s.h2, s.h, s.hlen,"crypto_xof");
      input_compare(s.m2, s.m, s.mlen,"crypto_xof");
      
      double_canary(s.h2, s.h, s.hlen);
      double_canary(s.m2, s.m, s.mlen);
      result = crypto_xof(s.h2, s.hlen, s.m2, s.mlen);
      if (result != 0) fail("crypto_xof returns nonzero");
      if (memcmp(s.h2, s.h, s.hlen) != 0) fail("crypto_xof is nondeterministic");
      
      double_canary(s.h2, s.h, s.hlen);
      double_canary(s.m2, s.m, s.mlen);
      result = crypto_xof(s.m2, s.hlen, s.m2, s.mlen);
      if (result != 0) fail("crypto_xof with m=h overlap returns nonzero");
      if (memcmp(s.m2, s.h, s.hlen) != 0) fail("crypto_xof does not handle m=h overlap");
      memcpy(s.m2, s.m, s.mlen);
    }
  }
}

#include "try-anything.c"

int main()
{
  return try_anything_main();
}

