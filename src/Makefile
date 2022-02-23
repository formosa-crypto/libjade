# -*- Makefile -*-

# --------------------------------------------------------------------
TOP:=$(shell git rev-parse --show-toplevel)
SRC=$(TOP)/src
EXT=$(TOP)/ext

# --------------------------------------------------------------------
# NOTE: atm. all implementations are considered; in the future they will be filtered by architecture, ..., depending on the target/requirements;
# Hence, the following variables' initialization will change;

JAZZ   := $(shell find $(SRC)/crypto_* -name '*.jazz' -exec dirname {} \; | sort --unique)
API    := $(shell find $(SRC)/crypto_* -name 'api.h')
ASM    := $(shell find $(SRC)/crypto_* -name '*.s')
EXT    := $(shell find $(EXT)/crypto_* -name '*.c')

OBJ    := $(ASM:%.s=_build/%.o)
AS     := as
CC     := gcc
CFLAGS := -Wall -Ofast

# --------------------------------------------------------------------
.PHONY: default clean __real_libjade __force

default: libjade.a libjade.h

jasmin:
	@for i in $(JAZZ); do $(MAKE) -C $$i; done

libjade.a: jasmin __force
	$(MAKE) __real_libjade

libjade.h: $(API)
	cat $(API) > $@

__real_libjade: $(OBJ)
	ar -rc libjade.a $(OBJ) && ranlib libjade.a

_build/%.c: %.c
	@mkdir -p _build/`dirname $<`; cp $< _build/`dirname $<`
	@echo '$< --> _build/'

_build/%.s: %.s
	@mkdir -p _build/`dirname $<`; cp $< _build/`dirname $<`
	@echo '$< --> _build/'

clean:
	for i in $(JAZZ); do $(MAKE) -C $$i clean; done
	rm -fr _build libjade.a
