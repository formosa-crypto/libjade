# -*- Makefile -*-

# --------------------------------------------------------------------
AS     := as
CC     := gcc
CFLAGS := -Wall -Ofast
CI     ?= 0
export CI

# --------------------------------------------------------------------
SRC   :=
BUILD := .build
ERR   := .error

ECMK   := $(dir $(shell find $(SRC) -name 'Ec.mk'))
JAZZ   := $(shell find $(SRC) -name '*.jazz')
API    := $(shell find $(SRC) -name 'api.h')
ASM    := $(shell find $(SRC) -name '*.s')
OBJ    := $(ASM:%.s=$(BUILD)/%.o)
SOURCE := $(dir $(JAZZ))

# --------------------------------------------------------------------
.PHONY: default __libjade.a source $(SOURCE) check.tar.gz clean distclean

default: libjade.a libjade.h

libjade.a: source
	$(MAKE) __$@

__libjade.a: $(OBJ)
	ar -rc $(subst __,,$@) $(OBJ) && ranlib $(subst __,,$@)
	@$(MAKE) check.tar.gz

libjade.h: $(API)
	cat $(API) > $@

source: $(SOURCE)
$(SOURCE):
	@$(MAKE) -C $@ || touch $(ERR)

$(BUILD)/%.s: %.s
	@mkdir -p $(dir $@); cp $< $(dir $@)

clean:
	@for i in $(SOURCE); do $(MAKE) -C $$i clean; done
	@for i in $(ECMK); do $(MAKE) -C $$i -f Ec.mk clean; done

distclean: clean
	rm -fr libjade.a libjade.h $(ERR) $(BUILD) check.tar.gz

# --------------------------------------------------------------------
FAIL := $(shell find $(SRC) -name '*.fail')
CIL := $(shell find $(SRC) -name '.ci')
check.tar.gz:
	$(shell tar -zcvf $@ $(CIL))
ifeq ($(CI),1)
ifneq ($(words $(FAIL)),0)
	$(error $(FAIL))
endif
endif



