CC     := gcc
CFLAGS := -Wall -Ofast -c

default: rand1.o

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	@rm -fr *.o
