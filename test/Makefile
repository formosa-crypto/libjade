# -*- Makefile -*-
#
# examples:
#
# 0.1) clean 'everything' (including libjade/src/**)
#   $ make CI=1 distclean
#
# 0.2) clean test directory (doesn't touch libjade/src/**)
#   $ make CI=1 clean
#
# 1) run crypto_hash tests (replace crypto_hash for other tests; replace
#    the '2' in -j2 with the number of processes)
#   $ make -j2 CI=1 FILTER=../src/crypto_hash/%
#   $ make -j2 CI=1 reporter_checksums
#
# 2) run kyber tests (NOTE: checking that the locally computed checksums are
#    equal to those specified in **/META.yml files is done by a separate
#    script (libjade/scripts/checksumsok) that does not consider the FILTER
#    variable; Hence, you might want to clean ( 0.2) ) before running the
#    following commands:
#   $ make -j2 CI=1 FILTER=../src/crypto_kem/kyber/%
#   $ make -j2 CI=1 reporter_checksums
#
# --------------------------------------------------------------------
AS      ?= as
CC      ?= clang
CFLAGS  ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	         -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
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
BIN      ?= bin
LOGS     := libjade-logs-test.tar.gz

SRC      := ../src
COMMON   := common

EXT      := ../ext
RANDSRC  := $(COMMON)/notrandombytes.c

FILTER   ?= $(SRC)/crypto_%
JAZZ     ?= $(filter $(FILTER), $(filter-out $(addprefix $(SRC)/,$(EXCLUDE)), $(sort $(dir $(shell test -d $(SRC) && find $(SRC) -name '*.jazz')))))

TESTDIR  := $(subst $(SRC),$(BIN), $(JAZZ))

CHECKSUMSMALL     := $(addsuffix checksumsmall, $(TESTDIR))
CHECKSUMBIG       := $(addsuffix checksumbig,   $(TESTDIR))
PRINTPARAMS       := $(addsuffix printparams,   $(TESTDIR))
FUNCTEST          := $(addsuffix functest,      $(TESTDIR))
SAFETYPARAMS      := $(addsuffix safetyparams,  $(TESTDIR))
MEMORY            := $(addsuffix memory,        $(TESTDIR))

CHECKSUMSMALL_OUT := $(addsuffix .out, $(CHECKSUMSMALL))
CHECKSUMBIG_OUT   := $(addsuffix .out, $(CHECKSUMBIG))
PRINTPARAMS_OUT   := $(addsuffix .out, $(PRINTPARAMS))
FUNCTEST_OUT      := $(addsuffix .out, $(FUNCTEST))
SAFETYPARAMS_OUT  := $(addsuffix .out, $(SAFETYPARAMS))
MEMORY_OUT        := $(addsuffix .out, $(MEMORY))

TESTS             := $(CHECKSUMSMALL)     $(CHECKSUMBIG)     $(PRINTPARAMS)     $(FUNCTEST)     $(SAFETYPARAMS)     $(MEMORY)
OUT               := $(CHECKSUMSMALL_OUT) $(CHECKSUMBIG_OUT) $(PRINTPARAMS_OUT) $(FUNCTEST_OUT) $(SAFETYPARAMS_OUT) $(MEMORY_OUT)
STDOUT            := $(subst .out,.stdout, $(OUT))

# --------------------------------------------------------------------

RDIR        = $(subst $(BIN)/,,$(@D))

OPERATION   = $(subst crypto_,,$(word 1, $(subst /, ,$(RDIR))))
OPERATION1  = $(shell echo $(OPERATION) | tr a-z A-Z)
NAMESPACE0  = $(subst crypto_$(OPERATION)_,,$(subst -,_,$(subst /,_,$(RDIR))))
NAMESPACE   = jade_$(OPERATION)_$(NAMESPACE0)
NAMESPACE1  = JADE_$(OPERATION1)_$(NAMESPACE0)

IDIR        = $(subst $(BIN),$(SRC),$(@D))
ASM         = $(IDIR)/$(OPERATION).s

DEFINE     ?=
DNAMESPACES = -DJADE_NAMESPACE=$(NAMESPACE1) -DJADE_NAMESPACE_LC=$(NAMESPACE)
INCLUDES    = -I$(IDIR)/include/ -I$(COMMON)/ -Iinclude/
PRINT       = common/print.c
COMPILE     = $(CC) $(CFLAGS) -o $@ $(DEFINE) $(DNAMESPACES) $(INCLUDES) crypto_$(OPERATION)/$(@F).c $(PRINT) $(ASM) $(RANDSRC) $(CIL)
COMPILE_P   = $(CC) $(CFLAGS) -o $@ $(DEFINE) $(DNAMESPACES) $(INCLUDES) crypto_$(OPERATION)/$(@F).c $(PRINT)        $(RANDSRC) $(CIL)

# --------------------------------------------------------------------
.PHONY: __phony default compile-and-run reporter-and-err

default: compile-and-run reporter-and-err

compile-and-run: $(SRC)
	$(MAKE) CI=1 all

reporter-and-err:
	$(MAKE) CI=1 reporter
	$(MAKE) CI=1 err

$(SRC):
	../scripts/extract-all.sh

# --------------------------------------------------------------------
$(TESTS):

include Makefile.partial_implementations

%/checksumsmall: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

%/checksumbig: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

%/printparams: __phony | %/ %/$(CID)
	$(CIC)
	$(COMPILE_P) || true

%/functest: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

%/safetyparams: __phony | %/ %/$(CID)
	$(CIC)
	$(COMPILE_P) || true

%/memory: __phony | %/ %/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(COMPILE) || true

# --------------------------------------------------------------------
# notes: the following set of rules will be generalized

bin/crypto_kem/mlkem/mlkem768/amd64/ref/test_vectors:  __phony | bin/crypto_kem/mlkem/mlkem768/amd64/ref/ bin/crypto_kem/mlkem/mlkem768/amd64/ref/$(CID)
	$(MAKE) -C $(IDIR) || true
	$(CIC)
	$(CC) $(CFLAGS) -o $@ $(DEFINE) $(DNAMESPACES) $(INCLUDES) -I crypto_kem/mlkem/mlkem768/ crypto_kem/test_vectors.c $(PRINT) $(ASM) $(RANDSRC) $(CIL)

# --------------------------------------------------------------------
$(OUT):

%memory.out: %memory
	(valgrind --leak-check=full --error-exitcode=1 --log-file=$@ ./$*memory) $(CIL) || true

%.out: %
	$(CIC)
	(cd $(dir $*) && ./$(notdir $*) > $(notdir $*).out) $(CIL) || true

$(STDOUT):
%memory.stdout: %memory
	(valgrind --leak-check=full --error-exitcode=1 ./$*memory) $(CIL) || true

%.stdout: %
	$(CIC)
	(cd $(dir $*) && ./$(notdir $*) && echo) $(CIL) || true


# --------------------------------------------------------------------
checksumsmall-all:     $(CHECKSUMSMALL)
checksumbig-all:       $(CHECKSUMBIG)
printparams-all:       $(PRINTPARAMS)
functest-all:          $(FUNCTEST)
safetyparams-all:      $(SAFETYPARAMS)
memory-all:            $(MEMORY)

checksumsmall-out-all: $(CHECKSUMSMALL_OUT)
checksumbig-out-all:   $(CHECKSUMBIG_OUT)
printparams-out-all:   $(PRINTPARAMS_OUT)
functest-out-all:      $(FUNCTEST_OUT)
safetyparams-out-all:  $(SAFETYPARAMS_OUT)
memory-out-all:        $(MEMORY_OUT)

all:                   $(OUT)

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
	@for type in checksumsmall checksumbig printparams functest safetyparams memory; do \
	  ./../scripts/ci/reporter/jlog "Compilation status - $$type" test/$(BIN) $$type $(CICL); \
	done

reporter_execution:
	@for type in checksumsmall checksumbig printparams functest safetyparams memory; do \
	  ./../scripts/ci/reporter/jlog "Execution status - $$type" test/$(BIN) $$type.out $(CICL); \
	done

reporter_checksums:
	./scripts/checksumsok
	./../scripts/ci/reporter/jlog "Checksums status" test/$(BIN) checksum*.ok $(CICL);

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
	rm -fr $(BIN) $(LOGS)

distclean: clean clean-external
	rm -fr $(SRC)

