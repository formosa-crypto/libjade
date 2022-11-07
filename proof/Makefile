# -*- Makefile -*-

# --------------------------------------------------------------------
ECROOT   ?=
ECCHECK  ?=
ECARGS   ?=
ECJOBS   ?= 1
ECCONF   := tests.config 
XUNITOUT ?= xunit.xml
CHECKS   ?= all

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
SOURCES ?= $(filter-out ../src/, $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))

LOGS    ?= libjade-logs-proof.tar.gz

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

ERR := $(shell find $(BIN) -name '*.error')
CIR := $(shell find $(BIN) -name '*.log') $(ERR)

$(LOGS):
	@jasminc -version > notes
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

