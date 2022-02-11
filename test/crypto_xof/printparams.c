#include <stdio.h>
#include "api.h"
#include "namespace.h"

int main() {
    printf("{\n");
    printf("\t\"CRYPTO_ALGNAME\": \"%s\"\n}\n", NAMESPACE(ALGNAME));
}
