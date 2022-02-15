# TODO : refactor for common files (ECSRC2-related) (*.jazz are already handled) 

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

SRC = $(shell git rev-parse --show-toplevel)/src/
JSRC := $(shell find $(SRC) -name '*.jazz' $(FIXME)) 
ECSRC := $(patsubst %.jazz, %.ec, $(subst $(SRC),,$(JSRC)))

ECSRC2 := \
common/keccak/keccak1600/amd64/ref/keccak1600.ec \
common/keccak/keccak1600/amd64/avx2/keccak1600.ec

# --------------------------------------------------------------------
.PHONY: default usage check check-xunit extract clean

default: check

usage:
	@echo "Usage: make <target> where <target> in [check|check-xunit]" >&2

check: extract
	$(ECCHECK) --bin-args="$(ECARGS)" --jobs="$(ECJOBS)" $(ECCONF) $(CHECKS)

extract: $(ECSRC) $(ECSRC2)
	@true

# --------------------------------------------------------------------
# THIS SECTION WILL BE REMOVED
common/keccak/keccak1600/amd64/ref/keccak1600.ec: $(SRC)/common/keccak/keccak1600/amd64/ref/keccak1600.jinc
	(cd $(@D) && jasminc -ec _keccak1600_ref -oec $(@F) $<)

common/keccak/keccak1600/amd64/avx2/keccak1600.ec: $(SRC)/common/keccak/keccak1600/amd64/avx2/keccak1600.jinc
	(cd $(@D) && jasminc -ec _keccak1600_avx2 -oec $(@F) $<)

# --------------------------------------------------------------------
$(ECSRC): %.ec : $(SRC)%.jazz
	make -C $(<D) extract
	cp  $(<D)/.ec/*.ec $(@D)/

# --------------------------------------------------------------------
clean:
	make -C ../src/ clean
	rm -f $(ECSRC)
	rm -f $(ECSRC:%.ec=%.eco)
	for i in $(sort $(dir $(ECSRC))); do \
		find $$i -name "*Array*.ec*" | while read f; do rm -f $$f; done \
	done
	rm -f $(ECSRC2)
	rm -f $(ECSRC2:%.ec=%.eco)
	for i in $(sort $(dir $(ECSRC2))); do \
		find $$i -name "*Array*.ec*" | while read f; do rm -f $$f; done \
	done


