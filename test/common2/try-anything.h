#ifndef TRY_ANYTHING
#define TRY_ANYTHING

uint8_t* alignedcalloc(void**, uint64_t);
unsigned long long myrandom(void);
void double_canary(uint8_t*, uint8_t*, uint64_t);
void input_prepare(uint8_t*, uint8_t*, uint64_t);
void output_prepare(uint8_t*, uint8_t*, uint64_t);
void output_compare(const uint8_t*, const uint8_t*, uint64_t, const char*);
void input_compare(const uint8_t*, const uint8_t*, uint64_t, const char *);
void fail(const char *);
void checksum(uint8_t*, uint8_t*, uint64_t);
int try_anything_main(void);

#endif
