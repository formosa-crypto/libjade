#include <stdio.h>
#include "api.h"
#include "namespace.h"

int main() {
    printf("{\n");
    printf("\t\"CRYPTO_NONCEBYTES\": %u,\n",    NAMESPACE(NONCEBYTES));
    printf("\t\"CRYPTO_KEYBYTES\": %u,\n",      NAMESPACE(KEYBYTES));
    printf("\t\"CRYPTO_ZEROBYTES\": %u,\n",     NAMESPACE(ZEROBYTES));
    printf("\t\"CRYPTO_BOXZEROBYTES\": %u,\n",  NAMESPACE(BOXZEROBYTES));
    printf("\t\"CRYPTO_ALGNAME\": \"%s\"\n}\n", NAMESPACE(ALGNAME));
}

