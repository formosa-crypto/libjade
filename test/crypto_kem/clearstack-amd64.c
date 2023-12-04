#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_kem.h"
#include "print.h"

// kem_keypair
#define jade_kem_keypair_STACK_MAX_SIZE NAMESPACE_LC(keypair_STACK_MAX_SIZE)
#define jade_kem_keypair_STACK_ALIGNMENT NAMESPACE_LC(keypair_STACK_ALIGNMENT)

// kem_keypair_derand
#define jade_kem_keypair_derand_STACK_MAX_SIZE NAMESPACE_LC(keypair_derand_STACK_MAX_SIZE)
#define jade_kem_keypair_derand_STACK_ALIGNMENT NAMESPACE_LC(keypair_derand_STACK_ALIGNMENT)

// kem_enc
#define jade_kem_enc_STACK_MAX_SIZE NAMESPACE_LC(enc_STACK_MAX_SIZE)
#define jade_kem_enc_STACK_ALIGNMENT NAMESPACE_LC(enc_STACK_ALIGNMENT)

// kem_enc_derand
#define jade_kem_enc_derand_STACK_MAX_SIZE NAMESPACE_LC(enc_derand_STACK_MAX_SIZE)
#define jade_kem_enc_derand_STACK_ALIGNMENT NAMESPACE_LC(enc_derand_STACK_ALIGNMENT)

// kem_dec
#define jade_kem_dec_STACK_MAX_SIZE NAMESPACE_LC(dec_STACK_MAX_SIZE)
#define jade_kem_dec_STACK_ALIGNMENT NAMESPACE_LC(dec_STACK_ALIGNMENT)

// kem_keypair
#ifndef jade_kem_keypair_STACK_MAX_SIZE
#error "jade_kem_keypair_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_kem_keypair_STACK_ALIGNMENT
#error "jade_kem_keypair_STACK_ALIGNMENT is not defined."
#endif

// kem_keypair_derand
#ifndef jade_kem_keypair_derand_STACK_MAX_SIZE
#error "jade_kem_keypair_derand_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_kem_keypair_derand_STACK_ALIGNMENT
#error "jade_kem_keypair_derand_STACK_ALIGNMENT is not defined."
#endif

// kem_enc
#ifndef jade_kem_enc_STACK_MAX_SIZE
#error "jade_kem_enc_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_kem_enc_STACK_ALIGNMENT
#error "jade_kem_enc_STACK_ALIGNMENT is not defined."
#endif

// kem_enc_derand
#ifndef jade_kem_enc_derand_STACK_MAX_SIZE
#error "jade_kem_enc_derand_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_kem_enc_derand_STACK_ALIGNMENT
#error "jade_kem_enc_derand_STACK_ALIGNMENT is not defined."
#endif

// kem_dec
#ifndef jade_kem_dec_STACK_MAX_SIZE
#error "jade_kem_dec_STACK_MAX_SIZE is not defined."
#endif

#ifndef jade_kem_dec_STACK_ALIGNMENT
#error "jade_kem_dec_STACK_ALIGNMENT is not defined."
#endif

#include "clearstack-amd64.h"

#ifndef TESTS
#define TESTS 10
#endif

int main(void)
{
  int r;

  //
  uint8_t public_key[JADE_KEM_PUBLICKEYBYTES];
  uint8_t secret_key[JADE_KEM_SECRETKEYBYTES];
  uint8_t shared_secret_a[JADE_KEM_BYTES];
  uint8_t ciphertext[JADE_KEM_CIPHERTEXTBYTES];
  uint8_t shared_secret_b[JADE_KEM_BYTES];

  // arrays for the derand trace
  uint8_t keypair_coins[JADE_KEM_KEYPAIRCOINBYTES];
  uint8_t enc_coins[JADE_KEM_ENCCOINBYTES];
  uint8_t public_key_derand[JADE_KEM_PUBLICKEYBYTES];
  uint8_t secret_key_derand[JADE_KEM_SECRETKEYBYTES];
  uint8_t shared_secret_a_derand[JADE_KEM_BYTES];
  uint8_t ciphertext_derand[JADE_KEM_CIPHERTEXTBYTES];
  uint8_t shared_secret_b_derand[JADE_KEM_BYTES];

    cs_init_randombytes_for_canary(1);

    cs_declare(rsp0, ca0, ra0, jade_kem_keypair_STACK_MAX_SIZE);
    cs_declare(rsp1, ca1, ra1, jade_kem_keypair_derand_STACK_MAX_SIZE);
    cs_declare(rsp2, ca2, ra2, jade_kem_enc_STACK_MAX_SIZE);
    cs_declare(rsp3, ca3, ra3, jade_kem_enc_derand_STACK_MAX_SIZE);
    cs_declare(rsp4, ca4, ra4, jade_kem_dec_STACK_MAX_SIZE);

  for(size_t tests=0; tests < TESTS; tests++)
  {
    // coins for derand API
    randombytes1(keypair_coins, JADE_KEM_KEYPAIRCOINBYTES);
    randombytes1(enc_coins, JADE_KEM_ENCCOINBYTES);

    // key pair
      cs_init(rsp0, jade_kem_keypair_STACK_MAX_SIZE, jade_kem_keypair_STACK_ALIGNMENT, ca0)
    r = jade_kem_keypair(public_key, secret_key);
      cs_recover_and_check(rsp0, ra0, ca0, jade_kem_keypair_STACK_MAX_SIZE)
      assert(r == 0);

    // encapsulate
      cs_init(rsp2, jade_kem_enc_STACK_MAX_SIZE, jade_kem_enc_STACK_ALIGNMENT, ca2)
    r = jade_kem_enc(ciphertext, shared_secret_a, public_key);
      cs_recover_and_check(rsp2, ra2, ca2, jade_kem_enc_STACK_MAX_SIZE)
      assert(r == 0);

    // decapsulate
      cs_init(rsp4, jade_kem_dec_STACK_MAX_SIZE, jade_kem_dec_STACK_ALIGNMENT, ca4)
    r = jade_kem_dec(shared_secret_b, ciphertext, secret_key);
      cs_recover_and_check(rsp4, ra4, ca4, jade_kem_dec_STACK_MAX_SIZE)
      assert(r == 0);
      assert(memcmp(shared_secret_a, shared_secret_b, JADE_KEM_BYTES) == 0);

    // /////////////////////////////////////////////////////////////////////////

    // key pair derand
      cs_init(rsp1, jade_kem_keypair_derand_STACK_MAX_SIZE, jade_kem_keypair_derand_STACK_ALIGNMENT, ca1)
    r = jade_kem_keypair_derand(public_key_derand, secret_key_derand, keypair_coins);
      cs_recover_and_check(rsp1, ra1, ca1, jade_kem_keypair_derand_STACK_MAX_SIZE)
      assert(r == 0);

    // assert that the same key pair was generated (same coins: randombytes ~ randombytes1)
    assert(memcmp(public_key_derand, public_key, JADE_KEM_PUBLICKEYBYTES) == 0);
    assert(memcmp(secret_key_derand, secret_key, JADE_KEM_SECRETKEYBYTES) == 0);


    // encapsulate derand
      cs_init(rsp3, jade_kem_enc_derand_STACK_MAX_SIZE, jade_kem_enc_derand_STACK_ALIGNMENT, ca3)
    r = jade_kem_enc_derand(ciphertext_derand, shared_secret_a_derand, public_key_derand, enc_coins);
      cs_recover_and_check(rsp3, ra3, ca3, jade_kem_enc_derand_STACK_MAX_SIZE)
      assert(r == 0);

    // assert that same ciphertext and shared secret was generated
    assert(memcmp(ciphertext_derand, ciphertext, JADE_KEM_CIPHERTEXTBYTES) == 0);
    assert(memcmp(shared_secret_a_derand, shared_secret_a, JADE_KEM_BYTES) == 0);

    // decapsulate
      cs_init(rsp4, jade_kem_dec_STACK_MAX_SIZE, jade_kem_dec_STACK_ALIGNMENT, ca4)
    r = jade_kem_dec(shared_secret_b_derand, ciphertext_derand, secret_key_derand);
      cs_recover_and_check(rsp4, ra4, ca4, jade_kem_dec_STACK_MAX_SIZE)
      assert(r == 0);
      assert(memcmp(shared_secret_b_derand, shared_secret_a, JADE_KEM_BYTES) == 0);
  }


  print_info(JADE_KEM_ALGNAME, JADE_KEM_ARCH, JADE_KEM_IMPL);

  printf("jade_kem_keypair_STACK_MAX_SIZE: %d\n",         jade_kem_keypair_STACK_MAX_SIZE);
  printf("jade_kem_keypair_STACK_ALIGNMENT: %d\n",        jade_kem_keypair_STACK_ALIGNMENT);
  printf("jade_kem_keypair_derand_STACK_MAX_SIZE: %d\n",  jade_kem_keypair_derand_STACK_MAX_SIZE);
  printf("jade_kem_keypair_derand_STACK_ALIGNMENT: %d\n", jade_kem_keypair_derand_STACK_ALIGNMENT);
  printf("jade_kem_enc_STACK_MAX_SIZE: %d\n",             jade_kem_enc_STACK_MAX_SIZE);
  printf("jade_kem_enc_STACK_ALIGNMENT: %d\n",            jade_kem_enc_STACK_ALIGNMENT);
  printf("jade_kem_enc_derand_STACK_MAX_SIZE: %d\n",      jade_kem_enc_derand_STACK_MAX_SIZE);
  printf("jade_kem_enc_derand_STACK_ALIGNMENT: %d\n",     jade_kem_enc_derand_STACK_ALIGNMENT);
  printf("jade_kem_dec_STACK_MAX_SIZE: %d\n",             jade_kem_dec_STACK_MAX_SIZE);
  printf("jade_kem_dec_STACK_ALIGNMENT: %d\n",            jade_kem_dec_STACK_ALIGNMENT);


  return 0;
}

