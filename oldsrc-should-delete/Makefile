# -*- Makefile -*-

# --------------------------------------------------------------------
AS      ?= as
CC      ?= clang
CFLAGS  ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	         -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	         -fstrict-aliasing -fno-common -pipe

JASMIN    ?= jasminc
JASMIN_CT ?= jasmin-ct

# --------------------------------------------------------------------
CI      ?= 0
export CI
CICL    ?= "1"

# --------------------------------------------------------------------
LOGS    := libjade-logs-src.tar.gz

EXCLUDE ?=
SRC     := .

FILTER  ?= $(SRC)/crypto_%
JAZZ    ?=  $(filter $(FILTER), $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz')))))
SAFETY  ?= $(addsuffix safety, $(JAZZ))
SCT     ?= $(addsuffix check_sct, $(JAZZ))

SOURCES ?= $(filter-out ./, $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))
ASM     := $(shell find $(SRC) -name '*.s')
API     := $(addsuffix include/api.h, $(dir $(ASM)))
OBJ     := $(ASM:%.s=%.o)

FAIL_ON_ERROR ?= 0

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

all: $(JAZZ)

libjade.a: $(JAZZ)
	$(MAKE) __libjade

__libjade: $(OBJ)
	ar -rc libjade.a $(OBJ)
	ranlib libjade.a
	echo "" | cat - $(API) > libjade.h

$(JAZZ):
	$(MAKE) -C $@ || !(($(FAIL_ON_ERROR)))

# --------------------------------------------------------------------

SAFETY_TIMEOUT ?= 1440m
export SAFETY_TIMEOUT

.PHONY: safety
safety: $(SAFETY)

$(SAFETY):
	$(MAKE) -C $(@D) $(@F) || true

# --------------------------------------------------------------------
.PHONY: check_sct
check_sct: $(SCT)

$(SCT):
	$(MAKE) -C $(@D) $(@F) || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) $(LOGS)

reporter_s:
	./../scripts/ci/reporter/jlog "Compilation status" src/ *.s $(CICL)
	$(MAKE) $(LOGS)

reporter_safety:
	./../scripts/ci/reporter/jlog "Safety status" src/ *.safety $(CICL)
	$(MAKE) $(LOGS)

reporter_sct:
	./../scripts/ci/reporter/jlog "Speculative constant-time status" src/ *.sct $(CICL)

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
	rm -f libjade.a libjade.h $(LOGS) check.tar.gz

distclean: clean
	for i in $(SOURCES); do $(MAKE) -C $$i clean; done

