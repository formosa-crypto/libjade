#ifndef TEST_COMMON_PRINT_H
#define TEST_COMMON_PRINT_H

#include <stdint.h>

void print_info(const char *algname, const char *arch, const char *impl);
void print_u8(const uint8_t *a, size_t l);
void print_str_u8(const char *str, const uint8_t *a, size_t l);
void print_str_c_u8(const char *str, uint64_t c, const uint8_t *a, size_t l);

#endif

