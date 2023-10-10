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
#include "jade_secretbox.h"

// ////////////////////////////////////////////////////////////////////////////

typedef struct state {
  uint8_t *k;
  uint8_t *n;
  uint8_t *m;
  uint8_t *c;
  uint8_t *t;
  uint8_t *k2;
  uint8_t *n2;
  uint8_t *m2;
  uint8_t *c2;
  uint8_t *t2;
  size_t klen;
  size_t nlen;
  size_t mlen;
  size_t clen;
  size_t tlen;
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
  if (alloclen < JADE_SECRETBOX_KEYBYTES) alloclen = JADE_SECRETBOX_KEYBYTES;
  if (alloclen < JADE_SECRETBOX_NONCEBYTES) alloclen = JADE_SECRETBOX_NONCEBYTES;

  s->k  = alignedcalloc(&(s->free[0]), alloclen);
  s->n  = alignedcalloc(&(s->free[1]), alloclen);
  s->m  = alignedcalloc(&(s->free[2]), alloclen);
  s->c  = alignedcalloc(&(s->free[3]), alloclen);
  s->t  = alignedcalloc(&(s->free[4]), alloclen);
  s->k2 = alignedcalloc(&(s->free[5]), alloclen);
  s->n2 = alignedcalloc(&(s->free[6]), alloclen);
  s->m2 = alignedcalloc(&(s->free[7]), alloclen);
  s->c2 = alignedcalloc(&(s->free[8]), alloclen);
  s->t2 = alignedcalloc(&(s->free[9]), alloclen);

  s->klen = JADE_SECRETBOX_KEYBYTES;
  s->nlen = JADE_SECRETBOX_NONCEBYTES;
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
  ++(s->t);
  ++(s->k2);
  ++(s->n2);
  ++(s->m2);
  ++(s->c2);
  ++(s->t2);
}

void realign(state *s)
{
  --(s->k);
  --(s->n);
  --(s->m);
  --(s->c);
  --(s->t);
  --(s->k2);
  --(s->n2);
  --(s->m2);
  --(s->c2);
  --(s->t2);
}

void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long j;
  unsigned long long loop;
  int result;
  state s = *_s;
  
  for (loop = 0;loop < LOOPS;++loop) {
    s.mlen = myrandom() % (MAXTEST_BYTES + 1);
    s.clen = s.mlen;
    s.tlen = s.mlen;
    if (s.mlen < JADE_SECRETBOX_ZEROBYTES) continue;

    output_prepare(s.c2, s.c, s.clen);
    input_prepare(s.m2, s.m, s.mlen);
    input_prepare(s.n2, s.n, s.nlen);
    input_prepare(s.k2, s.k, s.klen);
    for (j = 0;j < JADE_SECRETBOX_ZEROBYTES;++j) s.m[j] = 0;
    for (j = 0;j < JADE_SECRETBOX_ZEROBYTES;++j) s.m2[j] = 0;
    result = jade_secretbox(s.c, s.m, s.mlen, s.n, s.k);
    if (result != 0) fail("jade_secretbox returns nonzero");
    for (j = 0;j < JADE_SECRETBOX_BOXZEROBYTES;++j)
      if (s.c[j] != 0) fail("jade_secretbox does not clear extra bytes");
    checksum(checksum_state, s.c, s.clen);
    output_compare(s.c2, s.c, s.clen,"jade_secretbox");
    input_compare(s.m2, s.m, s.mlen,"jade_secretbox");
    input_compare(s.n2, s.n, s.nlen,"jade_secretbox");
    input_compare(s.k2, s.k, s.klen,"jade_secretbox");
    
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_secretbox(s.c2, s.m2, s.mlen, s.n2, s.k2);
    if (result != 0) fail("jade_secretbox returns nonzero");
    if (memcmp(s.c2, s.c, s.clen) != 0) fail("jade_secretbox is nondeterministic");
    
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_secretbox(s.m2, s.m2, s.mlen, s.n, s.k);
    if (result != 0) fail("jade_secretbox with m=c overlap returns nonzero");
    if (memcmp(s.m2, s.c, s.clen) != 0) fail("jade_secretbox does not handle m=c overlap");
    memcpy(s.m2, s.m, s.mlen);
    result = jade_secretbox(s.n2, s.m, s.mlen, s.n2, s.k);
    if (result != 0) fail("jade_secretbox with n=c overlap returns nonzero");
    if (memcmp(s.n2, s.c, s.clen) != 0) fail("jade_secretbox does not handle n=c overlap");
    memcpy(s.n2, s.n, s.nlen);
    result = jade_secretbox(s.k2, s.m, s.mlen, s.n, s.k2);
    if (result != 0) fail("jade_secretbox with k=c overlap returns nonzero");
    if (memcmp(s.k2, s.c, s.clen) != 0) fail("jade_secretbox does not handle k=c overlap");
    memcpy(s.k2, s.k, s.klen);
    
    output_prepare(s.t2, s.t, s.tlen);
    memcpy(s.c2, s.c, s.clen);
    double_canary(s.c2, s.c, s.clen);
    memcpy(s.n2, s.n, s.nlen);
    double_canary(s.n2, s.n, s.nlen);
    memcpy(s.k2, s.k, s.klen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_secretbox_open(s.t, s.c, s.clen, s.n, s.k);
    if (result != 0) fail("jade_secretbox_open returns nonzero");
    if (memcmp(s.t, s.m, s.mlen) != 0) fail("jade_secretbox_open does not match m");
    checksum(checksum_state, s.t, s.tlen);
    output_compare(s.t2, s.t, s.tlen,"jade_secretbox_open");
    input_compare(s.c2, s.c, s.clen,"jade_secretbox_open");
    input_compare(s.n2, s.n, s.nlen,"jade_secretbox_open");
    input_compare(s.k2, s.k, s.klen,"jade_secretbox_open");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_secretbox_open(s.t2, s.c2, s.clen, s.n2, s.k2);
    if (result != 0) fail("jade_secretbox_open returns nonzero");
    if (memcmp(s.t2, s.t, s.tlen) != 0) fail("jade_secretbox_open is nondeterministic");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.n2, s.n, s.nlen);
    double_canary(s.k2, s.k, s.klen);
    result = jade_secretbox_open(s.c2, s.c2, s.clen, s.n, s.k);
    if (result != 0) fail("jade_secretbox_open with c=t overlap returns nonzero");
    if (memcmp(s.c2, s.t, s.tlen) != 0) fail("jade_secretbox_open does not handle c=t overlap");
    memcpy(s.c2, s.c, s.clen);
    result = jade_secretbox_open(s.n2, s.c, s.clen, s.n2, s.k);
    if (result != 0) fail("jade_secretbox_open with n=t overlap returns nonzero");
    if (memcmp(s.n2, s.t, s.tlen) != 0) fail("jade_secretbox_open does not handle n=t overlap");
    memcpy(s.n2, s.n, s.nlen);
    result = jade_secretbox_open(s.k2, s.c, s.clen, s.n, s.k2);
    if (result != 0) fail("jade_secretbox_open with k=t overlap returns nonzero");
    if (memcmp(s.k2, s.t, s.tlen) != 0) fail("jade_secretbox_open does not handle k=t overlap");
    memcpy(s.k2, s.k, s.klen);
  }
}

#include "try-anything.c"

int main(void)
{
  return try_anything_main();
}

