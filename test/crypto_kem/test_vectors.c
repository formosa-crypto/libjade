#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

#include "randombytes.h"
#include "api.h"

#include "jade_kem.h"
#include "print.h"

// include path should be set accordingly to the injected test by the Makefile
#include "keypair_tests.c"
#include "enc_tests.c"
#include "dec_tests.c"

// VERBOSE 1 prints failing tests -- and aborts at the end with an assert 0
// VERBOSE 2 prints failing and non-failing tests -- and aborts at the end with an assert 0
 
#ifndef VERBOSE
#define VERBOSE 2
#endif

int main(void)
{
  size_t test;
  int status = 1;

  // ///////////////////////////////////////////////////////////////////////////
  // check keypair
  char    *keypair_comment;
  uint8_t *keypair_coins; // with JADE_KEM_KEYPAIRCOINBYTES
  uint8_t *keypair_expected_public_key; // with JADE_KEM_PUBLICKEYBYTES
  uint8_t *keypair_expected_secret_key; // with JADE_KEM_SECRETKEYBYTES

  int keypair_computed_return;
  uint8_t  keypair_computed_public_key[JADE_KEM_PUBLICKEYBYTES];
  uint8_t  keypair_computed_secret_key[JADE_KEM_SECRETKEYBYTES];

  for(test = 0; test < test_keypair_number_of_tests; test++)
  {
    keypair_comment = test_keypair_comment[test];
    keypair_coins = test_keypair_coins[test];
    keypair_expected_public_key = test_keypair_expected_public_key[test];
    keypair_expected_secret_key = test_keypair_expected_secret_key[test];

    keypair_computed_return = jade_kem_keypair_derand(keypair_computed_public_key, keypair_computed_secret_key, keypair_coins);

    int ok_return = (keypair_computed_return == 0);
    int ok_public_key = memcmp(keypair_expected_public_key, keypair_computed_public_key, JADE_KEM_PUBLICKEYBYTES) == 0;
    int ok_secret_key = memcmp(keypair_expected_secret_key, keypair_computed_secret_key, JADE_KEM_SECRETKEYBYTES) == 0;
    int ok_all = (ok_return == 1) && (ok_public_key == 1) && (ok_secret_key == 1);

    if(ok_all == 0) { status = 0; }

    if( (VERBOSE == 1 && ok_all == 0) || (VERBOSE == 2) )
    {
      printf("%04zu: status : %s\n", test, (ok_all == 1) ? "PASS" : "FAIL" );
      printf("%04zu: keypair_comment : %s\n", test, keypair_comment);
      printf("%04zu: keypair_computer_return == 0 : %d\n", test, keypair_computed_return);
      printf("%04zu: keypair_expected_public_key == keypair_computed_public_key : %d\n", test, ok_public_key);
      printf("%04zu: keypair_expected_secret_key == keypair_computed_secret_key : %d\n\n", test, ok_secret_key);
    }

    if( VERBOSE == 0 )
    { assert(ok_return == 1);
      assert(ok_public_key == 1);
      assert(ok_secret_key == 1);
    }
  }


  // ///////////////////////////////////////////////////////////////////////////
  // check enc

  char    *enc_comment;
  uint8_t *enc_coins; // with JADE_KEM_ENCCOINBYTES
  uint8_t *enc_public_key; // with JADE_KEM_PUBLICKEYBYTES
  int      enc_expected_result;
  uint8_t *enc_expected_ciphertext; // with JADE_KEM_CIPHERTEXTBYTES
  uint8_t *enc_expected_shared_secret; // with JADE_KEM_BYTES

  int enc_computed_return;
  uint8_t  enc_computed_ciphertext[JADE_KEM_CIPHERTEXTBYTES];
  uint8_t  enc_computed_shared_secret[JADE_KEM_BYTES];

  for(test = 0; test < test_enc_number_of_tests; test++)
  {
    enc_comment = test_enc_comment[test];
    enc_coins =  test_enc_coins[test];
    enc_public_key = test_enc_public_key[test];
    enc_expected_result = test_enc_expected_result[test][0];
    enc_expected_ciphertext = test_enc_expected_ciphertext[test];
    enc_expected_shared_secret= test_enc_expected_shared_secret[test];

    // NOTE: ignoring the following tests
    if(!( strcmp("comment = Public key is too long",  enc_comment) == 0 ||
          strcmp("comment = Public key is too short", enc_comment) == 0 ||
          strcmp("comment = Public key not reduced",  enc_comment) == 0 ))
    {

      enc_computed_return = jade_kem_enc_derand(enc_computed_ciphertext, enc_computed_shared_secret, enc_public_key, enc_coins);

      int ok_return = (enc_computed_return == enc_expected_result);
      int ok_ciphertext = memcmp(enc_expected_ciphertext, enc_computed_ciphertext, JADE_KEM_CIPHERTEXTBYTES) == 0;
      int ok_shared_secret = memcmp(enc_expected_shared_secret, enc_computed_shared_secret, JADE_KEM_BYTES) == 0;
      int ok_all = (ok_return == 1) && (ok_ciphertext == 1) && (ok_shared_secret == 1);

      if(ok_all == 0) { status = 0; }

      if( (VERBOSE == 1 && ok_all == 0) || (VERBOSE == 2) )
      {
        printf("%04zu: status : %s\n", test, (ok_all == 1) ? "PASS" : "FAIL" );
        printf("%04zu: enc_comment : %s\n", test, enc_comment);
        printf("%04zu: enc_computer_return == 0 : %d\n", test, enc_computed_return);
        printf("%04zu: enc_expected_ciphertext == enc_computed_ciphertext : %d\n",   test, ok_ciphertext);
        printf("%04zu: enc_expected_shared_secret == enc_computed_shared_secret : %d\n\n", test, ok_shared_secret);
      }

      if( VERBOSE == 0 )
      { assert(ok_return == 1);
        assert(ok_ciphertext == 1);
        assert(ok_shared_secret == 1);
      }
    }
    else
    { // if VERBOSE = 2 inform the user which tests are being ignored
      if( VERBOSE == 2 )
      { printf("%04zu: status : SKIPPED\n", test);
        printf("%04zu: enc_comment : %s\n\n", test, enc_comment);
      }
    }
  }


  // ///////////////////////////////////////////////////////////////////////////
  // check dec
  char    *dec_comment;
  uint8_t *dec_secret_key; // with JADE_KEM_SECRETKEYBYTES
  uint8_t *dec_ciphertext; // with JADE_KEM_CIPHERTEXTBYTES
  int      dec_expected_result;
  uint8_t *dec_expected_shared_secret; // with JADE_KEM_BYTES

  int dec_computed_return;
  uint8_t  dec_computed_shared_secret[JADE_KEM_BYTES];

  for(test = 0; test < test_dec_number_of_tests; test++)
  {
    dec_comment = test_dec_comment[test];
    dec_secret_key =  test_dec_secret_key[test];
    dec_ciphertext = test_dec_ciphertext[test];
    dec_expected_result = test_dec_expected_result[test][0];
    dec_expected_shared_secret= test_dec_expected_shared_secret[test];

    // NOTE: ignoring the following tests
    if(!( strcmp("comment = Ciphertext too long",     dec_comment) == 0 ||
          strcmp("comment = Ciphertext too short",    dec_comment) == 0 ||
          strcmp("comment = Private key too long",    dec_comment) == 0 ||
          strcmp("comment = Private key too short",   dec_comment) == 0 ||
          strcmp("comment = Private key not reduced", dec_comment) == 0 ))
    {
      dec_computed_return = jade_kem_dec(dec_computed_shared_secret, dec_ciphertext, dec_secret_key);

      int ok_return = (dec_computed_return == dec_expected_result);
      int ok_shared_secret = memcmp(dec_expected_shared_secret, dec_computed_shared_secret, JADE_KEM_BYTES) == 0;
      int ok_all = (ok_return == 1) && (ok_shared_secret == 1);

      if(ok_all == 0) { status = 0; }

      if( (VERBOSE == 1 && ok_all == 0) || (VERBOSE == 2) )
      {
        printf("%04zu: status : %s\n", test, (ok_all == 1) ? "PASS" : "FAIL" );
        printf("%04zu: dec_comment : %s\n", test, dec_comment);
        printf("%04zu: dec_computer_return == 0 : %d\n", test, dec_computed_return);
        printf("%04zu: dec_expected_shared_secret == dec_computed_shared_secret : %d\n\n", test, ok_shared_secret);
      }

      if( VERBOSE == 0 )
      { assert(ok_return == 1);
        assert(ok_shared_secret == 1);
      }
    }
    else
    { // if VERBOSE = 2 inform the user which tests are being ignored
      if( VERBOSE == 2 )
      { printf("%04zu: status : SKIPPED\n", test);
        printf("%04zu: dec_comment : %s\n\n", test, dec_comment);
      }
    }
  }

  assert(status == 1);

  return 0;
}

