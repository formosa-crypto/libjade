# -*- Makefile -*-

# --------------------------------------------------------------------
AS      ?= as
CC      ?= gcc
CFLAGS  ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	         -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes\
	         -fstrict-aliasing -fno-common -pipe -g
JASMIN  ?= jasminc

# --------------------------------------------------------------------
# CI  - 0 or 1 depending if in CI or not : example : $ make ... CI=1 ...
# CID - CI DIRNAME
# CIC - CI CLEAR LOGS and ERRORS
# CIL - CI LOG stderr

CI      ?= 0
export CI


CID  =
CIC  = true 
CIL  =
CICL ?= "1"

ifeq ($(CI),1)

CID = $(@D)/.ci

CIC = (rm -f $(CID)/$(@F).*)

CIL = 2> $(CID)/$(@F).log || \
      (echo $$? | cat - $(CID)/$(@F).log > $(CID)/$(@F).error && \
       rm -f $(CID)/$(@F).log && \
       exit 127)
endif

# --------------------------------------------------------------------
SRC      := ../src
BIN      ?= bin
COMMON   := common

EXT      := ../ext
RANDSRC  := $(COMMON)/notrandombytes.c $(COMMON)/notrandombytes1.c

JAZZ     ?= $(filter-out $(addprefix $(SRC)/,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz'))))
TESTDIR  := $(subst $(SRC),$(BIN), $(JAZZ))

CHECKSUMSMALL := $(addsuffix checksumsmall, $(TESTDIR))
CHECKSUMBIG   := $(addsuffix checksumbig, $(TESTDIR))
PRINTPARAMS   := $(addsuffix printparams, $(TESTDIR))
FUNCTEST      := $(addsuffix functest, $(TESTDIR))

EXEC          := $(CHECKSUMSMALL) $(CHECKSUMBIG) $(PRINTPARAMS) $(FUNCTEST)
OUT           := $(addsuffix .out, $(EXEC))

# --------------------------------------------------------------------

RDIR        = $(subst $(BIN)/,,$(@D))
OPERATION   = $(subst crypto_,,$(word 1, $(subst /, ,$(RDIR))))
NAMESPACE   = $(subst crypto_,jade_,$(subst -,_,$(subst /,_,$(RDIR))))
NAMESPACE1  = $(shell echo $(NAMESPACE) | tr a-z A-Z)
IDIR        = $(subst $(BIN),$(SRC),$(@D))
ASM         = $(IDIR)/$(OPERATION).s

DEFINE     ?=
DNAMESPACES = -DJADE_NAMESPACE=$(NAMESPACE1) -DJADE_NAMESPACE_LC=$(NAMESPACE)
INCLUDES    = -I$(IDIR)/include/ -I$(COMMON)/ -Iinclude/
PRINT       = common/print.c
COMPILE     = $(CC) $(CFLAGS) -o $@ $(DEFINE) $(DNAMESPACES) $(INCLUDES) crypto_$(OPERATION)/$(@F).c $(PRINT) $(ASM) $(RANDSRC) $(CIL)

LOGS       ?= libjade-logs-test.tar.gz

# --------------------------------------------------------------------
.PHONY: __phony default

default: $(OUT)

$(EXEC):
%/checksumsmall: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

%/checksumbig: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

%/printparams: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

%/functest: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

$(OUT):
%.out: %
	$(CIC)
	./$* > $@ $(CIL) || true

# --------------------------------------------------------------------

$(TESTDIR): ; @mkdir -p $@
ifeq ($(CI),1)
.PRECIOUS: %/$(CID)
%/$(CID): ; @mkdir -p $@
endif

# --------------------------------------------------------------------
ifeq ($(CI),1)

.PHONY: reporter $(LOGS)

reporter:
	$(MAKE) reporter_compilation
	$(MAKE) reporter_execution
	$(MAKE) reporter_checksums
	$(MAKE) $(LOGS)

reporter_compilation:
	@for type in checksumsmall checksumbig printparams functest; do \
	  ./../scripts/ci/reporter/jlog "Compilation status - $$type" test/bin $$type $(CICL); \
	done

reporter_execution:
	@for type in checksumsmall checksumbig printparams functest; do \
	  ./../scripts/ci/reporter/jlog "Execution status - $$type" test/bin $$type.out $(CICL); \
	done

reporter_checksums:
	./scripts/checksumsok
	./../scripts/ci/reporter/jlog "Checksums status" test/bin checksum*.ok $(CICL);

ERR := $(shell test -d $(BIN) && find $(BIN) -name '*.error')
CIR := $(shell test -d $(BIN) && find $(BIN) -name '*.log') $(ERR)

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
	rm -fr $(BIN)

distclean: clean

