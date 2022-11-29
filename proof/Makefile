# -*- Makefile -*-

# --------------------------------------------------------------------
ECROOT   ?=
ECCHECK  ?=
ECARGS   ?=
ECJOBS   ?= 1
ECCONF   := tests.config 
XUNITOUT ?= xunit.xml
CHECKS   ?= all
JASMIN   ?= jasminc

# --------------------------------------------------------------------
CI       ?= 0
export CI
CICL     ?= "1"

# --------------------------------------------------------------------
ifeq ($(ECCHECK),)
ifeq ($(ECROOT),)
ECCHECK := ec-runtest
else
PATH    := ${ECROOT}:${PATH}
ECCHECK := $(ECROOT)/scripts/testing/runtest
endif
endif

# --------------------------------------------------------------------
SRC     := ../src
PROOF   := .
EXCLUDE ?= $(SRC)/ $(SRC)/crypto_sign/dilithium/dilithium2/amd64/avx2/ $(SRC)/crypto_sign/dilithium/dilithium3/amd64/avx2/ $(SRC)/crypto_sign/dilithium/dilithium5/amd64/avx2/
SOURCES ?= $(filter-out $(EXCLUDE), $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))

LOGS    ?= libjade-logs-proof.tar.gz

d:
	@echo $(SOURCES)

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
.PHONY: check extract $(SOURCES)

default: check

check: extract
	$(ECCHECK) --bin-args="$(ECARGS)" --jobs="$(ECJOBS)" $(ECCONF) $(CHECKS)

extract: $(SOURCES)
	@true

$(SOURCES):
	$(MAKE) -C $@ extract || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) reporter_ct
	$(MAKE) $(LOGS)

reporter_s:
	./../scripts/ci/reporter/jlog "Extraction - source - status" src/ *_s.ec $(CICL)

reporter_ct:
	./../scripts/ci/reporter/jlog "Extraction - constant-time - status" src/ *_ct.ec $(CICL)

ERR := $(shell find $(SRC) -name '*.error')
CIR := $(shell find $(SRC) -name '*.log') $(ERR)

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
	rm -f $(shell find $(PROOF) -name '*.eco')

distclean: clean
	rm -f $(shell find $(PROOF) -name '*Array*.ec')
	rm -f $(shell find $(PROOF) -name '*_s.ec')
	rm -f $(shell find $(PROOF) -name '*_ct.ec')
ifeq ($(CI),1)
	rm -f $(LOGS)
endif

