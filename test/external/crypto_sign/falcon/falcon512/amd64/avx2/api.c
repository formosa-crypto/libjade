/*
 * Wrapper for implementing the SUPERCOP API.
 */

#include <stddef.h>
#include <string.h>

#define crypto_sign_keypair jade_sign_falcon_falcon512_amd64_avx2_keypair
#define crypto_sign jade_sign_falcon_falcon512_amd64_avx2
#define crypto_sign_open jade_sign_falcon_falcon512_amd64_avx2_open

#include "api.h"
//#include "crypto_sign.h"
#include "inner.h"

#define NONCELEN   40
#define SEEDLEN    48

int randombytes(unsigned char *x, unsigned long long xlen);

int
crypto_sign_keypair(unsigned char *pk, unsigned char *sk)
{
	union {
		uint8_t b[28 * 512];
		uint64_t dummy_u64;
		fpr dummy_fpr;
	} tmp;
	int8_t f[512], g[512], F[512], G[512];
	uint16_t h[512];
	unsigned char seed[SEEDLEN];
	inner_shake256_context rng;
	size_t u, v;
	unsigned savcw;

	savcw = set_fpu_cw(2);

	/*
	 * Generate key pair.
	 */
	randombytes(seed, sizeof seed);
	inner_shake256_init(&rng);
	inner_shake256_inject(&rng, seed, sizeof seed);
	inner_shake256_flip(&rng);
	falcon512dyn_avx2_keygen(
		&rng, f, g, F, G, h, 9, tmp.b);

	set_fpu_cw(savcw);
	/*
	 * Encode private key.
	 */
	sk[0] = 0x50 + 9;
	u = 1;
	v = falcon512dyn_avx2_trim_i8_encode(
		sk + u, CRYPTO_SECRETKEYBYTES - u, f, 9,
		falcon512dyn_avx2_max_fg_bits[9]);
	if (v == 0) {
		return -1;
	}
	u += v;
	v = falcon512dyn_avx2_trim_i8_encode(
		sk + u, CRYPTO_SECRETKEYBYTES - u, g, 9,
		falcon512dyn_avx2_max_fg_bits[9]);
	if (v == 0) {
		return -1;
	}
	u += v;
	v = falcon512dyn_avx2_trim_i8_encode(
		sk + u, CRYPTO_SECRETKEYBYTES - u, F, 9,
		falcon512dyn_avx2_max_FG_bits[9]);
	if (v == 0) {
		return -1;
	}
	u += v;
	if (u != CRYPTO_SECRETKEYBYTES) {
		return -1;
	}

	/*
	 * Encode public key.
	 */
	pk[0] = 0x00 + 9;
	v = falcon512dyn_avx2_modq_encode(
		pk + 1, CRYPTO_PUBLICKEYBYTES - 1, h, 9);
	if (v != CRYPTO_PUBLICKEYBYTES - 1) {
		return -1;
	}

	return 0;
}

int
crypto_sign(unsigned char *sm, unsigned long long *smlen,
	const unsigned char *m, unsigned long long mlen,
	const unsigned char *sk)
{
	union {
		uint8_t b[72 * 512];
		uint64_t dummy_u64;
		fpr dummy_fpr;
	} tmp;
	int8_t f[512], g[512], F[512], G[512];
	union {
		int16_t sig[512];
		uint16_t hm[512];
	} r;
	unsigned char seed[SEEDLEN], nonce[NONCELEN];
	unsigned char esig[CRYPTO_BYTES - 2 - sizeof nonce];
	inner_shake256_context sc;
	size_t u, sig_len;
	size_t v;
	unsigned savcw;

	/*
	 * Decode the private key.
	 */
	if (sk[0] != 0x50 + 9) {
		return -1;
	}
	u = 1;
	v = falcon512dyn_avx2_trim_i8_decode(
		f, 9,
		falcon512dyn_avx2_max_fg_bits[9],
		sk + u, CRYPTO_SECRETKEYBYTES - u);
	if (v == 0) {
		return -1;
	}
	u += v;
	v = falcon512dyn_avx2_trim_i8_decode(
		g, 9,
		falcon512dyn_avx2_max_fg_bits[9],
		sk + u, CRYPTO_SECRETKEYBYTES - u);
	if (v == 0) {
		return -1;
	}
	u += v;
	v = falcon512dyn_avx2_trim_i8_decode(
		F, 9,
		falcon512dyn_avx2_max_FG_bits[9],
		sk + u, CRYPTO_SECRETKEYBYTES - u);
	if (v == 0) {
		return -1;
	}
	u += v;
	if (u != CRYPTO_SECRETKEYBYTES) {
		return -1;
	}
	if (!falcon512dyn_avx2_complete_private(
		G, f, g, F, 9, tmp.b))
	{
		return -1;
	}

	savcw = set_fpu_cw(2);

	/*
	 * Create a random nonce (40 bytes).
	 */
	randombytes(nonce, sizeof nonce);

	/*
	 * Hash message nonce + message into a vector.
	 */
	inner_shake256_init(&sc);
	inner_shake256_inject(&sc, nonce, sizeof nonce);
	inner_shake256_inject(&sc, m, mlen);
	inner_shake256_flip(&sc);
	falcon512dyn_avx2_hash_to_point_vartime(
		&sc, r.hm, 9);

	/*
	 * Initialize a RNG.
	 */
	randombytes(seed, sizeof seed);
	inner_shake256_init(&sc);
	inner_shake256_inject(&sc, seed, sizeof seed);
	inner_shake256_flip(&sc);

	/*
	 * Compute the signature.
	 */
	falcon512dyn_avx2_sign_dyn(
		r.sig, &sc, f, g, F, G, r.hm, 9, tmp.b);

	set_fpu_cw(savcw);

	/*
	 * Encode the signature and bundle it with the message. Format is:
	 *   signature length     2 bytes, big-endian
	 *   nonce                40 bytes
	 *   message              mlen bytes
	 *   signature            slen bytes
	 */
	esig[0] = 0x20 + 9;
	sig_len = falcon512dyn_avx2_comp_encode(
		esig + 1, (sizeof esig) - 1, r.sig, 9);
	if (sig_len == 0) {
		return -1;
	}
	sig_len ++;
	memmove(sm + 2 + sizeof nonce, m, mlen);
	sm[0] = (unsigned char)(sig_len >> 8);
	sm[1] = (unsigned char)sig_len;
	memcpy(sm + 2, nonce, sizeof nonce);
	memcpy(sm + 2 + (sizeof nonce) + mlen, esig, sig_len);
	*smlen = 2 + (sizeof nonce) + mlen + sig_len;
	return 0;
}

extern int __verify_raw_external(uint16_t*, int16_t*, uint16_t*);

int
crypto_sign_open(unsigned char *m, unsigned long long *mlen,
	const unsigned char *sm, unsigned long long smlen,
	const unsigned char *pk)
{
	union {
		uint8_t b[2 * 512];
		uint64_t dummy_u64;
		fpr dummy_fpr;
	} tmp;
	const unsigned char *esig;
	uint16_t h[512], hm[512];
	int16_t sig[512];
	inner_shake256_context sc;
	size_t sig_len, msg_len;

	/*
	 * Decode public key.
	 */
#if 0

#else
	if (pk[0] != 0x00 + 9) {
		return -1;
	}
	if (falcon512dyn_avx2_modq_decode(
		h, 9, pk + 1, CRYPTO_PUBLICKEYBYTES - 1)
		!= CRYPTO_PUBLICKEYBYTES - 1)
	{
		return -1;
	}
#endif

	/*
	 * Find nonce, signature, message length.
	 */
#if 0

#else
	if (smlen < 2 + NONCELEN) {
		return -1;
	}
	sig_len = ((size_t)sm[0] << 8) | (size_t)sm[1];
	if (sig_len > (smlen - 2 - NONCELEN)) {
		return -1;
	}
	msg_len = smlen - 2 - NONCELEN - sig_len;

	/*
	 * Decode signature.
	 */
	esig = sm + 2 + NONCELEN + msg_len;
	if (sig_len < 1 || esig[0] != 0x20 + 9) {
		return -1;
	}
#endif

#if 0

#else
	if (falcon512dyn_avx2_comp_decode(
		sig, 9, esig + 1, sig_len - 1) != sig_len - 1)
	{
		return -1;
	}
#endif

	/*
	 * Hash nonce + message into a vector.
	 */
#if 0

#else
	inner_shake256_init(&sc);
	inner_shake256_inject(&sc, sm + 2, NONCELEN + msg_len);
	inner_shake256_flip(&sc);
	falcon512dyn_avx2_hash_to_point_vartime(
		&sc, hm, 9);
#endif




	/*
	 * Verify signature.
	 */
#if 0
	// this is wrong
	if(!__verify_raw_external(hm, sig, h)){
		return -1;
	}
#else
	falcon512dyn_avx2_to_ntt_monty(h, 9);
	if (!falcon512dyn_avx2_verify_raw(
		hm, sig, h, 9, tmp.b))
	{
		return -1;
	}
#endif


	/*
	 * Return plaintext.
	 */
	memmove(m, sm + 2 + NONCELEN, msg_len);
	*mlen = msg_len;
	return 0;
}
