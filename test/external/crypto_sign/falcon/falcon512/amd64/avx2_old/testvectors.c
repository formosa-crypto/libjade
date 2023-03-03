
/* Deterministic randombytes by Daniel J. Bernstein */
/* taken from SUPERCOP (https://bench.cr.yp.to)     */

#if 0
#include "api.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "randombytes.h"

#define MAXMLEN 1000

#define ITERATIONS 30

// #define BUFF_SIZE 57289

// unsigned char buff[BUFF_SIZE];

unsigned long long randomness;

static void printbytes(const unsigned char *x, unsigned long long xlen)
{
  char outs[2*xlen+1];
  unsigned long long i;
  for(i=0;i<xlen;i++)
    sprintf(outs+2*i, "%02x", x[i]);
  outs[2*xlen] = 0;
  printf("%s\n", outs);
}

int main(void)
{
  unsigned char sk[JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_SECRETKEYBYTES];
  unsigned char pk[JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_PUBLICKEYBYTES];
  unsigned char pk2[JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_PUBLICKEYBYTES];

  unsigned char mi[MAXMLEN];
  unsigned char sm[MAXMLEN+JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_BYTES];
  size_t smlen;
  size_t mlen;

  int r;
  size_t i,j;
  size_t crypto_i;

  randomness = 0;

  for(crypto_i = 0; crypto_i < ITERATIONS; crypto_i++){


  for(i=0; i<MAXMLEN; i=(i==0)?i+1:i<<1)
  {

    // crypto_i = 22, i = 512;
    // randombytes(buff, BUFF_SIZE);

    // Accumulative randomness: 57289
    // printf("crypto_i = %zu, i = %zu\n", crypto_i, i);
    printf("Accumulative randomness: %llu\n", randomness);

    randombytes(mi,i);

    jade_sign_falcon_falcon512_amd64_ref_keypair(pk2, sk);
    jade_sign_falcon_falcon512_amd64_ref_keypair(pk, sk);

    printf("public key\n");
    printbytes(pk,JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_PUBLICKEYBYTES);
    printf("secret key\n");
    printbytes(sk,JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_SECRETKEYBYTES);

    jade_sign_falcon_falcon512_amd64_ref(sm, &smlen, mi, i, sk);

    printf("signature\n");
    printbytes(sm, smlen);

    // // By relying on m == sm we prevent having to allocate CRYPTO_BYTES twice
    r = jade_sign_falcon_falcon512_amd64_avx2_open(sm, &mlen, sm, smlen, pk);

    if(r)
    {
      printf("ERROR: signature verification failed\n");
      return -1;
    }
    for(j=0;j<i;j++)
    {
      if(sm[j]!=mi[j])
      {
        printf("ERROR: message recovery failed\n");
        return -1;
      }
    }
    printf("message recovery success\n");

    r = jade_sign_falcon_falcon512_amd64_avx2_open(sm, &mlen, sm, smlen, pk2);

    if(!r){
      printf("ERROR: invalid pk verification failed\n");
      return -1;
    }
    for(j=0;j<i;j++)
    {
      if(sm[j]!=mi[j])
      {
        printf("ERROR: message wrongly overwritten\n");
        return -1;
      }
    }
    printf("invalid pk verification success\n");

    sm[100] = ~sm[100];

    r = jade_sign_falcon_falcon512_amd64_avx2_open(sm, &mlen, sm, smlen, pk);

    if(!r){
      printf("ERROR: invalid message verification failed\n");
      return -1;
    }
    printf("invalid message verification success\n");



  }

  }

  return 0;
}

#endif

