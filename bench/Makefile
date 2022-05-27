# -*- Makefile -*-

# --------------------------------------------------------------------
AS      ?= as
CC      ?= gcc
CFLAGS  ?= -Wall -Wno-unused-function -Ofast
CI      ?= 0
export CI
EXCLUDE ?=

# --------------------------------------------------------------------
SRC     := ../src
BIN     ?= bin
COMMON  := common
EXT     := ../ext
RANDLIB ?= $(EXT)/randombytes/librandombytes.a

JAZZ    ?= $(filter-out $(addprefix $(SRC)/,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name 'kem.jazz'))))
BENCH   := $(subst $(SRC),$(BIN), $(JAZZ))
BENCHS  := $(addsuffix bench, $(BENCH))

# --------------------------------------------------------------------

RDIR       = $(subst $(BIN)/,,$(@D))
OPERATION  = $(subst crypto_,,$(word 1, $(subst /, ,$(RDIR))))
NAMESPACE  = $(subst crypto_,jade_,$(subst -,_,$(subst /,_,$(RDIR))))
NAMESPACE1 = $(shell echo $(NAMESPACE) | tr a-z A-Z)
IDIR       = $(subst $(BIN),$(SRC),$(@D))
ASM        = $(IDIR)/$(OPERATION).s

MAIN       = $(COMMON)/crypto_$(OPERATION).c
DEFINES    = -DJADE_NAMESPACE=$(NAMESPACE1) -DJADE_NAMESPACE_LC=$(NAMESPACE)
INCLUDES   = -I$(IDIR)/include/ -I$(COMMON)/ -I../ext/randombytes/
COMPILE    = $(CC) $(CFLAGS) -o $@ $(DEFINES) $(INCLUDES) $(MAIN) $(ASM) $(RANDLIB)

# --------------------------------------------------------------------
.PHONY: __phony benchs

default: benchs

benchs: $(BENCHS)

%/bench: $(RANDLIB) __phony | %/
	$(MAKE) -C $(IDIR)
	$(COMPILE)

$(RANDLIB):
	$(MAKE) -C $(@D)

$(BENCH): ; @mkdir -p $@

run: benchs
	for d in $(BENCH); do (cd $$d && ./bench); done

# --------------------------------------------------------------------
clean:
	rm -fr $(BIN)

