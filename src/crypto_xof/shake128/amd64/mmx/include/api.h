#ifndef JADE_XOF_SHAKE128_AMD64_REF_API_H
#define JADE_XOF_SHAKE128_AMD64_REF_API_H

#define JADE_XOF_SHAKE128_AMD64_REF_ALGNAME "SHAKE128"

#include <stdint.h>

int jade_xof_shake128_amd64_mmx(
 uint8_t *out,
 uint64_t outlen,
 uint8_t *in,
 uint64_t inlen
);

#endif
