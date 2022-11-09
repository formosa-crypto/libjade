#ifndef JADE_XOF_SHAKE128_AMD64_REF_API_H
#define JADE_XOF_SHAKE128_AMD64_REF_API_H

#define JADE_XOF_SHAKE128_AMD64_REF_ALGNAME "SHAKE128"
#define JADE_XOF_SHAKE128_AMD64_REF_ARCH    "amd64"
#define JADE_XOF_SHAKE128_AMD64_REF_IMPL    "ref"

#include <stdint.h>

int jade_xof_shake128_amd64_ref(
 uint8_t *out,
 uint64_t outlen,
 uint8_t *in,
 uint64_t inlen
);

#endif
