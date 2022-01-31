#include <stdio.h>
#include "api.h"

#define PASTER(x, y) x##_##y
#define EVALUATOR(x, y) PASTER(x, y)
#define NAMESPACE(fun) EVALUATOR(JADE_NAMESPACE, fun)
#define NAMESPACE_LC(fun) EVALUATOR(JADE_NAMESPACE_LC, fun)

int main() {
    printf("{\n");
    printf("\t\"CRYPTO_NONCEBYTES\": %u,\n", NAMESPACE(NONCEBYTES));
    printf("\t\"CRYPTO_KEYBYTES\": %u,\n", NAMESPACE(KEYBYTES));
    printf("\t\"CRYPTO_ALGNAME\": \"%s\"\n}\n", NAMESPACE(ALGNAME));
}
