#ifndef JADE_KEM_API_H
#define JADE_KEM_API_H

#include "namespace.h"

#define JADE_KEM_SECRETKEYBYTES NAMESPACE(SECRETKEYBYTES)
#define JADE_KEM_PUBLICKEYBYTES NAMESPACE(PUBLICKEYBYTES)
#define JADE_KEM_CIPHERTEXTBYTES NAMESPACE(CIPHERTEXTBYTES)
#define JADE_KEM_KEYPAIRCOINBYTES NAMESPACE(KEYPAIRCOINBYTES)
#define JADE_KEM_ENCCOINBYTES NAMESPACE(ENCCOINBYTES)
#define JADE_KEM_BYTES NAMESPACE(BYTES)

#define jade_kem_keypair NAMESPACE_LC(keypair)
#define jade_kem_enc NAMESPACE_LC(enc)
#define jade_kem_dec NAMESPACE_LC(dec)

#define jade_kem_keypair_derand NAMESPACE_LC(keypair_derand)
#define jade_kem_enc_derand NAMESPACE_LC(enc_derand)

#define jade_xkem_keypair NAMESPACE_LC(keypair)
#define jade_xkem_enc NAMESPACE_LC(enc)
#define jade_xkem_dec NAMESPACE_LC(dec)

#define jade_xkem_keypair_derand NAMESPACE_LC(keypair_derand)
#define jade_xkem_enc_derand NAMESPACE_LC(enc_derand)

#define JADE_KEM_ALGNAME NAMESPACE(ALGNAME)
#define JADE_KEM_ARCH NAMESPACE(ARCH)
#define JADE_KEM_IMPL NAMESPACE(IMPL)

#endif

