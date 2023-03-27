all: scalar avx avx2

scalar : test_scalar.c aead_scalar.s
	gcc -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	-Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	-fstrict-aliasing -fno-common -pipe -g test_scalar.c aead_scalar.s -o test_scalar

avx : test_scalar.c aead_avx.s
	gcc -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	-Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	-fstrict-aliasing -fno-common -pipe -g test_avx.c aead_avx.s -o test_avx

avx2 : test_avx2.c aead_avx2.s
	gcc -O3 -Wall -Wextra -Wpedantic -Wvla -Werror -std=c99 \
	-Wundef -Wshadow -Wcast-align -Wpointer-arith -Wmissing-prototypes \
	-fstrict-aliasing -fno-common -pipe -g test_avx2.c aead_avx2.s -o test_avx2