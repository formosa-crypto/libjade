.PHONY: test0 clean

test0:
	jasminc -o notrandombytes.s ../../../../src/common/amd64/notrandombytes.jazz
	gcc -Wall -o test0 -I../../../common2/ test0.c notrandombytes.s ../../../common1/notrandombytes.c

clean:
	rm -f *.s test0
