# Libjade

Libjade is a formally verified cryptographic library written in 
[the jasmin programming language](https://github.com/jasmin-lang/jasmin)
with computer-verified proofs in [EasyCrypt](https://github.com/EasyCrypt/easycrypt).
Libjade is part of the [Formosa-Crypto](https://formosa-crypto.org) project.

The primary focus is on offering high-assurance implementations of post-quantum crypto (PQC)
primitives to support the migration to the next generation of asymmetric cryptography.
The library additionally contains implementations of various symmetric primitives
and&mdash;to enable hybrid deployment of PQC&mdash;also widely used elliptic-curve-based schemes.

## Information for users
This section contains information for anybody who would like to integrate code from
Libjade into a higher-level cryptographic library or application. 
If you would like to compile Libjade yourself, run tests, or reproduce proofs, 
please see [information for developers](#information-for-developers) below.

### Supported platforms
The jasmin compiler produces assembly, so all code in Libjade is platform specific.
In the latest release of Libjade, the only supported architecture is AMD64 (aka x86\_64 or x64).
All code in the latest release is in AT&T assembly format and is following the
System V AMD64 ABI, which is used by, e.g., Linux, FreeBSD, and (Intel-based) macOS.

### Primitives available in Libjade
The latest release of Libjade includes implementations of the following primitives
(asymmetric post-quantum primitives in boldface):

* Hash functions: SHA-256, SHA-512, SHA3-224, SHA3-256, SHA3-384, SHA3-512
* Extendable output functions (XOFs): SHAKE-128, SHAKE-256
* One-time authenticators: Poly1305
* Stream ciphers: ChaCha12, ChaCha20, Salsa20, XSalsa20
* Authenticated encryption ("secretbox"): XSalsa20Poly1305
* Scalar multiplication: Curve25519
* Key-encapsulation: **Kyber-512**, **Kyber-768**
<!--* Signatures: **Dilithium2**, **Dilithium3**, **Dilithium5**, **Falcon512** (verification only)-->
* Signatures: **Falcon512** (verification only)

### Obtaining and using code from Libjade
For users of Libjade we recommend [the latest release package](https://github.com/formosa-crypto/libjade/releases/latest) 
as an entry point. Release packages contain already compiled assembly files. 

Libjade is currently not set up to be used as a standalone library, but rather
as a collection of implementations of different primitives that can easily be
integrated into higher-level libraries. 
Each of the subdirectories under the `libjade`directory of the release package
contains implementations for one cryptographic functionality. 
For example, under `libjade/crypto_hash` you will find implementations of hash
functions in the leaf directories under `libjade/crypto_kem`
you will find implementations of key encapsulation mechanisms (KEMs). 
Each implementation consists of five files:
* a C header (`.h`) file;
* an assembly (`.s`) file;
* the jasmin (`.jazz`) input file that was used to produce the `.s` file;
* a file called `example.c`; and
* a `Makefile`.

In order to use code from Libjade in a higher-level library or application, 
only the `.h` and `.s` files are needed.
The `.jazz` file is included only for users who are interested in the original source.
The file `example.c` illustrates how to use the functions defined in the `.h` file
and implemented in the `.s` file, and the `Makefile` illustrates how to compile `example.c`.


### API documentation
The API of Libjade is largely following the C API of libsodium[^libsodium], which, in turn,
is building on the C API of NaCl[^nacl]. 
This means that all cryptographic objects (keys, messages, ciphertexts, signatures) are
passed through the API in "wire format", i.e., as byte arrays. 
Unlike libsodium and NaCl, Libjade currently does not offer opinionated API functions;
for example, there is no `crypto_kem` functionality with underlying primitives chosen
by the library designers, but only functions like 
`jade_kem_kyber_kyber768_amd64_ref_keypair`,
`jade_kem_kyber_kyber768_amd64_ref_enc`, and
`jade_kem_kyber_kyber768_amd64_ref_dec`,
which make the underlying primitive (here: Kyber768[^kyber]) and concrete 
implementation (here: a reference implementation targeting AMD64) explicit.
For more information about the APIs of the different cryptographic functionalities
offered by Libjade, see the [full API documentation](./doc/api.md).

### Security goals
The overarching security goal of Libjade is to provide assembly-code that is connected
through computer-verified proofs to a cryptographic security notion and that offers 
computer-verified protections against a well-defined class of implementation attacks.
Part of the guarantees are offered by the jasmin compiler, 
others through (ongoing) interactive proofs in the EasyCrypt proof assistant.

#### Properties guaranteed by the jasmin compiler
* The jasmin compiler is proven (in Coq) to preserve semantics of a program through compilation.
* The jasmin compiler is proven (in Coq) to maintain secret-independence of control flow
  and secret-independence of locations of memory access through compilation. 
<!-- TODO: uncomment once safety checking is covered by CI
* The safety checker of the jasmin compiler statically ensures memory safety
  (as long as the caller respects the function's contract). 
-->
* Thread safety is guaranteed by the fact that jasmin does not support global variables
  (as long as the caller respects the function's contract).

#### Properties guaranteed through interactive proofs
* Functional correctness of implementations with respect to a high-level EasyCrypt specification
  is guaranteed by interactive proofs in EasyCrypt.
  This is ongoing work for many implementations in Libjade; for details see
  see the [section on functional-correctness proofs](#reproducing-functional-correctness-proofs).
* Cryptographic security (e.g., indistinguishability or unforgeability notions) of the high-level 
  EasyCrypt specification is guaranteed by computer-verified proofs in EasyCrypt.
  This is ongoing work for many primitives in Libjade; for details see
  see the [section on security proofs](#reproducing-security-proofs).

<!-- Could add a section here on recommendations for caller (e.g., set SSBD) -->


<!-- TODO: Write section on performance
### Performance

-->

### Goals for future releases
Libjade is actively developed and there are multiple features we are currently working on:
* Support using Libjade in code built to run under Microsoft Windows
* Integrate jasmin's safety checker into continuous integration
* Add reference implementation for Falcon signature verification
* Support additional primitives, most notably SPHINCS+ signatures[^spx]
* Use the jasmin security type system to guarantee absence of secret-dependent control flow
  and access to memory at secret-dependent locations on source level.
* Use the jasmin security type system to enforce Spectre v1 protection[^sslh-paper] on source level
* Ensure zeroization of jasmin stack memory before returning from Libjade functions
* Cover all implementations by proofs of functional correctness
* Provide cryptographic proofs of security for all primitives included in Libjade
* Support other architectures (next step: ARMv7-M)




## Information for developers

### Branches, pull requests, and continuous-integration
Libjade uses the following structure of branches:
* The `release` branch contains only versions of Libjade that correspond to release packages.
  The head of this branch corresponds to the latest release package. If you would like to 
  [build libjade](#building-libjade) from the jasmin source for production use, 
  [run tests](#running-tests), or
  [reproduce proofs](#reproducing-proofs), we recommend to work with this branch. 
  **Note that code in any other branch is not guaranteed to have the high-assurance guarantees that Libjade aims for**.
  Before any code is merged into this branch, our continuous integration checks that
  it builds with [the latest release of the jasmin compiler](https://github.com/jasmin-lang/jasmin/releases/latest), 
  that all tests <!--TODO: uncomment once safety checking is part of CI
  (including rather time-consuming safety checking)--> 
  pass, and that all proofs of functional correctness are reproducible with 
  [the latest release of EasyCrypt](https://github.com/EasyCrypt/easycrypt/releases/latest).
  Merging code from `main` (see below) into `release` is done by the
  Libjade maintainers; i.e., we do not accept pull requests into the `release` branch.
* The `main` branch is used to work towards the next release of Libjade. 
  Pull requests into this branch are checked by CI, but some particularly
  time-consuming CI tests may run only periodically and not with every
  merge into this branch. Code in ``main`` is expected to build with the
  ``main`` branch of the [jasmin compiler](https://github.com/jasmin-lang/jasmin) 
  and all proofs are expected to be reproducible with the 
  ``main`` branch of [EasyCrypt](https://github.com/EasyCrypt/easycrypt).
  We accept and solicit pull requests into ``main``.
* All other branches are feature branches. 
  They should be appropriately named to reflect what feature they
  are implementing. Once the feature is implemented and passed review
  and CI tests, a pull request to ``main`` should be issuedi. 
  Once the feature is merged into ``main``, 
  the corresponding feature branch should be deleted.

### Building Libjade

In order to build Libjade, you will first need to 
[obtain and build the jasmin compiler](https://github.com/jasmin-lang/jasmin/wiki/Installation-instructions).
In the following we will assume that you have built the correct branch of the jasmin compiler
(e.g., the latest release in order to build code in the `release` branch of Libjade or the
head of the jasmin `main` branch if you are working with the `main` branch of Libjade) and
that `jasminc` is in your `PATH` environment variable.


#### Building all code in Libjade
In order to build all code in Libjade, simply run
```
cd src/ && make
```
This will, in each leaf directory under `src/crypto_*/`, build one `.s` file from the corresponding `.jazz` file.
For example, it will build 
`src/crypto_kem/kyber/kyber768/amd64/ref/kem.s` from
`src/crypto_kem/kyber/kyber768/amd64/ref/kem.jazz` and it will build
`src/crypto_hash/sha3-256/amd64/bmi1/hash.s` from
`src/crypto_hash/sha3-256/amd64/bmi1/hash.jazz`.

Also, this will build a file `src/libjade.h` and a file `src/libjade.a`, 
each with all implementations of all primitives offered by Libjade.

To remove all files produced by this global build process, simply run `make distclean` in the `src/` directory.


#### Building select implementations
Alternatively, if you are interested in building only a specific implemenation of a specific primitive
contained in Libjade, you can simply run `make` in the corresponding leaf directory under `src/crypto_*`.
For example, to build just the Kyber768 reference implementation targeting the AMD64 architecture, run
```
cd src/crypto_kem/kyber/kyber768/amd64/ref/ && make
```
This will only build
`src/crypto_kem/kyber/kyber768/amd64/ref/kem.s` from
`src/crypto_kem/kyber/kyber768/amd64/ref/kem.jazz`.


### Running tests
<!-- Summary of prerequesites for running tests -->

The current prerequisites for running tests in Libjade are:
* Jasmin compiler (`jasminc`) in your `PATH`;
* C compiler (gcc or clang);
* GNU make;
* Valgrind;
* Bash.

Note 1: our tests are run under Linux-based OS (Debian). We are currently updating them to be
macOS-compatible.

Note 2: some Libjade AMD64 implementations require specific CPU extensions, such as BMI1 or AVX2.
Whenever such extensions are not available, some tests will fail. As such, and to run all tests
successfully, there is the requirement that the CPU must support all extensions used throughout
Libjade. Any modern Intel CPU supports those. Some AMD CPUs do not. We plan to integrate run-time
detection of CPU extensions in our building system to improve on this. We also plan to make
available a list of required CPU extensions for each implementation. This will likely happen when
implementations for architectures different than AMD64 are developed/integrated into Libjade.

#### Tests in Libjade

<!-- Explanation about what tests there are and what they do -->

Running `cd test/ && make` performs the following tests, in no particular order, for all
implementations:

* `checksums`: implements SUPERCOP tests, which, briefly: 1) check for out-of-bounds memory writes;
2) how the implementation behaves when pointers overlap (e.g., input pointer is equal to output
pointer); 3) functionality (e.g., decryption after encryption recovers the original plaintext);
4) check if the function produces the same outputs given the same inputs; and 5) `~`correctness:
computes a checksum of the functions' outputs to be compared with the expected checksum. In these
tests, pseudo-random inputs are given to the functions as arguments, and `randombytes` is replaced
by a deterministic function. We also consider two checksum values: `checksumsmall` and `checksumbig`.
The difference is the number of test iterations (`checksumbig` has more test iterations and,
consequently, takes more CPU time). The original idea is to avoid running `checksumbig` if
`checksumsmall` fails. On our deployment, there is no dependency between `checksumsmall` and
`checksumbig`, and both are evaluated (for `make all` kind of targets) given that it simplifies
day-to-day development tasks and the Makefile design (developer does need to wait for `checksumsmall`
to finish if it only intends to run `checksumbig`. The expected checksum values are on META.yml
files under the source (src/) directory. We use values that can be found (or computed, if not
available) with the SUPERCOP framework;

* `memory`: the executables produced in the context of these tests are mainly valuable to run with
Valgrind, primarily to detect out-of-bounds reads on the argument pointers (and even some
out-of-bound writes that checksum is not able to identify given that, and for practical reasons, the
size of canaries must be kept reasonably small -- in this context, a canary is a small pattern
copied before and after a memory region to detect out-of-bound memory writes). For operations which
process data of arbitrary length, for instance, a stream cipher whose plaintext length is only known
during runtime, we test for lengths from 0 to 4096 (this value is easily adjusted).

* `functest`: defines a simple sequence of calls to the functions of a given cryptographic operation
to demonstrate how these can be used. Code from these test files is included in the release as
`example.c`. For instance, in the case of Kyber, a primitive of the operation `crypto_kem`, first
calls `keypair`, to create a public and a secret key and then `enc`(apsulate) and `dec`(apsulate)
to show how to obtain/recover a shared secret;

* `printparams`: tests if the expected macros for a given API are well defined in their
correspondent `api.h` file.

The source code for each test can be found under `libjade/test/crypto_*/`. For example, under
`libjade/test/crypto_kem/`, the following files are present: `checksums.c`, `functest.c`, `memory.c`,
and `printparams.c`. A deterministic version or `randombytes` (necessary for nondeterministic
functions to compute the same checksum on every execution) can be found under `libjade/test/common`.
Under this same directory, there are also some files with utility code to, for example, handle
printing and opening files.

#### Running all tests for all implementations in Libjade

As unveiled previously, running `cd test/ && make` runs all tests. More precisely, the `default`
target is equivalent to running the following 4 commands:

```
make CI=1 -C ../src/ all
make CI=1 all
make CI=1 reporter
make CI=1 err
```

`CI` is a variable that stands for Continuous Integration. When `CI` is set to 1, all the
compilation and execution outputs and return errors are recorded for later inspection. Some log
files are under `.ci/` (hidden) directories. Additionally, if the compilation or execution of a
given target returns an error (a segmentation fault, for instance), `make` continues to execute
until there are no more tasks. On a system with 8 cores available, running `make -j8` will use
those cores as well as `make -j$(nproc)`. Running `make` should take 10 to 13 minutes on a
reasonably recent CPU when using all the available CPU power.

* `make CI=1 -C ../src/ all` builds all assembly files under `src/`;

* `make CI=1 all` follows each `*.jazz` file under `src/` and compiles and runs the tests (for
instance, `checksumbig`, `checksumsmall`, or `memory`) using the same directory structure that
exists in `src/`, but under `test/bin`. After running `make CI=1 all` the binaries and outputs
corresponding to, for instance, `src/crypto_kem/kyber/kyber768/amd64/ref/kem.jazz` will be built
under `test/bin/crypto_kem/kyber/kyber768/amd64/ref/` and, under normal conditions,
`cat test/bin/crypto_kem/kyber/kyber768/amd64/ref/checksumbig.out && echo` should show the
`checksumbig` value that is present in `src/crypto_kem/kyber/kyber768/META.yml`;

* `make CI=1 reporter` prints information about the tests: compilation and execution. To check if
the checksums match with the ones specified in `META.yml` files, the script `scripts/checksumsok` is
used;

* `make CI=1 err` returns an error if there are any `*.error` files under `test/bin`. These files
contain the output from the `stderr` and the return code of the job that failed.


#### Running select tests
<!-- TODO: write this -->


### Reproducing functional-correctness proofs

<!-- 
### Reproducing security proofs
TODO: write this -->

<!-- 
### Libjade coding guidelines

#### Code organization
TODO: Explain require structure and use of common directories

#### Naming conventions
TODO: write this 

-->



[^libsodium]: https://doc.libsodium.org
[^nacl]: https://nacl.cr.yp.to
[^kyber]: https://pq-crystals.org/kyber
[^sslh-paper]: Basavesh Ammanaghatta Shivakumar, Gilles Barthe, Benjamin Grégoire, Vincent Laporte, Tiago Oliveira, Swarn Priya, Peter Schwabe, and Lucas Tabary-Maujean. 
  *Typing High-Speed Cryptography against Spectre v1*. IEEE S&P 2023. [IACR ePrint 2022/1270](https://eprint.iacr.org/2022/1270).
[^spx]: https://sphincs.org


