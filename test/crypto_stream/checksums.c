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
#include "jade_stream.h"

// ////////////////////////////////////////////////////////////////////////////

typedef struct state {
  uint8_t *k;
  uint8_t *n;
  uint8_t *m;
  uint8_t *c;
  uint8_t *s;
  uint8_t *k2;
  uint8_t *n2;
  uint8_t *m2;
  uint8_t *c2;
  uint8_t *s2;
  size_t klen;
  size_t nlen;
  size_t mlen;
  size_t clen;
  size_t slen;
  void* free[10];
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
 #define LOOPS 512
 #define MAXTEST_BYTES 128
#else
 #define LOOPS 4096
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
  if (alloclen < JADE_STREAM_KEYBYTES) alloclen = JADE_STREAM_KEYBYTES;
  if (alloclen < JADE_STREAM_NONCEBYTES) alloclen = JADE_STREAM_NONCEBYTES;

  s->k  = alignedcalloc(&(s->free[0]), alloclen);
  s->n  = alignedcalloc(&(s->free[1]), alloclen);
  s->m  = alignedcalloc(&(s->free[2]), alloclen);
  s->c  = alignedcalloc(&(s->free[3]), alloclen);
  s->s  = alignedcalloc(&(s->free[4]), alloclen);
  s->k2 = alignedcalloc(&(s->free[5]), alloclen);
  s->n2 = alignedcalloc(&(s->free[6]), alloclen);
  s->m2 = alignedcalloc(&(s->free[7]), alloclen);
  s->c2 = alignedcalloc(&(s->free[8]), alloclen);
  s->s2 = alignedcalloc(&(s->free[9]), alloclen);
  s->klen = JADE_STREAM_KEYBYTES;
  s->nlen = JADE_STREAM_NONCEBYTES;
}

void deallocate(state **_s)
{
  int i;
  state *s = *_s;

  for(i=0; i<10; i++)
  { free(s->free[i]); }
  free(s);
  *_s = NULL;
}

void unalign(state *s)
{
  ++(s->k);
  ++(s->n);
  ++(s->m);
  ++(s->c);
  ++(s->s);
  ++(s->k2);
  ++(s->n2);
  ++(s->m2);
  ++(s->c2);
  ++(s->s2);
}

void realign(state *s)
{
  --(s->k);
  --(s->n);
  --(s->m);
  --(s->c);
  --(s->s);
  --(s->k2);
  --(s->n2);
  --(s->m2);
  --(s->c2);
  --(s->s2);
}


void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long j;
  unsigned long long loop;
  int result;
  state s = *_s;
  
  for (loop = 0;loop < LOOPS;++loop)
  {
    s.mlen = myrandom() % (MAXTEST_BYTES + 1);
    s.clen = s.mlen;
    s.slen = s.mlen;
    
    output_prepare(s.s2, s.s, s.slen);
    input_prepare(s.n2, s.n, s.nlen);
    input_prepare(s.k2, s.k, s.klen);

    result = jade_stream(s.s, s.slen, s.n, s.k); 
    if (result != 0) fail("jade_stream returns nonzero");
    checksum(checksum_state, s.s, s.slen);
    output_compare(s.s2, s.s, s.slen, "jade_stream");
    input_compare(s.n2, s.n, s.nlen, "jade_stream");
    input_compare(s.k2, s.k, s.klen, "jade_stream");
    
    double_canary(s.s2, s.s, s.slen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);

    result = jade_stream(s.s2, s.slen, s.n2, s.k2);
    if (result != 0) fail("jade_stream returns nonzero");
    if (memcmp(s.s2, s.s, s.slen) != 0) fail("jade_stream is nondeterministic");
    
    output_prepare(s.c2, s.c, s.clen);
    input_prepare(s.m2, s.m, s.mlen);
    memcpy(s.n2, s.n, s.nlen);
    double_canary(s.n2, s.n, s.nlen);
    memcpy(s.k2, s.k, s.klen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_stream_xor(s.c, s.m, s.mlen, s.n, s.k);
    if (result != 0) fail("jade_stream_xor returns nonzero");
    
    for (j = 0;j < s.mlen;++j)
      if ((s.s[j] ^ s.m[j]) != s.c[j]) fail("jade_stream_xor does not match jade_stream");
    checksum(checksum_state, s.c, s.clen);
    output_compare(s.c2, s.c, s.clen, "jade_stream_xor");
    input_compare(s.m2, s.m, s.mlen, "jade_stream_xor");
    input_compare(s.n2, s.n, s.nlen, "jade_stream_xor");
    input_compare(s.k2, s.k, s.klen, "jade_stream_xor");
    
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_stream_xor(s.c2, s.m2, s.mlen, s.n2, s.k2);
    if (result != 0) fail("jade_stream_xor returns nonzero");
    if (memcmp(s.c2, s.c, s.clen) != 0) fail("jade_stream_xor is nondeterministic");
    
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_stream_xor(s.m2, s.m2, s.mlen, s.n, s.k);
    if (result != 0) fail("jade_stream_xor with m=c overlap returns nonzero");
    if (memcmp(s.m2, s.c, s.clen) != 0) fail("jade_stream_xor does not handle m=c overlap");
    memcpy(s.m2, s.m, s.mlen);
    result = jade_stream_xor(s.n2, s.m, s.mlen, s.n2, s.k);
    if (result != 0) fail("jade_stream_xor with n=c overlap returns nonzero");
    if (memcmp(s.n2, s.c, s.clen) != 0) fail("jade_stream_xor does not handle n=c overlap");
    memcpy(s.n2, s.n, s.nlen);
    result = jade_stream_xor(s.k2, s.m, s.mlen, s.n, s.k2);
    if (result != 0) fail("jade_stream_xor with k=c overlap returns nonzero");
    if (memcmp(s.k2, s.c, s.clen) != 0) fail("jade_stream_xor does not handle k=c overlap");
    memcpy(s.k2, s.k, s.klen);
  }
}

#include "try-anything.c"

int main(void)
{
  return try_anything_main();
}

