# --------------------------------------------------------------------
# some commands frequently run during development sessions:
#
# - clean 'everything' and compile all assembly files (change -j12 accordingly):
# libjade/src$ make CI=1 distclean && make -j12 CI=1 compile && make CI=1 reporter
#
# - build libjade-amd64.a/h (note that there are no tests that use libjade-*.a
#   directly -- only .s files -- feel free to open a PR/reach out);
# libjade/src$ make CI=1 distclean && make -j12 libjade-amd64.a libjade-amd64.h
#
# - build libjade-armv7m.a libjade-armv7m.h
# libjade/src$ make CI=1 distclean && make -j12 CI=1 ARCH=armv7m CC=arm-linux-gnueabi-gcc CFLAGS='-Wall -O3' AS=arm-linux-gnueabi-as AR=arm-linux-gnueabi-ar RANLIB=arm-linux-gnueabi-ranlib libjade-armv7m.a libjade-armv7m.h && make CI=1 reporter
#
# In particular for the last command, it is helpful to setup some sort of
# facilitator that sets the variables according to the system's configuration || *


# --------------------------------------------------------------------
AS      ?= as
CC      ?= clang
CFLAGS  ?= -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	         -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	         -fstrict-aliasing -fno-common -pipe
AR      ?= ar
RANLIB  ?= ranlib

JASMIN  ?= jasminc

# --------------------------------------------------------------------
CI      ?= 0
export CI
CICL    ?= "1"

# --------------------------------------------------------------------
SRC     ?= .
LOGS    := $(SRC)/libjade-logs-src.tar.gz


EXCLUDE ?=
FILTER  ?= $(SRC)/crypto_%

# JAZZ contains *all* directories where there is a '.jazz' file: it is expected
# that there is a Makefile in the same directory whose default rule produces .s
# file(s).

JAZZ    ?= $(filter $(FILTER), $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -name '*.jazz')))))
SAFETY  ?= $(addsuffix safety, $(JAZZ))


# OBJECTS contains all '.o' files we would like to build. This list is built
# from the existing .s files (default rule compiles everything to assembly;
# then, on a second/third call to this Makefile, we create individual libraries
# -- at the time of this writing, amd64 and armv7m.

ARCH     ?= amd64

JAZZ_ARCH ?= $(filter $(FILTER), $(filter-out $(addprefix ./,$(EXCLUDE)), $(sort $(dir $(shell find $(SRC) -path "*/$(ARCH)/*" -name '*.jazz')))))
ASSEMBLY  := $(shell find $(SRC) -path "*/$(ARCH)/*" -name '*.s')
OBJECTS   := $(ASSEMBLY:%.s=%.o)
HEADERS   := $(addsuffix include/api.h, $(dir $(ASSEMBLY)))

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
.PHONY: libjade-$(ARCH).a libjade-$(ARCH).h $(JAZZ) clean distclean $(LOGS)
.INTERMEDIATE: $(OBJECTS)

default: compile

compile: $(JAZZ)

$(JAZZ):
	$(MAKE) -C $@ || true

# --------------------------------------------------------------------

# two call building pattern:
# - compile as many .s as possible (from .jazz);
# - then archive

libjade-$(ARCH).a: compile-$(ARCH)
	$(MAKE) __libjade-$(ARCH).a

__libjade-$(ARCH).a: $(OBJECTS)
	$(AR) -rc libjade-$(ARCH).a $(OBJECTS)
	$(RANLIB) libjade-$(ARCH).a

libjade-$(ARCH).h: $(HEADERS)
	echo "" | cat - $(HEADERS) > $@

compile-$(ARCH): $(JAZZ_ARCH)

# --------------------------------------------------------------------

SAFETY_TIMEOUT ?= 1440m
export SAFETY_TIMEOUT

.PHONY: safety
safety: $(SAFETY)

$(SAFETY):
	$(MAKE) -C $(@D) $(@F) || true

# --------------------------------------------------------------------
ifeq ($(CI),1)

reporter:
	$(MAKE) reporter_s
	$(MAKE) $(LOGS)

reporter_s:
	./../scripts/ci/reporter/jlog "Compilation status" src/ *.s $(CICL)
	$(MAKE) $(LOGS)

reporter_safety:
	./../scripts/ci/reporter/jlog "Safety status" src/ *.safety $(CICL)
	$(MAKE) $(LOGS)

ERR := $(shell find $(BIN) -name '*.error')
CIR := $(shell find $(BIN) -name '*.log') $(ERR)

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
	rm -f libjade-*.a libjade-*.h $(LOGS) check.tar.gz

distclean: clean
	for i in $(JAZZ); do $(MAKE) -C $$i clean; done

