# -*- Makefile -*-

# --------------------------------------------------------------------
ECROOT   ?=
ECCHECK  ?=
ECARGS   ?=
ECJOBS   ?= 1
ECCONF   := tests.config 
XUNITOUT ?= xunit.xml
CHECKS   ?= all
CI       ?= 0
export CI

ifeq ($(ECCHECK),)
ifeq ($(ECROOT),)
ECCHECK := ec-runtest
else
PATH    := ${ECROOT}:${PATH}
ECCHECK := $(ECROOT)/scripts/testing/runtest
endif
endif

# --------------------------------------------------------------------
TOP := $(abspath ../)
SRC := $(TOP)/src/
PROOF := $(TOP)/proof/
EDIRS := $(shell find $(SRC) -name '*.jazz' -exec dirname {} \; | sort --unique)
CDIRS := $(shell find $(SRC) -name 'Ec.mk' -exec dirname {} \; | sort --unique)

# --------------------------------------------------------------------
.PHONY: default usage check check-xunit extract clean

default: check
ifeq ($(CI),1)
	$(MAKE) check.tar.gz
	$(MAKE) err
endif

usage:
	@echo "Usage: make <target> where <target> in [check|check-xunit]" >&2

check: extract
	$(ECCHECK) --bin-args="$(ECARGS)" --jobs="$(ECJOBS)" $(ECCONF) $(CHECKS)

extract:
	for dir in $(EDIRS); do $(MAKE) -C $$dir extract; done
	for dir in $(CDIRS); do $(MAKE) -C $$dir -f Ec.mk extract; done

clean:
	rm -f $(shell find $(PROOF) -name '*.eco')

distclean: clean
	rm -f $(shell find $(PROOF) -name '*Array*.ec')
	rm -f $(shell find $(PROOF) -name '*_s.ec')
	rm -f $(shell find $(PROOF) -name '*_ct.ec')

# --------------------------------------------------------------------
ifeq ($(CI),1)

ERR := $(shell find $(SRC) -name '*.ec.error')
CIL := $(shell find $(SRC) -name '.ci')

check.tar.gz:
	@tar -zcvf $@ $(CIL)
	./../scripts/ci/jproof

err:
ifneq ($(words $(ERR)),0)
	$(error $(ERR))
endif

endif

