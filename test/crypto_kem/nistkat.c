// Taken from liboqs tests/kat_kem.c and modified for libjade by Pravek Sharma
// This KAT test only generates a subset of the NIST KAT files.
// To extract the subset from a submission file, use the command:
//     cat PQCkemKAT_whatever.rsp | head -n 8 | tail -n 6

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "namespace.h"
#include "jade_kem.h"
#include "nistkatrng.h"
#include "config.h"

static void fprintBstr(FILE *fp, const char *S, const uint8_t *A, size_t L) {
	size_t i;
	fprintf(fp, "%s", S);
	for (i = 0; i < L; i++) {
		fprintf(fp, "%02X", A[i]);
	}
	if (L == 0) {
		fprintf(fp, "00");
	}
	fprintf(fp, "\n");
}

int main(void)
{
  int r;
  uint8_t public_key[JADE_KEM_PUBLICKEYBYTES];
  uint8_t secret_key[JADE_KEM_SECRETKEYBYTES];

  uint8_t shared_secret_e[JADE_KEM_BYTES];
  uint8_t shared_secret_d[JADE_KEM_BYTES];
  uint8_t ciphertext[JADE_KEM_CIPHERTEXTBYTES];

  uint8_t keypair_coins[JADE_KEM_KEYPAIRCOINBYTES];
  uint8_t enc_coins[JADE_KEM_ENCCOINBYTES];

	uint8_t entropy_input[48];
	uint8_t seed[48];

	FILE *fh = NULL;

  for (uint8_t i = 0; i < 48; i++) {
		entropy_input[i] = i;
	}

  nist_kat_init(entropy_input, NULL, 256);

	fh = stdout;

  fprintf(fh, "count = 0\n");
  nist_kat(seed, 48);
	fprintBstr(fh, "seed = ", seed, 48);

  nist_kat_init(seed, NULL, 256);

  nist_kat(keypair_coins, JADE_KEM_KEYPAIRCOINBYTES/2);
  nist_kat((uint8_t *)(keypair_coins + (JADE_KEM_KEYPAIRCOINBYTES/2)), JADE_KEM_KEYPAIRCOINBYTES/2);
  r = jade_kem_keypair_derand(public_key, secret_key, keypair_coins);
    assert(r == 0);
	fprintBstr(fh, "pk = ", public_key, JADE_KEM_PUBLICKEYBYTES);
	fprintBstr(fh, "sk = ", secret_key, JADE_KEM_SECRETKEYBYTES);

  nist_kat(enc_coins, JADE_KEM_ENCCOINBYTES);
  r = jade_kem_enc_derand(ciphertext, shared_secret_e, public_key, enc_coins);
    assert(r == 0);
	fprintBstr(fh, "ct = ", ciphertext, JADE_KEM_CIPHERTEXTBYTES);
	fprintBstr(fh, "ss = ", shared_secret_e, JADE_KEM_BYTES);

  r = jade_kem_dec(shared_secret_d, ciphertext, secret_key);
    assert(r == 0);

	r = memcmp(shared_secret_e, shared_secret_d, JADE_KEM_BYTES);
    assert(r == 0);

  return 0;
}

