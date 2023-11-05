#ifndef JADE_XOF_shake128_armv7m_ref_API_H
#define JADE_XOF_shake128_armv7m_ref_API_H

#define JADE_XOF_shake128_armv7m_ref_ALGNAME "SHAKE128"
#define JADE_XOF_shake128_armv7m_ref_ARCH    "armv7m"
#define JADE_XOF_shake128_armv7m_ref_IMPL    "ref"

#include <stdint.h>

int jade_xof_shake128_armv7m_ref(
 uint8_t *output,
 uint32_t output_length,
 const uint8_t *input,
 uint32_t input_length
);

#endif
