#include <stdio.h>
#include "api.h"
#include "namespace.h"

int main() {
    printf("{\n");
    printf("\t\"CRYPTO_SECRETKEYBYTES\": %u,\n", NAMESPACE(SECRETKEYBYTES));
    printf("\t\"CRYPTO_PUBLICKEYBYTES\": %u,\n", NAMESPACE(PUBLICKEYBYTES));
    printf("\t\"CRYPTO_BYTES\": %u,\n",          NAMESPACE(BYTES));
    printf("\t\"CRYPTO_ALGNAME\": \"%s\"\n}\n",  NAMESPACE(ALGNAME));
}
