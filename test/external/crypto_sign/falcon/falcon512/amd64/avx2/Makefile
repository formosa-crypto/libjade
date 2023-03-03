# This Makefile compiles the implementation in this directory along with
# the known answer tests generator located in the
# ../../../KAT/generator/ directory. The output is an executable program
# in the build/ subdirectory, whose name starts with 'kat', followed by
# the implementation name (e.g. 'kat512int' for the 'falcon512int'
# implementation). This program, when executed, generates the .req and
# .rsp files in the expected NIST format.

.POSIX:

CC ?= clang
CFLAGS = -mtune=native -march=native -O3 -mavx2 
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
          -Wshadow -Wpointer-arith -fomit-frame-pointer
LD = gcc
LDFLAGS = 
LIBS = 

C_HEADERs = api.h fpr.h fips202.h inner.h randombytes.h type.h
C_SOURCEs = codec.c common.c fft.c fpr.c rng.c randombytes.c fips202.c \
	keygen.c sign.c
ASM_HEADERs =
ASM_SOURCEs =

OBJs := codec.o common.o fft.o fpr.o rng.o randombytes.o fips202.o keygen.o sign.o operations.o

LIB = external_crypto_sign_falcon_falcon512_amd64_avx2.a

HEADERs = $(C_HEADERs)
SOURCEs = $(C_SOURCEs)

all: $(LIB)

operations.o: $(HEADERs) $(SOURCEs) operations.c
	$(CC) $(CFLAGS) -DALGNAME=falcon512fpu -DKEYGEN_SIGN -c operations.c $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(LIB): $(OBJs)
	ar -rc $@ $(OBJs)
	ranlib $@

build:
	-mkdir build

.PHONY: clean
clean:
	rm -rf build
	rm -rf $(OBJs)
	rm -rf $(LIB)

