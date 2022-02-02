#include <stdio.h>
#include "api.h"
#include "namespace.h"

int main() {
    printf("{\n");
    printf("\t\"CRYPTO_BYTES\": %u,\n", NAMESPACE(BYTES));
    printf("\t\"CRYPTO_KEYBYTES\": %u,\n", NAMESPACE(KEYBYTES));
    printf("\t\"CRYPTO_ALGNAME\": \"%s\"\n}\n", NAMESPACE(ALGNAME));
}
