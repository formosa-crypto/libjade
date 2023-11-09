# Description of branch feature/clear-stack

Libjade branch `feature/clear-stack` compiles with Jasmin branch `merge-clear-stack`.

This Libjade branch aims to integrate the new `clear-stack` feature of the Jasmin
compiler. This new feature allows the user to indicate the compiler if the stack
should be zeroed at the end of the exection of an `export` function.

The following specific tests are being performed. Check `amd64-linux-clear-stack.yml`
for more details.

## src/

The full Libjade is compiled, in two separate runs, with the following flags:

* `JFLAGS="-stack-zeroization loopSCT"`
* `JFLAGS="-stack-zeroization unrolled"`
* `JFLAGS="-stack-zeroization loopSCT -register-zeroization all"`
* `JFLAGS="-stack-zeroization unrolled -register-zeroization all"`

## test/

In `src/`, only the compilation step is tested. In this branch tests, in addition
to the tests performed in `main`, there is a specific test to check if the stack
is cleared: `libjade/test/crypto_*/clearstack-amd64.c`. When the functions being
tested do not call external functions, such as `randombytes`, these tests can be
adjusted to check if there are writes below (depending on one's perspective) the
stack pointer since there is a "canary" write and check that can be enabled.

Falcon512 is excluded from the tests because it is a partial implementation,
and only the verification procedure is implemented in Jasmin (the remaining
implementation is written in C). If there is no complete implementation of 
Falcon when this branch results in a PR to main, then this must be handled
(check `libjade/test/Makefile.partial_implementations` and adjust `clearstack-amd64.c`
files).

* JFLAGS="-stack-zeroization loopSCT" EXCLUDE=crypto_sign/falcon/falcon512/amd64/avx2/
* JFLAGS="-stack-zeroization unrolled" EXCLUDE=crypto_sign/falcon/falcon512/amd64/avx2/
* JFLAGS="-stack-zeroization loopSCT -register-zeroization all" EXCLUDE=crypto_sign/falcon/falcon512/amd64/avx2/
* JFLAGS="-stack-zeroization unrolled -register-zeroization all" EXCLUDE=crypto_sign/falcon/falcon512/amd64/avx2/

