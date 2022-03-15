CC     := gcc
CFLAGS := -Wall -Ofast -c

default: randombytes.o

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	@rm -fr *.o
