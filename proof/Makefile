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
TOP := $(realpath ../)
SRC := $(TOP)/src/
EDIRS := $(shell find $(SRC) -name '*.jazz' -exec dirname {} \; | sort --unique)
CDIRS := $(shell find $(SRC) -name 'Ec.mk' -exec dirname {} \; | sort --unique)

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

distclean: clean
	rm -f $(shell find $(TOP) -name '*Array*.ec')
	rm -f $(shell find $(TOP) -name '*_s.ec')
	rm -f $(shell find $(TOP) -name '*_ct.ec')
