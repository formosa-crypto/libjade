
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_SECRETKEYBYTES   1281
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_PUBLICKEYBYTES   897
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_BYTES            690
#define JADE_SIGN_FALCON_FALCON512_AMD64_AVX2_ALGNAME          "Falcon-512"

#include <stdint.h>

// these function
int jade_sign_falcon_falcon512_amd64_avx2_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_sign_falcon_falcon512_amd64_avx2(
  uint8_t *signed_message,
  uint64_t *signed_message_length,
  const uint8_t *message,
  uint64_t message_length,
  const uint8_t *secret_key
);

int jade_sign_falcon_falcon512_amd64_avx2_open(
  uint8_t *message,
  uint64_t *message_length,
  const uint8_t *signed_message,
  uint64_t signed_message_length,
  const uint8_t *public_key
);
