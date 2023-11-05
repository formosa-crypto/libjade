#ifndef TRY_ANYTHING
#define TRY_ANYTHING

uint8_t* alignedcalloc(void**, size_t);
unsigned long long myrandom(void);
void double_canary(uint8_t*, uint8_t*, size_t);
void input_prepare(uint8_t*, uint8_t*, size_t);
void output_prepare(uint8_t*, uint8_t*, size_t);
void output_compare(const uint8_t*, const uint8_t*, size_t, const char*);
void input_compare(const uint8_t*, const uint8_t*, size_t, const char *);
void fail(const char *);
void checksum(uint8_t*, uint8_t*, size_t);
int try_anything_main(void);

#endif
