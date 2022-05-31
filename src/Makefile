# -*- Makefile -*-

# --------------------------------------------------------------------
AS      ?= as
CC      ?= gcc
CFLAGS  ?= -Wall -Ofast
CI      ?= 0
export CI
EXCLUDE ?=

# --------------------------------------------------------------------
SRC    := .
BUILD  := .build

ECMK   := $(filter-out $(addprefix ./,$(EXCLUDE)), $(dir $(shell find $(SRC) -name 'Ec.mk'))) # just for cleaning .deps and .ci
JAZZ   := $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz'))))
API    := $(shell find $(SRC) -name 'api.h')
ASM    := $(shell find $(SRC) -name '*.s')
OBJ    := $(ASM:%.s=$(BUILD)/%.o)

# --------------------------------------------------------------------
.PHONY: default __libjade.a source $(JAZZ) clean-ci clean distclean check.tar.gz report err

default: libjade.a libjade.h

libjade.a: source
	$(MAKE) __$@

__libjade.a: $(OBJ)
	ar -rc $(subst __,,$@) $(OBJ) && ranlib $(subst __,,$@)
ifeq ($(CI),1)
	$(MAKE) check.tar.gz
	$(MAKE) report
	$(MAKE) err
endif

libjade.h: $(API)
	cat $(API) > $@

source: $(JAZZ)
$(JAZZ):
	$(MAKE) -C $@ || true

$(BUILD)/%.s: %.s
	mkdir -p $(dir $@); cp $< $(dir $@)

# --------------------------------------------------------------------

check-sct:
	for i in $(JAZZ); do $(MAKE) -C $$i $@; done

# --------------------------------------------------------------------
clean-ci:
	for i in $(JAZZ); do $(MAKE) -C $$i clean-ci; done
	for i in $(ECMK); do $(MAKE) -C $$i -f Ec.mk clean-ci; done

clean:
	for i in $(JAZZ); do $(MAKE) -C $$i clean; done
	for i in $(ECMK); do $(MAKE) -C $$i -f Ec.mk clean; done

distclean: clean
	rm -fr libjade.a libjade.h $(BUILD) check.tar.gz

# --------------------------------------------------------------------
ifeq ($(CI),1)

ERR := $(shell find $(SRC) -name '*.s.error')
CIL := $(shell find $(SRC) -name '.ci')

check.tar.gz:
	@tar -zcvf $@ $(CIL)

report:
	./../scripts/ci/jsrc

err:
ifneq ($(words $(ERR)),0)
	$(error $(ERR))
endif

endif

