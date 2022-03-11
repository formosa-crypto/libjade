# libjade

A formally verified cryptographic library written in 
[the jasmin programming language](https://github.com/jasmin-lang/jasmin)
with computer-verified proofs in [EasyCrypt](https://github.com/EasyCrypt/easycrypt);
libjade is part of the [Formosa-Crypto](https://formosa-crypto.org) project.

## Overview of cryptographic primitives in Libjade

At the moment, libjade only targets the AMD64 (aka x86\_64 or x64) architecture.
Supporting multiple architectures is on [our TODO list](#future-plans).

## Build instructions

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
