# Notes
- C/asm (partial) implementation of Falcon 512
  * sign_open provided by Jasmin

Running make under this directory produces:
- `external_crypto_sign_falcon_falcon512_amd64_avx2.a`
- which should 'export'
  * NAMESPACE(keypair)
  * NAMESPACE(sign)
