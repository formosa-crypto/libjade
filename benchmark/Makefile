###############################################################################

.PHONY: speed
speed: clean ssbd-tools
	@python3 speed.py

###############################################################################
# to be refactored

# override as desired
TYPE=kem
SCHEME=kyber/kyber768
IMPLEMENTATION=amd64/avx2

#

TOP_DIR:=$(shell git rev-parse --show-toplevel)
SRC_DIR=$(TOP_DIR)/src
EXT_DIR=$(TOP_DIR)/ext

RND_VAR=randombytes
RND_DIR=$(EXT_DIR)/randombytes
RND_SRC=$(RND_DIR)/$(RND_VAR).c
RND_OBJ=$(RND_SRC:%.c=%.o)
RND_LIBRARY:=$(RND_DIR)/lib$(RND_VAR).a

SCHEME_DIR=$(SRC_DIR)/crypto_$(TYPE)/$(SCHEME)/$(IMPLEMENTATION)
SCHEME_INCLUDE_DIR=$(SRC_DIR)/crypto_$(TYPE)/$(SCHEME)/$(IMPLEMENTATION)/include

TYPE_UPPERCASE=$(shell echo $(TYPE) | tr a-z A-Z | tr / _ )
SCHEME_UPPERCASE:=$(shell echo $(SCHEME) | tr a-z A-Z | tr / _ )
IMPLEMENTATION_UPPERCASE:=$(shell echo $(IMPLEMENTATION) | tr a-z A-Z | tr / _ )
JADE_NAMESPACE=$(shell echo JADE_$(TYPE_UPPERCASE)_$(SCHEME_UPPERCASE)_$(IMPLEMENTATION_UPPERCASE) | tr - _)

TYPE_LOWERCASE:=$(shell echo $(TYPE) | tr A-Z a-z | tr / _ )
SCHEME_LOWERCASE:=$(shell echo $(SCHEME) | tr A-Z a-z | tr / _ )
IMPLEMENTATION_LOWERCASE:=$(shell echo $(IMPLEMENTATION) | tr A-Z a-z | tr / _ )
SCHEME_IMPLEMENTATION_LC:=$(SCHEME_LOWERCASE)_$(IMPLEMENTATION_LOWERCASE)
JADE_NAMESPACE_LC=$(shell echo jade_$(TYPE_LOWERCASE)_$(SCHEME_IMPLEMENTATION_LC) | tr - _)

BENCH_DIR=$(TOP_DIR)/benchmark
SSBDTOOLS_DIR=$(TOP_DIR)/ext/ssbd-tools
COMMON_DIR=$(BENCH_DIR)/common
COMMON_FILES=$(COMMON_DIR)/*.c
COMMON_HEADERS=
DEST_DIR=$(BENCH_DIR)/bin

SCHEME_SRC:=$(SCHEME_DIR)/$(TYPE).jazz
SCHEME_ASM:=$(SCHEME_SRC:%.jazz=%.s)
SCHEME_OBJ:=$(SCHEME_ASM:%.s=%.o)
SCHEME_LIBRARY:=$(SCHEME_DIR)/lib$(SCHEME_IMPLEMENTATION_LC).a

# This -Wall was supported by the European Commission through the ERC Starting Grant 805031 (EPOQUE)
CFLAGS=-O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	   -Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes\
	   -fstrict-aliasing -fno-common -pipe \
	   -I$(COMMON_DIR) $(EXTRAFLAGS)

all: $(DEST_DIR)/benchmark_$(SCHEME_IMPLEMENTATION_LC) \

.PHONY: build-scheme
build-scheme: $(SCHEME_LIBRARY)

.PHONY: ssbd-tools
ssbd-tools:
	make -C $(SSBDTOOLS_DIR)


$(SCHEME_DIR)/%.s : $(SCHEME_DIR)/%.jazz
	$(MAKE) -C $(SCHEME_DIR) clean && $(MAKE) -C $(SCHEME_DIR)

$(SCHEME_LIBRARY): $(SCHEME_OBJ)
	ar -rc $@ $? && ranlib $@

$(RND_OBJ): $(RND_SRC)
	$(MAKE) -C $(RND_DIR) clean && $(MAKE) -C $(RND_DIR)

$(RND_LIBRARY): $(RND_OBJ)
	ar -rc $@ $? && ranlib $@

.PHONY: clean-scheme
clean-scheme:
	cd $(SCHEME_DIR) && $(MAKE) clean



.PHONY: speed
speed: $(DEST_DIR)/speed_$(SCHEME_IMPLEMENTATION_LC)


$(DEST_DIR)/speed_$(SCHEME_IMPLEMENTATION_LC): $(SCHEME_LIBRARY) crypto_$(TYPE)/speed.c $(COMMON_FILES) $(RND_OBJ) $(COMMON_HEADERS) $(RND_LIBRARY)
	mkdir -p $(DEST_DIR)
	$(CC) $(CFLAGS) -DJADE_NAMESPACE=$(JADE_NAMESPACE) -DJADE_NAMESPACE_LC=$(JADE_NAMESPACE_LC) -I$(SCHEME_INCLUDE_DIR) -I$(RND_DIR) crypto_$(TYPE)/speed.c $(COMMON_FILES) $(RND_OBJ) -o $@ -L$(SCHEME_DIR) -l$(SCHEME_IMPLEMENTATION_LC) -L$(RND_DIR) -l$(RND_VAR)



.PHONY: clean
clean:
	$(RM) $(DEST_DIR)/speed_$(SCHEME_IMPLEMENTATION_LC)
	$(MAKE) -C $(SRC_DIR) clean

.PHONY: distclean
distclean:
	$(RM) -r $(DEST_DIR)
