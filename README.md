# libjade

A formally verified cryptographic library written in 
[the jasmin programming language](https://github.com/jasmin-lang/jasmin)
with computer-verified proofs in [EasyCrypt](https://github.com/EasyCrypt/easycrypt);
libjade is part of the [Formosa-Crypto](https://formosa-crypto.org) project.

## Overview of cryptographic primitives in Libjade

At the moment, libjade only targets the AMD64 (aka x86\_64 or x64) architecture.
Supporting multiple architectures is on [our TODO list](#future-plans). 
The following primitives are currently supported by Libjade

### Symmetric primitives

#### Cryptographic hash functions (`crypto_hash`)
* SHA-256
* SHA-512
* SHA3-224
* SHA3-256
* SHA3-384
* SHA3-512

#### Extendable output functions (XOFs, `crypto_xof`)
* SHAKE-128
* SHAKE-256

#### One-time authenticators (`crypto_onetimeauth`)
* Poly1305

#### Stream ciphers (`crypto_stream`)
* ChaCha12
* ChaCha20
* Salsa20
* XSalsa20

#### Authenticated encryption (`crypto_secretbox`)
* XSalsa20Poly1305

### Asymmetric primitives

#### Scalar multiplication (`crypto_scalarmult`)
* Curve25519

#### Key-encapsulation mechanisms (KEMs, `crypto_kem`)
* Kyber-512
* Kyber-768

#### Signatures (`crypto_sign`)
* Dilithium-XXX


## Build instructions

### Installing nix
Installation of libjade requires the jasmin compiler; 
the recommended way to install the jasmin compiler is via nix. 
If you do not have nix installed on your system, please run
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```
Please also see [the nix installation guide](https://nixos.org/download.html)

### Obtaining and building the jasmin compiler
With nix installed, you are ready to obtain and build the jasmin compiler:
```
git clone https://github.com/jasmin-lang/jasmin.git
cd jasmin
git fetch -a
git checkout main
nix-channel --update
nix-shell 
```
Then, inside `nix-shell`, run
```
cd compiler
make CIL
make
make check
exit
```
Now you should have a working compiler binary called `jasminc` in `jasmin/compiler/`.
We recommend adding this directory to your `$PATH` variable; the instructions in the
following assume that `jasminc` is available in a directory that is in `$PATH`.

## API documentation

## Security guarantees

### Properties guaranteed by jasmin

#### Memory safety

#### Timing attack protection

#### Protection against Spectre v1

#### Protection against Spectre v4

#### Stack cleanup

### Properties proven in EasyCrypt

TODO: write this.
Explain how to read what has been proven for each scheme

## Future plans

* Add more primitives; currently work in progress are
  - [Dilithium](https://pq-crystals.org/dilithium/),
  - [Sike](https://sike.org/), and
  - [SPHINCS+](https://sphincs.org).
* Complete missing EasyCrypt proofs.
* Support for Windows
* Support multiple architectures, most importantly 32-bit and 64-bit Arm and RISCV CPUs.
* Add interfaces to other languages (e.g., [Rust](https://www.rust-lang.org/) and [Go](https://go.dev/)).
* Implement a libjade-agent that wraps libjade crypto functionality in a separate process.

## License
TODO: Agree on license and update information here
