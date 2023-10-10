#ifndef NISTKATRNG_H
#define NISTKATRNG_H

// Taken from PQClean common/randombytes.h and modified for libjade by Pravek Sharma

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#ifdef _WIN32
/* Load size_t on windows */
#include <crtdefs.h>
#else
#include <unistd.h>
#endif /* _WIN32 */

void nist_kat_init(uint8_t *entropy_input, const uint8_t *personalization_string, int security_strength);

int nist_kat(uint8_t *output, size_t n);

int __jasmin_syscall_randombytes__(uint8_t* _x, uint64_t xlen) __asm__("__jasmin_syscall_randombytes__");

#ifdef __cplusplus
}
#endif

#endif /* NISTKATRNG_H */
