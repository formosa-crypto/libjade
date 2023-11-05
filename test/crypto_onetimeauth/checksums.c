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
#include "jade_onetimeauth.h"

// ////////////////////////////////////////////////////////////////////////////

typedef struct state {
  uint8_t *h;
  uint8_t *m;
  uint8_t *k;
  uint8_t *h2;
  uint8_t *m2;
  uint8_t *k2;
  size_t hlen;
  size_t mlen;
  size_t klen;
  void* free[6];
} state;

state* preallocate(void);
void allocate(state*);
void deallocate(state**);
void unalign(state*);
void realign(state*);
void test(unsigned char*,state *);

// ////////////////////////////////////////////////////////////////////////////

#define TUNE_BYTES 1536

#ifdef SMALL
 #define LOOPS 4096
 #define MAXTEST_BYTES 128
#else
 #define LOOPS 32768
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
  size_t alloclen = 0;
  if (alloclen < TUNE_BYTES) alloclen = TUNE_BYTES;
  if (alloclen < MAXTEST_BYTES) alloclen = MAXTEST_BYTES;
  if (alloclen < JADE_ONETIMEAUTH_BYTES) alloclen = JADE_ONETIMEAUTH_BYTES;
  if (alloclen < JADE_ONETIMEAUTH_KEYBYTES) alloclen = JADE_ONETIMEAUTH_KEYBYTES;

  s->h  = alignedcalloc(&(s->free[0]), alloclen);
  s->m  = alignedcalloc(&(s->free[1]), alloclen);
  s->k  = alignedcalloc(&(s->free[2]), alloclen);
  s->h2 = alignedcalloc(&(s->free[3]), alloclen);
  s->m2 = alignedcalloc(&(s->free[4]), alloclen);
  s->k2 = alignedcalloc(&(s->free[5]), alloclen);
  s->hlen = JADE_ONETIMEAUTH_BYTES;
  s->klen = JADE_ONETIMEAUTH_KEYBYTES;
}

void deallocate(state **_s)
{
  int i;
  state *s = *_s;

  for(i=0; i<6; i++)
  { free(s->free[i]); }
  free(s);
  *_s = NULL;
}

void unalign(state *s)
{
  ++(s->h);
  ++(s->m);
  ++(s->k);
  ++(s->h2);
  ++(s->m2);
  ++(s->k2);
}

void realign(state *s)
{
  --(s->h);
  --(s->m);
  --(s->k);
  --(s->h2);
  --(s->m2);
  --(s->k2);
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
    input_prepare(s.k2, s.k, s.klen);
    result = jade_onetimeauth(s.h, s.m, s.mlen, s.k);
    if (result != 0) fail("jade_onetimeauth returns nonzero");
    checksum(checksum_state, s.h, s.hlen);
    output_compare(s.h2, s.h, s.hlen,"jade_onetimeauth");
    input_compare(s.m2, s.m, s.mlen,"jade_onetimeauth");
    input_compare(s.k2, s.k, s.klen,"jade_onetimeauth");
    
    double_canary(s.h2, s.h, s.hlen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_onetimeauth(s.h2, s.m2, s.mlen, s.k2);
    if (result != 0) fail("jade_onetimeauth returns nonzero");
    if (memcmp(s.h2, s.h, s.hlen) != 0) fail("jade_onetimeauth is nondeterministic");
    
    double_canary(s.h2, s.h, s.hlen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_onetimeauth(s.m2, s.m2, s.mlen, s.k);
    if (result != 0) fail("jade_onetimeauth with m=h overlap returns nonzero");
    if (memcmp(s.m2, s.h, s.hlen) != 0) fail("jade_onetimeauth does not handle m=h overlap");
    memcpy(s.m2, s.m, s.mlen);
    result = jade_onetimeauth(s.k2, s.m, s.mlen, s.k2);
    if (result != 0) fail("jade_onetimeauth with k=h overlap returns nonzero");
    if (memcmp(s.k2, s.h, s.hlen) != 0) fail("jade_onetimeauth does not handle k=h overlap");
    memcpy(s.k2, s.k, s.klen);
    
    memcpy(s.h2, s.h, s.hlen);
    double_canary(s.h2, s.h, s.hlen);
    memcpy(s.m2, s.m, s.mlen);
    double_canary(s.m2, s.m, s.mlen);
    memcpy(s.k2, s.k, s.klen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_onetimeauth_verify(s.h, s.m, s.mlen, s.k);
    if (result != 0) fail("jade_onetimeauth_verify returns nonzero");
    input_compare(s.h2, s.h, s.hlen,"jade_onetimeauth_verify");
    input_compare(s.m2, s.m, s.mlen,"jade_onetimeauth_verify");
    input_compare(s.k2, s.k, s.klen,"jade_onetimeauth_verify");
    
    double_canary(s.h2, s.h, s.hlen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_onetimeauth_verify(s.h2, s.m2, s.mlen, s.k2);
    if (result != 0) fail("jade_onetimeauth_verify returns nonzero");
    
    s.h[myrandom() % s.hlen] += 1 + (myrandom() % 255);
    if (jade_onetimeauth_verify(s.h, s.m, s.mlen, s.k) == 0)
      if (memcmp(s.h2, s.h, s.hlen) != 0)
        fail("jade_onetimeauth_verify accepts modified authenticators");
    s.h[myrandom() % s.hlen] += 1 + (myrandom() % 255);
    if (jade_onetimeauth_verify(s.h, s.m, s.mlen, s.k) == 0)
      if (memcmp(s.h2, s.h, s.hlen) != 0)
        fail("jade_onetimeauth_verify accepts modified authenticators");
    s.h[myrandom() % s.hlen] += 1 + (myrandom() % 255);
    if (jade_onetimeauth_verify(s.h, s.m, s.mlen, s.k) == 0)
      if (memcmp(s.h2, s.h, s.hlen) != 0)
        fail("jade_onetimeauth_verify accepts modified authenticators");
  }
}

#include "try-anything.c"

int main(void)
{
  return try_anything_main();
}

