CC     ?= clang
CFLAGS ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	        -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	        -fstrict-aliasing -fno-common -pipe

default: librandombytes.a

librandombytes.a: randombytes.o
	ar -rc $@ $< && ranlib $@

randombytes.o: randombytes.c randombytes.h
	$(CC) $(CFLAGS) -o $@ -c randombytes.c

clean:
	@rm -fr *.a *.o
