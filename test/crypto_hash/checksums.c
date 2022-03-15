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

#define CRYPTO_BYTES NAMESPACE(BYTES)
#define CRYPTO_ALGNAME NAMESPACE(ALGNAME)

#define crypto_hash JADE_NAMESPACE_LC


// ////////////////////////////////////////////////////////////////////////////

#define TUNE_BYTES 1536

#ifdef SMALL
 #define LOOPS 64
 #define MAXTEST_BYTES 128
#else
 #define LOOPS 512
 #define MAXTEST_BYTES 4096
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
  if (alloclen < CRYPTO_BYTES) alloclen = CRYPTO_BYTES;
  s->h  = alignedcalloc(&(s->free[0]), alloclen);
  s->m  = alignedcalloc(&(s->free[1]), alloclen);
  s->h2 = alignedcalloc(&(s->free[2]), alloclen);
  s->m2 = alignedcalloc(&(s->free[3]), alloclen);
  s->hlen = CRYPTO_BYTES;
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
    s.mlen = myrandom() % (MAXTEST_BYTES + 1);
    
    output_prepare(s.h2, s.h, s.hlen);
    input_prepare(s.m2, s.m, s.mlen);
    result = crypto_hash(s.h, s.m, s.mlen);
    if (result != 0) fail("crypto_hash returns nonzero");
    checksum(checksum_state, s.h, s.hlen);
    output_compare(s.h2, s.h, s.hlen,"crypto_hash");
    input_compare(s.m2, s.m, s.mlen,"crypto_hash");
    
    double_canary(s.h2, s.h, s.hlen);
    double_canary(s.m2, s.m, s.mlen);
    result = crypto_hash(s.h2, s.m2, s.mlen);
    if (result != 0) fail("crypto_hash returns nonzero");
    if (memcmp(s.h2, s.h, s.hlen) != 0) fail("crypto_hash is nondeterministic");
    
    double_canary(s.h2, s.h, s.hlen);
    double_canary(s.m2, s.m, s.mlen);
    result = crypto_hash(s.m2, s.m2, s.mlen);
    if (result != 0) fail("crypto_hash with m=h overlap returns nonzero");
    if (memcmp(s.m2, s.h, s.hlen) != 0) fail("crypto_hash does not handle m=h overlap");
    memcpy(s.m2, s.m, s.mlen);
  }
}

#include "try-anything.c"

int main()
{
  return try_anything_main();
}

