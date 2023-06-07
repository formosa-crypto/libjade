/*
 * Adapted from SUPERCOP.
 * Public domain.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "try-anything.h"
#include "randombytes.h"

#include "api.h"
#include "jade_kem.h"

// ////////////////////////////////////////////////////////////////////////////

typedef struct state {

  // rand
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

  // derand
  uint8_t *_p;
  uint8_t *_s;
  uint8_t *_k;
  uint8_t *_c;
  uint8_t *_t;
  uint8_t *_p2;
  uint8_t *_s2;
  uint8_t *_k2;
  uint8_t *_c2;
  uint8_t *_t2;

  uint8_t *_kc; // keypair coins
  uint8_t *_ec; // enc coins
  uint8_t *_kc2;
  uint8_t *_ec2;

  uint64_t plen;
  uint64_t slen;
  uint64_t klen;
  uint64_t clen;
  uint64_t tlen;
  uint64_t kclen;
  uint64_t eclen;

  void* free[24];
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

  if (alloclen < JADE_KEM_SECRETKEYBYTES) alloclen = JADE_KEM_SECRETKEYBYTES;
  if (alloclen < JADE_KEM_PUBLICKEYBYTES) alloclen = JADE_KEM_PUBLICKEYBYTES;
  if (alloclen < JADE_KEM_CIPHERTEXTBYTES) alloclen = JADE_KEM_CIPHERTEXTBYTES;
  if (alloclen < JADE_KEM_KEYPAIRCOINBYTES) alloclen = JADE_KEM_KEYPAIRCOINBYTES;
  if (alloclen < JADE_KEM_ENCCOINBYTES) alloclen = JADE_KEM_ENCCOINBYTES;
  if (alloclen < JADE_KEM_BYTES) alloclen = JADE_KEM_BYTES;

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

  s->_p  = alignedcalloc(&(s->free[10]), alloclen);
  s->_s  = alignedcalloc(&(s->free[11]), alloclen);
  s->_k  = alignedcalloc(&(s->free[12]), alloclen);
  s->_c  = alignedcalloc(&(s->free[13]), alloclen);
  s->_t  = alignedcalloc(&(s->free[14]), alloclen);
  s->_p2 = alignedcalloc(&(s->free[15]), alloclen);
  s->_s2 = alignedcalloc(&(s->free[16]), alloclen);
  s->_k2 = alignedcalloc(&(s->free[17]), alloclen);
  s->_c2 = alignedcalloc(&(s->free[18]), alloclen);
  s->_t2 = alignedcalloc(&(s->free[19]), alloclen);

  s->_kc  = alignedcalloc(&(s->free[20]), alloclen);
  s->_ec  = alignedcalloc(&(s->free[21]), alloclen);
  s->_kc2 = alignedcalloc(&(s->free[22]), alloclen);
  s->_ec2 = alignedcalloc(&(s->free[23]), alloclen);

  s->plen  = JADE_KEM_PUBLICKEYBYTES;
  s->slen  = JADE_KEM_SECRETKEYBYTES;
  s->klen  = JADE_KEM_BYTES;
  s->clen  = JADE_KEM_CIPHERTEXTBYTES;
  s->tlen  = JADE_KEM_BYTES;
  s->kclen = JADE_KEM_KEYPAIRCOINBYTES;
  s->eclen = JADE_KEM_ENCCOINBYTES;
}

void deallocate(state **_s)
{
  int i;
  state *s = *_s;

  for(i=0; i<24; i++)
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

  ++(s->_p);
  ++(s->_s);
  ++(s->_k);
  ++(s->_c);
  ++(s->_t);
  ++(s->_p2);
  ++(s->_s2);
  ++(s->_k2);
  ++(s->_c2);
  ++(s->_t2);

  ++(s->_kc);
  ++(s->_ec);
  ++(s->_kc2);
  ++(s->_ec2);
}

void realign(state *s)
{
  --(s->p);
  --(s->s);
  --(s->k);
  --(s->c);
  --(s->t);
  --(s->p2);
  --(s->s2);
  --(s->k2);
  --(s->c2);
  --(s->t2);

  --(s->_p);
  --(s->_s);
  --(s->_k);
  --(s->_c);
  --(s->_t);
  --(s->_p2);
  --(s->_s2);
  --(s->_k2);
  --(s->_c2);
  --(s->_t2);

  --(s->_kc);
  --(s->_ec);
  --(s->_kc2);
  --(s->_ec2);
}

void test(unsigned char *checksum_state, state *_s)
{
  unsigned long long loop;
  int result;
  state s = *_s;
  
  for (loop = 0;loop < LOOPS;++loop)
  {
  //////////////////////////////////
  // rand keypair
    output_prepare(s.p2, s.p, s.plen);
    output_prepare(s.s2, s.s, s.slen);
    result = jade_kem_keypair(s.p, s.s);
    if (result != 0) fail("jade_kem_keypair returns nonzero");
    checksum(checksum_state, s.p, s.plen);
    checksum(checksum_state, s.s, s.slen);
    output_compare(s.p2, s.p, s.plen, "jade_kem_keypair - public_key");
    output_compare(s.s2, s.s, s.slen, "jade_kem_keypair - secret_key");

      // derand keypair
        output_prepare(s._p2, s._p, s.plen);
        output_prepare(s._s2, s._s, s.slen);
        randombytes1(s._kc, s.kclen);
        memcpy(s._kc2, s._kc, s.kclen);
        double_canary(s._kc2, s._kc, s.kclen);
        result = jade_kem_keypair_derand(s._p, s._s, s._kc);
        if (result != 0) fail("jade_kem_keypair_derand returns nonzero");

        // check canaries
        output_compare(s._p2, s._p, s.plen,   "jade_kem_keypair_derand - public_key");
        output_compare(s._s2, s._s, s.slen,   "jade_kem_keypair_derand - secret_key");
        input_compare(s._kc2, s._kc, s.kclen, "jade_kem_keypair_derand - coins");

        // check that 'rand' and 'derand' produce the same keys (randomness is the same for both)
        if (memcmp(s.p, s._p, s.plen) != 0)
        { fail("jade_kem_keypair public_key does not match the one from jade_kem_keypair_derand"); }
        if (memcmp(s.s, s._s, s.slen) != 0)
        { fail("jade_kem_keypair secret_key does not match the one from jade_kem_keypair_derand"); }

  //////////////////////////////////
  // rand enc
    output_prepare(s.c2, s.c, s.clen);
    output_prepare(s.k2, s.k, s.klen);
    memcpy(s.p2, s.p, s.plen);
    double_canary(s.p2, s.p, s.plen);
    result = jade_kem_enc(s.c, s.k, s.p);
    if (result != 0) fail("jade_kem_enc returns nonzero");
    checksum(checksum_state, s.c, s.clen);
    checksum(checksum_state, s.k, s.klen);
    output_compare(s.c2, s.c, s.clen, "jade_kem_enc - ciphertext");
    output_compare(s.k2, s.k, s.klen, "jade_kem_enc - shared_secret");
    input_compare(s.p2, s.p, s.plen,  "jade_kem_enc - public_key");

      // derand enc
        output_prepare(s._c2, s._c, s.clen);
        output_prepare(s._k2, s._k, s.klen);
        memcpy(s._p2, s._p, s.plen);
        double_canary(s._p2, s._p, s.plen);
        randombytes1(s._ec, s.eclen);
        memcpy(s._ec2, s._ec, s.eclen);
        double_canary(s._ec2, s._ec, s.eclen);

        result = jade_kem_enc_derand(s._c, s._k, s._p, s._ec);
        if (result != 0) fail("jade_kem_enc_derand returns nonzero");

        // check canaries
        output_compare(s._c2, s._c, s.clen,   "jade_kem_enc_derand - ciphertext");
        output_compare(s._k2, s._k, s.klen,   "jade_kem_enc_derand - shared_secret");
        input_compare(s._p2, s._p, s.plen,    "jade_kem_enc_derand - public_key");
        input_compare(s._ec2, s._ec, s.eclen, "jade_kem_enc_derand - coins");

        // check that 'rand' and 'derand' produce the same ciphertext and shared_secret
        if (memcmp(s.c, s._c, s.clen) != 0)
        { fail("jade_kem_enc ciphertext does not match the one from jade_kem_enc_derand"); }
        if (memcmp(s.k, s._k, s.klen) != 0)
        { fail("jade_kem_enc shared_secret does not match the one from jade_kem_enc_derand"); }

  // dec
    output_prepare(s.t2, s.t, s.tlen);
    memcpy(s.c2, s.c, s.clen);
    double_canary(s.c2, s.c, s.clen);
    memcpy(s.s2, s.s, s.slen);
    double_canary(s.s2, s.s, s.slen);
    result = jade_kem_dec(s.t, s.c, s.s);
    if (result != 0) fail("jade_kem_dec returns nonzero");
    if (memcmp(s.t, s.k, s.klen) != 0) fail("jade_kem_dec does not match k");
    checksum(checksum_state, s.t, s.tlen);
    output_compare(s.t2, s.t, s.tlen, "jade_kem_dec");
    input_compare(s.c2, s.c, s.clen, "jade_kem_dec");
    input_compare(s.s2, s.s, s.slen, "jade_kem_dec");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.s2, s.s, s.slen);
    result = jade_kem_dec(s.t2, s.c2, s.s2);
    if (result != 0) fail("jade_kem_dec returns nonzero");
    if (memcmp(s.t2, s.t, s.tlen) != 0) fail("jade_kem_dec is nondeterministic");
    
    double_canary(s.t2, s.t, s.tlen);
    double_canary(s.c2, s.c, s.clen);
    double_canary(s.s2, s.s, s.slen);
    result = jade_kem_dec(s.c2, s.c2, s.s);
    if (result != 0) fail("jade_kem_dec with c=t overlap returns nonzero");
    if (memcmp(s.c2, s.t, s.tlen) != 0) fail("jade_kem_dec does not handle c=t overlap");
    memcpy(s.c2, s.c, s.clen);
    result = jade_kem_dec(s.s2, s.c, s.s2);
    if (result != 0) fail("jade_kem_dec with s=t overlap returns nonzero");
    if (memcmp(s.s2, s.t, s.tlen) != 0) fail("jade_kem_dec does not handle s=t overlap");
    memcpy(s.s2, s.s, s.slen);
    
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (jade_kem_dec(s.t, s.c, s.s) == 0)
      checksum(checksum_state, s.t, s.tlen);
    else
      checksum(checksum_state, s.c, s.clen);
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (jade_kem_dec(s.t, s.c, s.s) == 0)
      checksum(checksum_state, s.t, s.tlen);
    else
      checksum(checksum_state, s.c, s.clen);
    s.c[myrandom() % s.clen] += 1 + (myrandom() % 255);
    if (jade_kem_dec(s.t, s.c, s.s) == 0)
      checksum(checksum_state, s.t, s.tlen);
    else
      checksum(checksum_state, s.c, s.clen);
  }
}

#include "try-anything.c"

int main(void)
{
  return try_anything_main();
}


