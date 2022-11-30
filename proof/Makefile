# -*- Makefile -*-

# --------------------------------------------------------------------
ECROOT    ?=
ECCHECK   ?=
ECARGS    ?=
ECJOBS    ?= 1
ECCONF    := tests.config
XUNITOUT  ?= xunit.xml
CHECKS    ?= all
JASMIN    ?= jasminc
EASYCRYPT ?= easycrypt

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
ifeq ($(ECCHECK),)
ifeq ($(ECROOT),)
ECCHECK := ec-runtest
else
PATH    := ${ECROOT}:${PATH}
ECCHECK := $(ECROOT)/scripts/testing/runtest
endif
endif

# --------------------------------------------------------------------
SRC       := ../src
PROOF     := .
EXCLUDE   ?=
SOURCES   ?= $(filter-out $(SRC)/ $(addprefix $(SRC)/,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))
EXTRACTED := $(shell find $(PROOF) -name "*_s.ec" -o -name "*_ct.ec")
OUT       := $(addsuffix .out, $(EXTRACTED))

LOGS      ?= libjade-logs-proof.tar.gz

d:
	@echo $(OUT)

# --------------------------------------------------------------------
ifeq ($(CI),1)
.PHONY: backward_compatibility
backward_compatibility:
	$(MAKE) check-extracted
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
.PHONY: __phony check-extracted check-extracted-inner

check-extracted: extract
	$(MAKE) check-extracted-inner

check-extracted-inner: $(OUT)

$(OUT):
%.out: __phony
ifeq ($(CI),1)
	@mkdir -p $(CID)
endif
	$(EASYCRYPT) $* > $@ $(CIL) || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) reporter_s_out
	$(MAKE) reporter_ct
	$(MAKE) reporter_ct_out
	$(MAKE) $(LOGS)

reporter_s:
	./../scripts/ci/reporter/jlog "Extraction - source - status" src/ *_s.ec $(CICL)

reporter_s_out:
	./../scripts/ci/reporter/jlog "Checking - source - status" proof/ *_s.ec.out $(CICL)

reporter_ct:
	./../scripts/ci/reporter/jlog "Extraction - constant-time - status" src/ *_ct.ec $(CICL)

reporter_ct_out:
	./../scripts/ci/reporter/jlog "Checking - constant-time - status" proof/ *_ct.ec.out $(CICL)


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
	rm -f $(shell find $(PROOF) -name '*.out')

distclean: clean
	rm -f $(shell find $(PROOF) -name '*Array*.ec')
	rm -f $(shell find $(PROOF) -name '*_s.ec')
	rm -f $(shell find $(PROOF) -name '*_ct.ec')
ifeq ($(CI),1)
	rm -fr $(shell find $(PROOF) -name '.ci')
	rm -f $(LOGS)
endif

