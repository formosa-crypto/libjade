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
LOGS    := libjade-logs-src

EXCLUDE ?=
SRC     := .

FILTER  ?= $(SRC)/crypto_%
JAZZ    ?=  $(filter $(FILTER), $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz')))))
SAFETY  ?= $(addsuffix safety, $(JAZZ))
SCT     ?= $(addsuffix sct, $(JAZZ))

SOURCES ?= $(filter-out ./, $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))
ASM     := $(shell find $(SRC) -name '*.s')
API     := $(addsuffix include/api.h, $(dir $(ASM)))
OBJ     := $(ASM:%.s=%.o)

# --------------------------------------------------------------------
ifeq ($(CI),1)
.PHONY: backward_compatibility
backward_compatibility:
	$(MAKE) default
	$(MAKE) reporter
	mv $(LOGS).tar.gz check.tar.gz
	$(MAKE) err
endif

# --------------------------------------------------------------------
.PHONY: libjade.a libjade.h $(JAZZ) clean distclean $(LOGS).tar.gz
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
	$(MAKE) -C $@ || true

# --------------------------------------------------------------------

SAFETY_TIMEOUT ?= 1440m
export SAFETY_TIMEOUT

.PHONY: safety
safety: $(SAFETY)

$(SAFETY):
	$(MAKE) -C $(@D) $(@F) || true

# --------------------------------------------------------------------

.PHONY: sct
sct: $(SCT)

$(SCT):
	$(MAKE) -C $(@D) $(@F) || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) reporter_sct
	$(MAKE) logs

reporter_s:
	./../scripts/ci/reporter/jlog "Compilation status" src/ *.s $(CICL)

reporter_safety:
	./../scripts/ci/reporter/jlog "Safety status" src/ *.safety $(CICL)

reporter_sct:
	./../scripts/ci/reporter/jlog "Constant-time status" src/ *.sct $(CICL)

ERR := $(subst ./,, $(shell find . -name '*.error'))
CIR := $(subst ./,, $(shell find . -name '*.log') $(ERR))

echo_CIR:
	echo $(CIR)

logs: $(LOGS).tar.gz

$(LOGS).tar.gz:
	mkdir -p $(LOGS)
	rm -fr $(LOGS)/*
	@$(JASMIN) -version > $(LOGS)/notes
ifeq ($(words $(CIR)),0)
	echo "good job." >> $(LOGS)/notes
	tar -zcvf $@ $(LOGS)
else
	for file in $(CIR); do \
		mkdir -p $(LOGS)/$$(dirname $$(dirname $$file)); \
		cp $$file $(LOGS)/$$(dirname $$(dirname $$file))/; \
		echo $(LOGS)/$$(dirname $$(dirname $$file))/$$(basename $$file) >> $(LOGS)/notes; \
	done
	tar -zcvf $@ $(LOGS)
endif
	rm -fr $(LOGS)

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

