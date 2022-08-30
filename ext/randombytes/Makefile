CC     := gcc
CFLAGS := -Wall -Ofast

default: librandombytes.a

librandombytes.a: randombytes.o
	ar -rc $@ $< && ranlib $@

randombytes.o: randombytes.c randombytes.h
	$(CC) $(CFLAGS) -o $@ -c randombytes.c

clean:
	@rm -fr *.a *.o
