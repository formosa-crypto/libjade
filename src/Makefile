# -*- Makefile -*-

# --------------------------------------------------------------------
SUBDIRS := $(shell find crypto_* -name '*.jazz' -not -name 'test*' -exec dirname {} \; | sort --unique)

# --------------------------------------------------------------------
SRC    := $(shell find crypto_* -name '*.c')
ASM    := $(shell find crypto_* -name '*.s')
OBJ    := $(SRC:%.c=_build/%.o) $(ASM:%.s=_build/%.o)
AS     := as
CC     := gcc
CFLAGS := -Wall -Ofast

# --------------------------------------------------------------------
.PHONY: default clean __real_libjade __force

default: libjade.a

jasmin:
	@for i in $(SUBDIRS); do $(MAKE) -C $$i; done

libjade.a: jasmin __force
	$(MAKE) __real_libjade

__real_libjade: $(OBJ)
	ar -rc libjade.a $(OBJ) && ranlib libjade.a

_build/%.c: %.c
	@mkdir -p _build/`dirname $<`; cp $< _build/`dirname $<`
	@echo '$< --> _build/'

_build/%.s: %.s
	@mkdir -p _build/`dirname $<`; cp $< _build/`dirname $<`
	@echo '$< --> _build/'

clean:
	for i in $(SUBDIRS); do $(MAKE) -C $$i clean; done
	rm -fr _build libjade.a
