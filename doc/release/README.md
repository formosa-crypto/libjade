# Libjade

<!-- If you want to read me online, use the following link: https://github.com/formosa-crypto/libjade/blob/main/doc/release/README.md -->

## Quick Overview

In folder `libjade` you can find the compiled (AT&T assembly syntax) Jasmin implementations of [libjade](https://github.com/formosa-crypto/libjade) for the amd64 architecture and System V ABI (Linux, macOS, or Unix in general).

We also provide quick-to-use examples that should be easy to compile, inspect, and change to explore the API if you want to. Next, we briefly overview the contents of this distribution package. Later we detail the API of the available Jasmin cryptographic operations in libjade.

Implementations are organized by cryptographic operations. For instance, in folder `libjade/crypto_kem/` you can find Kyber implementations and in `libjade/crypto_sign` Dilithium implementations.

In some folders under `libjade` there are:
* `*.jazz` : Jasmin files
* `*.s` : assembly files
* `*.h` : header files
* `Makefile`

As an example, in `libjade/crypto_kem/kyber` you can find the following 3 files:

* `kyber768_amd64_avx2.jazz`
* `kyber768_amd64_avx2.s`
* `kyber768_amd64_avx2.h`

`kyber768_amd64_avx2.jazz` contains an implementation of Kyber768. `kyber768_amd64_avx2.s` is the result of compiling `kyber768_amd64_avx2.jazz` with the Jasmin compiler version 2022.09.0 &mdash; for more information about installing the Jasmin compiler to compile the Jasmin files yourself check section [Compiling Jasmin code yourself](#compiling-jasmin-code-yourself). `kyber768_amd64_avx2.h` defines the functions prototypes and macros that specify, for instance, the length in bytes of public and secret keys:

```
#ifndef JADE_KEM_KYBER_KYBER768_AMD64_AVX2_API_H
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_API_H

#include <stdint.h>

#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_SECRETKEYBYTES  2400
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_PUBLICKEYBYTES  1184
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_CIPHERTEXTBYTES 1088
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_BYTES           32

#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_ALGNAME         "Kyber768"
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_ARCH            "amd64"
#define JADE_KEM_KYBER_KYBER768_AMD64_AVX2_IMPL            "avx2"

int jade_kem_kyber_kyber768_amd64_avx2_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_kem_kyber_kyber768_amd64_avx2_enc(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key
);

int jade_kem_kyber_kyber768_amd64_avx2_dec(
  uint8_t *shared_secret,
  const uint8_t *ciphertext,
  const uint8_t *secret_key
);

#endif
```

The `kem` operation defines 3 functions: `keypair`, `enc`, and `dec`. `keypair` or, in the shown example, `jade_kem_kyber_kyber768_amd64_avx2_keypair`, generates a public and a secret key with `PUBLICKEYBYTES` and `SECRETKEYBYTES`, respectively. `enc` generates a shared secret and the corresponding encryption, with `BYTES` and `CIPHERTEXTBYTES`, respectively, given a public_key. `dec` decrypts the ciphertext to recover the shared secret given a secret key. 

The `examples` folder contains easy-to-compile-and-run examples in C. To compile and run a simple program that executes the code defined in `libjade/crypto_kem/kyber/kyber768_amd64_avx2.s`:

```
$ cd examples/crypto_kem/kyber
$ make jade_kem_kyber_kyber768_amd64_avx2
$ ./jade_kem_kyber_kyber768_amd64_avx2
```

This program prints to the terminal the generated key pair, the shared secret, and the ciphertext after calling all 3 functions. The C code performs these calls under `examples/common/jade_kem.c`. File `examples/crypto_kem/kyber/kyber768_amd64_avx2.c` includes the corresponding header, in this case, `kyber768_amd64_avx2.h`, and the *generic* code from `common`, `jade_kem.c`. The same happens for all implementations.

As another simple-to-run example, you can try the following:
```
$ cd examples/crypto_hash/
$ make jade_hash_sha256_amd64_ref
$ ./jade_hash_sha256_amd64_ref
$ echo -n "abc" | sha256sum
```

Feel free to perform your own experiments and provide feedback.

## Compiling Jasmin code yourself.

We release single-file-Jasmin-implementations for users who wish to (quickly) recompile the assembly files and/or get acquainted with Jasmin programming language and/or want to do some experiments. If you visit the [libjade](https://github.com/formosa-crypto/libjade/) GitHub repository, you may find that the source code is organized differently, mainly to promote code reusability. In this context, we are interested in easy reproducibility.

To compile the available Jasmin files (`.jazz`), you need to get the Jasmin compiler (jasminc should be available in your PATH, or you can set a variable named JASMIN with the path to your compiler).

To get Jasmin, you can check the following instructions:
* https://github.com/jasmin-lang/jasmin/wiki/Installation-instructions
* https://github.com/formosa-crypto/libjade/blob/main/README.md#obtaining-and-building-the-jasmin-compiler

To recompile Kyber768 AVX2 implementation, run the following:
```
$ cd libjade/crypto_kem/kyber
$ touch kyber768_amd64_avx2.jazz
$ make kyber768_amd64_avx2.s
```

The `touch` might be needed to avoid `make: 'kyber768_amd64_avx2.s' is up to date.`.

