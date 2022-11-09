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
  uint8_t *p;
  uint8_t *s;
  uint8_t *m;
  uint8_t *c;
  uint8_t *t;
  uint8_t *p2;
  uint8_t *s2;
  uint8_t *m2;
  uint8_t *c2;
  uint8_t *t2;
  uint64_t plen;
  uint64_t slen;
  uint64_t mlen;
  uint64_t clen;
  uint64_t tlen;
  void* free[10];
} state;

state* preallocate(void);
void allocate(state*);
void deallocate(state**);
void unalign(state*);
void realign(state*);
void test(unsigned char*,state *);

// ////////////////////////////////////////////////////////////////////////////

#define CRYPTO_PUBLICKEYBYTES NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_SECRETKEYBYTES NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_BYTES NAMESPACE(BYTES)
#define CRYPTO_DETERMINISTIC NAMESPACE(DETERMINISTIC)

#define crypto_sign_keypair NAMESPACE_LC(keypair)
#define crypto_sign JADE_NAMESPACE_LC
#define crypto_sign_open NAMESPACE_LC(open)

// ////////////////////////////////////////////////////////////////////////////

#define TUNE_BYTES 1536

#ifdef SMALL
 #define LOOPS 8
 #define MAXTEST_BYTES 128
#else
 #define LOOPS 64
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
  if (alloclen < MAXTEST_BYTES + CRYPTO_BYTES) alloclen = MAXTEST_BYTES + CRYPTO_BYTES;
  if (alloclen < CRYPTO_PUBLICKEYBYTES) alloclen = CRYPTO_PUBLICKEYBYTES;
  if (alloclen < CRYPTO_SECRETKEYBYTES) alloclen = CRYPTO_SECRETKEYBYTES;

  s->p  = alignedcalloc(&(s->free[0]), alloclen);
  s->s  = alignedcalloc(&(s->free[1]), alloclen);
  s->m  = alignedcalloc(&(s->free[2]), alloclen);
  s->c  = alignedcalloc(&(s->free[3]), alloclen);
  s->t  = alignedcalloc(&(s->free[4]), alloclen);
  s->p2 = alignedcalloc(&(s->free[5]), alloclen);
  s->s2 = alignedcalloc(&(s->free[6]), alloclen);
  s->m2 = alignedcalloc(&(s->free[7]), alloclen);
  s->c2 = alignedcalloc(&(s->free[8]), alloclen);
  s->t2 = alignedcalloc(&(s->free[9]), alloclen);
  s->plen = CRYPTO_PUBLICKEYBYTES;
  s->slen = CRYPTO_SECRETKEYBYTES;
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
  ++(s->p);
  ++(s->s);
  ++(s->m);
  ++(s->c);
  ++(s->t);
  ++(s->p2);
  ++(s->s2);
  ++(s->m2);
  ++(s->c2);
  ++(s->t2);
}

void realign(state *s)
{
  --(s->p);
  --(s->s);
  --(s->m);
  --(s->c);
  --(s->t);
  --(s->p2);
  --(s->s2);
  --(s->m2);
  --(s->c2);
  --(s->t2);
}

void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long loop;
  int result;
  state s = *_s;
  
  for (loop = 0;loop < LOOPS;++loop) {
    s.mlen = myrandom() % (MAXTEST_BYTES + 1);
    
    output_prepare(s.p2, s.p, s.plen);
    output_prepare(s.s2, s.s, s.slen);
    result = crypto_sign_keypair(s.p, s.s);
    if (result != 0) fail("crypto_sign_keypair returns nonzero");
    checksum(checksum_state, s.p, s.plen);
    checksum(checksum_state, s.s, s.slen);
    output_compare(s.p2, s.p, s.plen, "crypto_sign_keypair");
    output_compare(s.s2, s.s, s.slen, "crypto_sign_keypair");
    
    s.clen = s.mlen + CRYPTO_BYTES;
    output_prepare(s.c2, s.c, s.clen);
    input_prepare(s.m2, s.m, s.mlen);
    memcpy(s.s2, s.s, s.slen);
    double_canary(s.s2, s.s, s.slen);
    result = crypto_sign(s.c, &s.clen, s.m, s.mlen, s.s);
    if (result != 0) fail("crypto_sign returns nonzero");
    if (s.clen < s.mlen) fail("crypto_sign returns smaller output than input");
    if (s.clen > s.mlen + CRYPTO_BYTES) fail("crypto_sign returns more than crypto_sign_BYTES extra bytes");
    checksum(checksum_state, s.c, s.clen);
    output_compare(s.c2, s.c, s.clen,"crypto_sign");
    input_compare(s.m2, s.m, s.mlen, "crypto_sign");
    input_compare(s.s2, s.s, s.slen, "crypto_sign");

#if CRYPTO_DETERMINISTIC == 1
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.s2, s.s, s.slen);
    result = crypto_sign(s.c2, &s.clen, s.m2, s.mlen, s.s2);
    if (result != 0) fail("crypto_sign returns nonzero");
    if (memcmp(s.c2, s.c, s.clen) != 0) fail("crypto_sign is nondeterministic");
#endif
    
#if CRYPTO_DETERMINISTIC == 1
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.m2, s.m, s.mlen);
    double_canary(s.s2, s.s, s.slen);
    result = crypto_sign(s.m2, &s.clen, s.m2, s.mlen, s.s);
    if (result != 0) fail("crypto_sign with m=c overlap returns nonzero");
    if (memcmp(s.m2, s.c, s.clen) != 0) fail("crypto_sign does not handle m=c overlap");
    memcpy(s.m2, s.m, s.mlen);
    result = crypto_sign(s.s2, &s.clen, s.m, s.mlen, s.s2);
    if (result != 0) fail("crypto_sign with s=c overlap returns nonzero");
    if (memcmp(s.s2, s.c, s.clen) != 0) fail("crypto_sign does not handle s=c overlap");
    memcpy(s.s2, s.s, s.slen);
#endif
    
    s.tlen = s.clen;
    output_prepare(s.t2, s.t, s.tlen);
    memcpy(s.c2, s.c, s.clen);
    double_canary(s.c2, s.c, s.clen);
    memcpy(s.p2, s.p, s.plen);
    double_canary(s.p2, s.p, s.plen);
    result = crypto_sign_open(s.t, &s.tlen, s.c, s.clen, s.p);
    if (result != 0) fail("crypto_sign_open returns nonzero - 0");
    if (s.tlen != s.mlen) fail("crypto_sign_open does not match mlen");
    if (memcmp(s.t, s.m, s.mlen) != 0) fail("crypto_sign_open does not match m");
    checksum(checksum_state, s.t, s.tlen);
    output_compare(s.t2, s.t, s.clen,"crypto_sign_open");
    input_compare(s.c2, s.c, s.clen,"crypto_sign_open");
    input_compare(s.p2, s.p, s.plen,"crypto_sign_open");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.p2, s.p, s.plen);
    result = crypto_sign_open(s.t2, &s.tlen, s.c2, s.clen, s.p2);
    if (result != 0) fail("crypto_sign_open returns nonzero 1");
    if (memcmp(s.t2, s.t, s.tlen) != 0) fail("crypto_sign_open is nondeterministic");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.p2, s.p, s.plen);
    result = crypto_sign_open(s.c2, &s.tlen, s.c2, s.clen, s.p);
    if (result != 0) fail("crypto_sign_open with c=t overlap returns nonzero");
    if (memcmp(s.c2, s.t, s.tlen) != 0) fail("crypto_sign_open does not handle c=t overlap");
    memcpy(s.c2, s.c, s.clen);
    result = crypto_sign_open(s.p2, &s.tlen, s.c, s.clen, s.p2);
    if (result != 0) fail("crypto_sign_open with p=t overlap returns nonzero");
    if (memcmp(s.p2, s.t, s.tlen) != 0) fail("crypto_sign_open does not handle p=t overlap");
    memcpy(s.p2, s.p, s.plen);
    
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (crypto_sign_open(s.t, &s.tlen, s.c, s.clen, s.p) == 0)
      if ((s.tlen != s.mlen) || (memcmp(s.t, s.m, s.mlen) != 0))
        fail("crypto_sign_open allows trivial forgeries");
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (crypto_sign_open(s.t, &s.tlen, s.c, s.clen, s.p) == 0)
      if ((s.tlen != s.mlen) || (memcmp(s.t, s.m, s.mlen) != 0))
        fail("crypto_sign_open allows trivial forgeries");
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (crypto_sign_open(s.t, &s.tlen, s.c, s.clen, s.p) == 0)
      if ((s.tlen != s.mlen) || (memcmp(s.t, s.m, s.mlen) != 0))
        fail("crypto_sign_open allows trivial forgeries");
  }
}

#include "try-anything.c"

int main()
{
  return try_anything_main();
}

