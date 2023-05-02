# Libjade API documentation

The API documentation is currently still work in progress. So far, only the API documentation
for `crypto_kem` is complete. Some general remarks that apply to the APIs for all functionalities:
* All memory regions provided to API functions through pointers are assumed to not overlap.
* For all writable memory regions that provided to API functions through pointers, the caller
  needs to ensure that no other thread has read or write access.
* For all read-only memory regions that provided to API functions through pointers, the caller
  needs to ensure that no other thread has read access.
* Libjade functions do not require any alignment of pointers provided to API functions.

## `crypto_kem` API

<details>

<summary>Detailed documentation</summary>
  
<!--
TODO: Where do we explain functional guarantees (and corresponding requirements on the caller)?
-->

### Overview of functions and constants 

Each implementation in the `crypto_kem` subdirectory defines in its header file five functions:

```
int jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand(
  uint8_t *public_key,
  uint8_t *secret_key,
  const uint8_t * coins
);

int jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair(
  uint8_t *public_key,
  uint8_t *secret_key
);

int jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc_derand(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key,
  const uint8_t *coins
);

int jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc(
  uint8_t *ciphertext,
  uint8_t *shared_secret,
  const uint8_t *public_key
);

int jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_dec(
  uint8_t *shared_secret,
  const uint8_t *ciphertext,
  const uint8_t *secret_key
);
```
where `FAMILY` is replaced by an (all-lowercase) name of the function family,
`ALGORITHM` is replaced by an (all-lowercase) name of the specific member of the function family,
`ARCH` is replaced by an (all-lowercase) name of the target architecture, and
`IMPL` is replaced by an (all-lowercase) name of the implementation.
For example, for the reference implementation of Kyber768 targeting the AMD64 architecture,
the five function names are
`jade_kem_kyber_kyber768_amd64_ref_keypair_derand`,
`jade_kem_kyber_kyber768_amd64_ref_keypair`,
`jade_kem_kyber_kyber768_amd64_ref_enc_derand`,
`jade_kem_kyber_kyber768_amd64_ref_enc`, and
`jade_kem_kyber_kyber768_amd64_ref_dec`.

Additionally, the header file defines six compile-time constants
(through `#define`):
```
JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_SECRETKEYBYTES
JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES
JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_CIPHERTEXTBYTES
JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_KEYPAIRCOINBYTES
JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_ENCCOINBYTES
JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES
```
where `FAMILY`, `ALGORITHM`, `ARCH`, and `IMPL` are substituted as in the function names.
So, for example, for the reference implementation of Kyber768 targeting the AMD64 architecture,
the six constants names are 
`JADE_KEM_kyber_kyber768_amd64_ref_SECRETKEYBYTES`,
`JADE_KEM_kyber_kyber768_amd64_ref_PUBLICKEYBYTES`,
`JADE_KEM_kyber_kyber768_amd64_ref_CIPHERTEXTBYTES`,
`JADE_KEM_kyber_kyber768_amd64_ref_KEYPAIRCOINBYTES`,
`JADE_KEM_kyber_kyber768_amd64_ref_ENCCOINBYTES`, and
`JADE_KEM_kyber_kyber768_amd64_ref_BYTES`.


### Contract for `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand`

#### Caller's reponsibility:
* The caller must ensure that `public_key` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES` bytes.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `secret_key` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_SECRETKEYBYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `public_key`.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `coins` is a pointer pointing to a memory region containing `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_KEYPAIRCOINBYTES` random bytes
  generated from a cryptographically secure randomness source. 
  The memory region must not be overlapping with the region pointed to by `public_key` and 
  it must not be overlapping with the region pointed to by `secret_key`.
  No other thread must have write access to this memory region.

#### Guaranteed properties:
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES` to the memory region pointed to
  by `public_key`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_SECRETKEYBYTES` to the memory region pointed to
  by `secret_key`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand` will not write to the memory region pointed to by `coins`.

#### Additional requirements:
None.

<!--
#### Formalization of this contract in EasyCrypt
```
TODO: enter EasyCrypt code here
```
-->


### Contract for `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair`
#### Caller's reponsibility:
* The caller must ensure that `public_key` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES` bytes.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `secret_key` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_SECRETKEYBYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `public_key`.
  No other thread must have read or write access to this memory region.

#### Guaranteed properties:
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES` to the memory region pointed to
  by `public_key`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_keypair_derand` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_SECRETKEYBYTES` to the memory region pointed to
  by `secret_key`; i.e., after the function returns, this memory region is initialized.

#### Additional requirements:
At linking time, the build system has to provide a function `randombytes(uint8_t* _x, uint64_t xlen)`. [See below](#dependency-on-randombytes) 
for more information about this dependency on `randombytes`.

<!--
#### Formalization of this contract in EasyCrypt
```
TODO: enter EasyCrypt code here
```
-->


### Contract for `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc_derand`
#### Caller's reponsibility:
* The caller must ensure that `ciphertext` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_CIPHERTEXTBYTES` bytes.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `shared_secret` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `ciphertext`.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `public_key` is a pointer pointing to an initialized memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `ciphertext` and 
  it must not be overlapping with the region pointed to by `shared_secret`.
  No other thread must have write access to this memory region.
* The caller must ensure that `coins` is a pointer pointing to a memory region containing `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_ENCCOINBYTES` random bytes
  generated from a cryptographically secure randomness source. 
  The memory region must not be overlapping with the region pointed to by `ciphertext`,
  it must not be overlapping with the region pointed to by `shared_secret`, and
  it must not be overlapping with the region pointed to by `public_key`.
  No other thread must have write access to this memory region.

#### Guaranteed properties:
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc_derand` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_CIPHERTEXTKEYBYTES` to the memory region pointed to
  by `ciphertext`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc_derand` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES` to the memory region pointed to
  by `shared_secret`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc_derand` will not write to the memory region pointed to by `public_key`.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc_derand` will not write to the memory region pointed to by `coins`.


#### Additional requirements:
None.

<!--
#### Formalization of this contract in EasyCrypt
```
TODO: enter EasyCrypt code here
```
-->


### Contract for `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc`
#### Caller's reponsibility:
* The caller must ensure that `ciphertext` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_CIPHERTEXTBYTES` bytes.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `shared_secret` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `ciphertext`.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `public_key` is a pointer pointing to an initialized memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_PUBLICKEYBYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `ciphertext` and 
  it must not be overlapping with the region pointed to by `shared_secret`.
  No other thread must have write access to this memory region.

#### Guaranteed properties:
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_CIPHERTEXTKEYBYTES` to the memory region pointed to
  by `ciphertext`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES` to the memory region pointed to
  by `shared_secret`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_enc` will not write to the memory region pointed to by `public_key`.

#### Additional requirements:
At linking time, the build system has to provide a function `randombytes(uint8_t* _x, uint64_t xlen)`. [See below](#dependency-on-randombytes) 
for more information about this dependency on `randombytes`.

<!--
#### Formalization of this contract in EasyCrypt
```
TODO: enter EasyCrypt code here
```
-->


### Contract for `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_dec`
#### Caller's reponsibility:
* The caller must ensure that `shared_secret` is a pointer pointing to an allocated memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES` bytes.
  No other thread must have read or write access to this memory region.
* The caller must ensure that `ciphertext` is a pointer pointing to an initialized memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_CIPHERTEXTBYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `shared_secret`.
  No other thread must have write access to this memory region.
* The caller must ensure that `secret_key` is a pointer pointing to an initialized memory region of length `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_SECRETKEYBYTES` bytes.
  This memory region must not be overlapping with the memory region pointed to by `shared_secret` and 
  it must not be overlapping with the region pointed to by `ciphertext`.
  No other thread must have write access to this memory region.

#### Guaranteed properties:
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_dec` will write exactly `JADE_KEM_FAMILY_ALGORITHM_ARCH_IMPL_BYTES` to the memory region pointed to
  by `shared_secret`; i.e., after the function returns, this memory region is initialized.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_dec` will not write to the memory region pointed to by `ciphertext`.
* The function `jade_kem_FAMILY_ALGORITHM_ARCH_IMPL_dec` will not write to the memory region pointed to by `secret_key`.

#### Additional requirements:
None.

<!--
#### Formalization of this contract in EasyCrypt
```
TODO: enter EasyCrypt code here
```
-->

</details>


## `crypto_sign` API

<details>

<summary>Detailed documentation</summary>

</details>


## Dependency on `randombytes`

<details>

<summary>Detailed documentation</summary>

</details>


