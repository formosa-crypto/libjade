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
#include "jade_scalarmult.h"

// ////////////////////////////////////////////////////////////////////////////

typedef struct state {
  uint8_t *a;
  uint8_t *b;
  uint8_t *c;
  uint8_t *d;
  uint8_t *e;
  uint8_t *f;
  uint8_t *a2;
  uint8_t *b2;
  uint8_t *c2;
  uint8_t *d2;
  uint8_t *e2;
  uint8_t *f2;
  size_t alen;
  size_t blen;
  size_t clen;
  size_t dlen;
  size_t elen;
  size_t flen;
  void* free[12];
} state;

state* preallocate(void);
void allocate(state*);
void deallocate(state**);
void unalign(state*);
void realign(state*);
void test(unsigned char*,state *);

// ////////////////////////////////////////////////////////////////////////////

#ifdef SMALL
 #define LOOPS 64
#else
 #define LOOPS 512
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
  if (alloclen < JADE_SCALARMULT_SCALARBYTES) alloclen = JADE_SCALARMULT_SCALARBYTES;
  if (alloclen < JADE_SCALARMULT_BYTES) alloclen = JADE_SCALARMULT_BYTES;
  s->a  = alignedcalloc(&(s->free[0]), alloclen);
  s->b  = alignedcalloc(&(s->free[1]), alloclen);
  s->c  = alignedcalloc(&(s->free[2]), alloclen);
  s->d  = alignedcalloc(&(s->free[3]), alloclen);
  s->e  = alignedcalloc(&(s->free[4]), alloclen);
  s->f  = alignedcalloc(&(s->free[5]), alloclen);
  s->a2 = alignedcalloc(&(s->free[6]), alloclen);
  s->b2 = alignedcalloc(&(s->free[7]), alloclen);
  s->c2 = alignedcalloc(&(s->free[8]), alloclen);
  s->d2 = alignedcalloc(&(s->free[9]), alloclen);
  s->e2 = alignedcalloc(&(s->free[10]), alloclen);
  s->f2 = alignedcalloc(&(s->free[11]), alloclen);
  s->alen = JADE_SCALARMULT_SCALARBYTES;
  s->blen = JADE_SCALARMULT_SCALARBYTES;
  s->clen = JADE_SCALARMULT_BYTES;
  s->dlen = JADE_SCALARMULT_BYTES;
  s->elen = JADE_SCALARMULT_BYTES;
  s->flen = JADE_SCALARMULT_BYTES;
}

void deallocate(state **_s)
{
  int i;
  state *s = *_s;

  for(i=0; i<12; i++)
  { free(s->free[i]); }
  free(s);
  *_s = NULL;
}

void unalign(state *s)
{
  ++(s->a);
  ++(s->b);
  ++(s->c);
  ++(s->d);
  ++(s->e);
  ++(s->f);
  ++(s->a2);
  ++(s->b2);
  ++(s->c2);
  ++(s->d2);
  ++(s->e2);
  ++(s->f2);
}

void realign(state *s)
{
  --(s->a);
  --(s->b);
  --(s->c);
  --(s->d);
  --(s->e);
  --(s->f);
  --(s->a2);
  --(s->b2);
  --(s->c2);
  --(s->d2);
  --(s->e2);
  --(s->f2);
}

void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long loop;
  int result;
  state s = *_s;

  for (loop = 0;loop < LOOPS;++loop) {

    output_prepare(s.c2, s.c, s.clen);
    input_prepare(s.a2, s.a, s.alen);
    result = jade_scalarmult_base(s.c, s.a);
    if (result != 0) fail("jade_scalarmult_base returns nonzero");
    checksum(checksum_state, s.c, s.clen);
    output_compare(s.c2, s.c, s.clen, "jade_scalarmult_base");
    input_compare(s.a2, s.a, s.alen, "jade_scalarmult_base");

    double_canary(s.c2, s.c, s.clen);
    double_canary(s.a2, s.a, s.alen);
    result = jade_scalarmult_base(s.c2, s.a2);
    if (result != 0) fail("jade_scalarmult_base returns nonzero");
    if (memcmp(s.c2, s.c, s.clen) != 0) fail("jade_scalarmult_base is nondeterministic");
    
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.a2, s.a, s.alen);
    result = jade_scalarmult_base(s.a2, s.a2);
    if (result != 0) fail("jade_scalarmult_base with a=c overlap returns nonzero");
    if (memcmp(s.a2, s.c, s.clen) != 0) fail("jade_scalarmult_base does not handle a=c overlap");
    memcpy(s.a2, s.a, s.alen);
    
    output_prepare(s.d2, s.d, s.dlen);
    input_prepare(s.b2, s.b, s.blen);
    result = jade_scalarmult_base(s.d, s.b);
    if (result != 0) fail("jade_scalarmult_base returns nonzero");
    checksum(checksum_state, s.d, s.dlen);
    output_compare(s.d2, s.d, s.dlen, "jade_scalarmult_base");
    input_compare(s.b2, s.b, s.blen, "jade_scalarmult_base");
    
    double_canary(s.d2, s.d, s.dlen);
    double_canary(s.b2, s.b, s.blen);
    result = jade_scalarmult_base(s.d2, s.b2);
    if (result != 0) fail("jade_scalarmult_base returns nonzero");
    if (memcmp(s.d2, s.d, s.dlen) != 0) fail("jade_scalarmult_base is nondeterministic");
    
    double_canary(s.d2, s.d, s.dlen);
    double_canary(s.b2, s.b, s.blen);
    result = jade_scalarmult_base(s.b2, s.b2);
    if (result != 0) fail("jade_scalarmult_base with b=d overlap returns nonzero");
    if (memcmp(s.b2, s.d, s.dlen) != 0) fail("jade_scalarmult_base does not handle b=d overlap");
    memcpy(s.b2, s.b, s.blen);
    
    output_prepare(s.e2, s.e, s.elen);
    memcpy(s.a2, s.a, s.alen);
    double_canary(s.a2, s.a, s.alen);
    memcpy(s.d2, s.d, s.dlen);
    double_canary(s.d2, s.d, s.dlen);
    result = jade_scalarmult(s.e, s.a, s.d);
    if (result != 0) fail("jade_scalarmult returns nonzero");
    checksum(checksum_state, s.e, s.elen);
    output_compare(s.e2, s.e, s.elen, "jade_scalarmult");
    input_compare(s.a2, s.a, s.alen, "jade_scalarmult");
    input_compare(s.d2, s.d, s.dlen, "jade_scalarmult");
    
    double_canary(s.e2, s.e, s.elen);
    double_canary(s.a2, s.a, s.alen);
    double_canary(s.d2, s.d, s.dlen);
    result = jade_scalarmult(s.e2, s.a2, s.d2);
    if (result != 0) fail("jade_scalarmult returns nonzero");
    if (memcmp(s.e2, s.e, s.elen) != 0) fail("jade_scalarmult is nondeterministic");
    
    double_canary(s.e2, s.e, s.elen);
    double_canary(s.a2, s.a, s.alen);
    double_canary(s.d2, s.d, s.dlen);
    result = jade_scalarmult(s.a2, s.a2, s.d);
    if (result != 0) fail("jade_scalarmult with a=e overlap returns nonzero");
    if (memcmp(s.a2, s.e, s.elen) != 0) fail("jade_scalarmult does not handle a=e overlap");
    memcpy(s.a2, s.a, s.alen);
    result = jade_scalarmult(s.d2, s.a, s.d2);
    if (result != 0) fail("jade_scalarmult with d=e overlap returns nonzero");
    if (memcmp(s.d2, s.e, s.elen) != 0) fail("jade_scalarmult does not handle d=e overlap");
    memcpy(s.d2, s.d, s.dlen);
    
    output_prepare(s.f2, s.f, s.flen);
    memcpy(s.b2, s.b, s.blen);
    double_canary(s.b2, s.b, s.blen);
    memcpy(s.c2, s.c, s.clen);
    double_canary(s.c2, s.c, s.clen);
    result = jade_scalarmult(s.f, s.b, s.c);
    if (result != 0) fail("jade_scalarmult returns nonzero");
    checksum(checksum_state, s.f, s.flen);
    output_compare(s.f2, s.f, s.flen, "jade_scalarmult");
    input_compare(s.b2, s.b, s.blen, "jade_scalarmult");
    input_compare(s.c2, s.c, s.clen,"jade_scalarmult");
    
    double_canary(s.f2, s.f, s.flen);
    double_canary(s.b2, s.b, s.blen);
    double_canary(s.c2, s.c, s.clen);
    result = jade_scalarmult(s.f2, s.b2, s.c2);
    if (result != 0) fail("jade_scalarmult returns nonzero");
    if (memcmp(s.f2, s.f, s.flen) != 0) fail("jade_scalarmult is nondeterministic");
    
    double_canary(s.f2, s.f, s.flen);
    double_canary(s.b2, s.b, s.blen);
    double_canary(s.c2, s.c, s.clen);
    result = jade_scalarmult(s.b2, s.b2, s.c);
    if (result != 0) fail("jade_scalarmult with b=f overlap returns nonzero");
    if (memcmp(s.b2, s.f, s.flen) != 0) fail("jade_scalarmult does not handle b=f overlap");
    memcpy(s.b2, s.b, s.blen);
    result = jade_scalarmult(s.c2, s.b, s.c2);
    if (result != 0) fail("jade_scalarmult with c=f overlap returns nonzero");
    if (memcmp(s.c2, s.f, s.flen) != 0) fail("jade_scalarmult does not handle c=f overlap");
    memcpy(s.c2, s.c, s.clen);
    
    if (memcmp(s.f, s.e, s.elen) != 0) fail("jade_scalarmult not associative");
  }
}

#include "try-anything.c"

int main(void)
{
  return try_anything_main();
}


