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
  uint8_t *k;
  uint8_t *c;
  uint8_t *t;
  uint8_t *p2;
  uint8_t *s2;
  uint8_t *k2;
  uint8_t *c2;
  uint8_t *t2;
  uint64_t plen;
  uint64_t slen;
  uint64_t klen;
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

#define CRYPTO_SECRETKEYBYTES NAMESPACE(SECRETKEYBYTES)
#define CRYPTO_PUBLICKEYBYTES NAMESPACE(PUBLICKEYBYTES)
#define CRYPTO_CIPHERTEXTBYTES NAMESPACE(CIPHERTEXTBYTES) 
#define CRYPTO_BYTES NAMESPACE(BYTES)

#define crypto_kem_keypair NAMESPACE_LC(keypair)
#define crypto_kem_enc NAMESPACE_LC(enc)
#define crypto_kem_dec NAMESPACE_LC(dec)


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
  unsigned long long alloclen = 0;
  if (alloclen < TUNE_BYTES) alloclen = TUNE_BYTES;
  if (alloclen < MAXTEST_BYTES) alloclen = MAXTEST_BYTES;
  if (alloclen < CRYPTO_PUBLICKEYBYTES) alloclen = CRYPTO_PUBLICKEYBYTES;
  if (alloclen < CRYPTO_SECRETKEYBYTES) alloclen = CRYPTO_SECRETKEYBYTES;
  if (alloclen < CRYPTO_BYTES) alloclen = CRYPTO_BYTES;
  if (alloclen < CRYPTO_CIPHERTEXTBYTES) alloclen = CRYPTO_CIPHERTEXTBYTES;
  s->p  = alignedcalloc(&(s->free[0]), alloclen);
  s->s  = alignedcalloc(&(s->free[1]), alloclen);
  s->k  = alignedcalloc(&(s->free[2]), alloclen);
  s->c  = alignedcalloc(&(s->free[3]), alloclen);
  s->t  = alignedcalloc(&(s->free[4]), alloclen);
  s->p2 = alignedcalloc(&(s->free[5]), alloclen);
  s->s2 = alignedcalloc(&(s->free[6]), alloclen);
  s->k2 = alignedcalloc(&(s->free[7]), alloclen);
  s->c2 = alignedcalloc(&(s->free[8]), alloclen);
  s->t2 = alignedcalloc(&(s->free[9]), alloclen);
  s->plen = CRYPTO_PUBLICKEYBYTES;
  s->slen = CRYPTO_SECRETKEYBYTES;
  s->klen = CRYPTO_BYTES;
  s->clen = CRYPTO_CIPHERTEXTBYTES;
  s->tlen = CRYPTO_BYTES;
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
  ++(s->k);
  ++(s->c);
  ++(s->t);
  ++(s->p2);
  ++(s->s2);
  ++(s->k2);
  ++(s->c2);
  ++(s->t2);
}

void realign(state *s)
{
  ++(s->p);
  ++(s->s);
  ++(s->k);
  ++(s->c);
  ++(s->t);
  ++(s->p2);
  ++(s->s2);
  ++(s->k2);
  ++(s->c2);
  ++(s->t2);
}

void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long loop;
  int result;
  state s = *_s;
  
  for (loop = 0;loop < LOOPS;++loop) {

    output_prepare(s.p2, s.p, s.plen);
    output_prepare(s.s2, s.s, s.slen);
    result = crypto_kem_keypair(s.p, s.s);
    if (result != 0) fail("crypto_kem_keypair returns nonzero");
    checksum(checksum_state, s.p, s.plen);
    checksum(checksum_state, s.s, s.slen);
    output_compare(s.p2, s.p, s.plen, "crypto_kem_keypair");
    output_compare(s.s2, s.s, s.slen, "crypto_kem_keypair");
    
    output_prepare(s.c2, s.c, s.clen);
    output_prepare(s.k2, s.k, s.klen);
    memcpy(s.p2, s.p, s.plen);
    double_canary(s.p2, s.p, s.plen);
    result = crypto_kem_enc(s.c, s.k, s.p);
    if (result != 0) fail("crypto_kem_enc returns nonzero");
    checksum(checksum_state, s.c, s.clen);
    checksum(checksum_state, s.k, s.klen);
    output_compare(s.c2, s.c, s.clen, "crypto_kem_enc");
    output_compare(s.k2, s.k, s.klen, "crypto_kem_enc");
    input_compare(s.p2, s.p, s.plen, "crypto_kem_enc");
    
    output_prepare(s.t2, s.t, s.tlen);
    memcpy(s.c2, s.c, s.clen);
    double_canary(s.c2, s.c, s.clen);
    memcpy(s.s2, s.s, s.slen);
    double_canary(s.s2, s.s, s.slen);
    result = crypto_kem_dec(s.t, s.c, s.s);
    if (result != 0) fail("crypto_kem_dec returns nonzero");
    if (memcmp(s.t, s.k, s.klen) != 0) fail("crypto_kem_dec does not match k");
    checksum(checksum_state, s.t, s.tlen);
    output_compare(s.t2, s.t, s.tlen, "crypto_kem_dec");
    input_compare(s.c2, s.c, s.clen, "crypto_kem_dec");
    input_compare(s.s2, s.s, s.slen, "crypto_kem_dec");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.s2, s.s, s.slen);
    result = crypto_kem_dec(s.t2, s.c2, s.s2);
    if (result != 0) fail("crypto_kem_dec returns nonzero");
    if (memcmp(s.t2, s.t, s.tlen) != 0) fail("crypto_kem_dec is nondeterministic");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.s2, s.s, s.slen);
    result = crypto_kem_dec(s.c2, s.c2, s.s);
    if (result != 0) fail("crypto_kem_dec with c=t overlap returns nonzero");
    if (memcmp(s.c2, s.t, s.tlen) != 0) fail("crypto_kem_dec does not handle c=t overlap");
    memcpy(s.c2, s.c, s.clen);
    result = crypto_kem_dec(s.s2, s.c, s.s2);
    if (result != 0) fail("crypto_kem_dec with s=t overlap returns nonzero");
    if (memcmp(s.s2, s.t, s.tlen) != 0) fail("crypto_kem_dec does not handle s=t overlap");
    memcpy(s.s2, s.s, s.slen);
    
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (crypto_kem_dec(s.t, s.c, s.s) == 0)
      checksum(checksum_state, s.t, s.tlen);
    else
      checksum(checksum_state, s.c, s.clen);
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (crypto_kem_dec(s.t, s.c, s.s) == 0)
      checksum(checksum_state, s.t, s.tlen);
    else
      checksum(checksum_state, s.c, s.clen);
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (crypto_kem_dec(s.t, s.c, s.s) == 0)
      checksum(checksum_state, s.t, s.tlen);
    else
      checksum(checksum_state, s.c, s.clen);
  }
}

#include "try-anything.c"

int main()
{
  return try_anything_main();
}


