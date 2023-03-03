CC     ?= clang
CFLAGS  = -mtune=native -march=native -O3 -mavx2 
CFLAGS += -Wall -Wextra -Wpedantic -Wredundant-decls \
          -Wshadow -Wpointer-arith -fomit-frame-pointer


HEADERs := api.h  fpr.h  inner.h
SOURCEs := api.c  codec.c  common.c  fft.c  fpr.c  keygen.c  rng.c  shake.c  sign.c  vrfy.c
OBJs    := $(SOURCEs:%.c=%.o)

LIB     := external_crypto_sign_falcon_falcon512_amd64_avx2.a

#--
default: $(LIB)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(LIB): $(OBJs)
	ar -rc $@ $(OBJs)
	ranlib $@

.PHONY: clean
clean:
	rm -rf $(OBJs)
	rm -rf $(LIB)

