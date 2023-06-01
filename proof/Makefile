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

CI  ?= 0
export CI


CID  =
CIC  = true
CIL  =
CICL ?= "1"

ifeq ($(CI),1)

CID = $(@D)/.ci

CIC = (mkdir -p $(CID); rm -f $(CID)/$(@F).*)

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
LOGS      := libjade-logs-proof.tar.gz

SRC       := ../src
PROOF     := .

IDIR       = $(SRC)/$(@D)

EXCLUDE   ?=

SOURCE_DIRS   ?= $(filter-out $(SRC)/ $(addprefix $(SRC)/,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name 'Makefile'))))

EXTRACTED_FILES     := $(shell find $(PROOF) -name "*_s.ec" -o -name "*_ct.ec")
EXTRACTED_FILES_OUT := $(addsuffix .out, $(EXTRACTED_FILES))

PROOF_S_FILES         := $(shell find $(PROOF) -name "*.ec" -not -name "*_s.ec" -not -name "*_ct.ec" -not -name "*_ct_proof.ec" -not -name "Array*.ec" -not -name "WArray*.ec")
PROOF_S_FILES_OUT     := $(addsuffix .out, $(PROOF_S_FILES))

PROOF_CT_FILES        := $(shell find $(PROOF) -name "*_ct_proof.ec")
PROOF_CT_FILES_OUT     := $(addsuffix .out, $(PROOF_CT_FILES))

# --------------------------------------------------------------------
ifeq ($(CI),1)
.PHONY: backward_compatibility
backward_compatibility:
	$(MAKE) extract
	$(MAKE) check-all-inner
	$(MAKE) reporter
	mv $(LOGS) check.tar.gz
	$(MAKE) err
endif

# --------------------------------------------------------------------
.PHONY: check extract $(SOURCE_DIRS)

default: check

check: extract
	$(MAKE) check-all-inner

check-runtest: extract
	$(EASYCRYPT) runtest $(ECCONF) $(CHECKS)

extract: $(SOURCE_DIRS)
	@true

$(SOURCE_DIRS):
	$(MAKE) -C $@ extract || true

# --------------------------------------------------------------------
.PHONY: __phony check-extracted-inner check-proof-s-inner check-proof-ct-inner

check-all-inner: $(EXTRACTED_FILES_OUT) $(PROOF_S_FILES_OUT) $(PROOF_CT_FILES_OUT)

check-extracted-inner: $(EXTRACTED_FILES_OUT)
check-proof-s-inner: $(PROOF_S_FILES_OUT)
check-proof-ct-inner: $(PROOF_CT_FILES_OUT)

$(EXTRACTED_FILES_OUT):
$(PROOF_S_FILES_OUT):
$(PROOF_CT_FILES_OUT):

%.out: __phony
	$(MAKE) -C $(IDIR) extract || true
	$(CIC)
	$(EASYCRYPT) $* > $@ $(CIL) || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_extraction_s
	$(MAKE) reporter_extraction_ct
	$(MAKE) reporter_checking_all
	$(MAKE) $(LOGS)

reporter_extraction_s:
	./../scripts/ci/reporter/jlog "Extraction (jasminc) - source - status" src/ *_s.ec $(CICL)

reporter_extraction_ct:
	./../scripts/ci/reporter/jlog "Extraction (jasminc) - constant-time - status" src/ *_ct.ec $(CICL)

reporter_checking_all:
	./../scripts/ci/reporter/jlog "Checking (easycrypt) - all *.ec - status" proof/ *.ec.out $(CICL)

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
	$(MAKE) -C $(SRC) distclean

