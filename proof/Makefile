# -*- Makefile -*-

# --------------------------------------------------------------------
ECROOT   ?=
ECCHECK  ?=
ECARGS   ?=
ECJOBS   ?= 1
ECCONF   := tests.config 
XUNITOUT ?= xunit.xml
CHECKS   ?= all

ifeq ($(ECCHECK),)
ifeq ($(ECROOT),)
ECCHECK := ec-runtest
else
PATH    := ${ECROOT}:${PATH}
ECCHECK := $(ECROOT)/scripts/testing/runtest
endif
endif

# --------------------------------------------------------------------
FIXME = -not -name 'kem.jazz'
TOP = $(shell git rev-parse --show-toplevel)
SRC = $(TOP)/src/
EDIRS := $(subst //,/,$(shell find $(SRC) -name '*.jazz' $(FIXME) -exec dirname {} \; | sort --unique))
CDIRS := $(subst //,/,$(shell find $(SRC) -name 'Ec.mk' -exec dirname {} \; | sort --unique))

# --------------------------------------------------------------------
.PHONY: default usage check check-xunit extract clean

default: check

usage:
	@echo "Usage: make <target> where <target> in [check|check-xunit]" >&2

check: extract
	$(ECCHECK) --bin-args="$(ECARGS)" --jobs="$(ECJOBS)" $(ECCONF) $(CHECKS)

extract:
	for dir in $(EDIRS); do $(MAKE) -C $$dir extract; done
	for dir in $(CDIRS); do $(MAKE) -C $$dir -f Ec.mk extract; done

clean:
	rm -f $(shell find $(TOP) -name '*.eco')
