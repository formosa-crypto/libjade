
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_SECRETKEYBYTES   1281
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_PUBLICKEYBYTES   897
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_BYTES            690
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_ALGNAME          "Falcon-512"

#include <stddef.h>

int 
jade_sign_falcon_falcon512_amd64_ref_keypair(unsigned char *pk, unsigned char *sk);

int 
jade_sign_falcon_falcon512_amd64_ref(unsigned char *sm, size_t *smlen,
    const unsigned char *m, size_t mlen,
    const unsigned char *sk);

int 
jade_sign_falcon_falcon512_amd64_avx2_open(unsigned char *m, size_t *mlen,
    const unsigned char *sm, size_t smlen,
    const unsigned char *pk);
