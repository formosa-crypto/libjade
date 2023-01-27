# -*- Makefile -*-

# --------------------------------------------------------------------
AS      ?= as
CC      ?= clang
CFLAGS  ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	         -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	         -fstrict-aliasing -fno-common -pipe
JASMIN  ?= jasminc

# --------------------------------------------------------------------
CI      ?= 0
export CI
CICL    ?= "1"

# --------------------------------------------------------------------
EXCLUDE ?=
SRC     := .
BUILD   := .build
JAZZ    ?= $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz'))))
SOURCES ?= $(filter-out ./, $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))
ASM     := $(shell find $(SRC) -name '*.s')
API     := $(addsuffix include/api.h, $(dir $(ASM)))
OBJ     := $(ASM:%.s=%.o)

LOGS    ?= libjade-logs-src.tar.gz

# --------------------------------------------------------------------
ifeq ($(CI),1)
.PHONY: backward_compatibility
backward_compatibility:
	$(MAKE) default
	$(MAKE) reporter
	mv $(LOGS) check.tar.gz
	$(MAKE) err
endif

# --------------------------------------------------------------------
.PHONY: libjade.a libjade.h $(JAZZ) clean distclean $(LOGS)
.INTERMEDIATE: $(OBJ)

default: libjade.a libjade.h

libjade.a: $(JAZZ)
	$(MAKE) __libjade

__libjade: $(OBJ)
	ar -rc libjade.a $(OBJ)
	ranlib libjade.a
	echo "" | cat - $(API) > libjade.h

$(JAZZ):
	$(MAKE) -C $@ || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) $(LOGS)

reporter_s:
	./../scripts/ci/reporter/jlog "Compilation status" src/ *.s $(CICL)

ERR := $(shell find $(BIN) -name '*.error')
CIR := $(shell find $(BIN) -name '*.log') $(ERR)

$(LOGS):
	@$(JASMIN) -version > notes
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
	rm -f $(LOGS)
endif

distclean: clean
	for i in $(SOURCES); do $(MAKE) -C $$i clean; done

