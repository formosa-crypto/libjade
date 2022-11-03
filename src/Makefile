# -*- Makefile -*-

# --------------------------------------------------------------------
AS      ?= as
CC      ?= gcc
CFLAGS  ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	         -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes\
	         -fstrict-aliasing -fno-common -pipe

# --------------------------------------------------------------------
CI      ?= 0
export CI
CICL    ?= "1"

# --------------------------------------------------------------------
EXCLUDE ?=
SRC     := .
BUILD   := .build
JAZZ    ?= $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz'))))
ASM     := $(shell find $(SRC) -name '*.s')
API     := $(addsuffix include/api.h, $(dir $(ASM)))
OBJ     := $(ASM:%.s=%.o)

# --------------------------------------------------------------------
.PHONY: libjade.a libjade.h $(JAZZ) clean distclean
.INTERMEDIATE: $(OBJ)

default: libjade.a libjade.h

libjade.a: $(JAZZ)
	$(MAKE) __libjade.a

__libjade.a: $(OBJ)
	ar -rc libjade.a $(OBJ)
	ranlib libjade.a

$(JAZZ):
	$(MAKE) -C $@ || true

libjade.h:
	cat $(API) > $@

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) src-ci.tar.gz

reporter_s:
	./../scripts/ci/reporter/jlog "Compilation status" src/ *.s $(CICL)

ERR := $(shell find $(BIN) -name '*.error')
CIR := $(shell find $(BIN) -name '*.log') $(ERR)

src-ci.tar.gz:
	@jasminc -version > notes
ifeq ($(words $(CIR)),0)
	@echo "good job." >> notes
	@tar -zcvf $@ notes
else
	@tar -zcvf $@ notes $(CIR)
endif
	@rm notes

err:
ifneq ($(words $(ERR)),0)
	$(error $(ERR))
endif

endif

# --------------------------------------------------------------------
clean:
	rm -fr libjade.a libjade.h
ifeq ($(CI),1)
	rm -f src-ci.tar.gz
endif

distclean: clean
	for i in $(JAZZ); do $(MAKE) -C $$i clean; done

