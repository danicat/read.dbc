dbc2dbf: src/dbc2dbf.c src/blast.c src/blast.h
	cc -DCMD_LINE -static -o dbc2dbf blast.c dbc2dbf.c

shared: src/dbc2dbf.c src/blast.c src/blast.h
	MAKEFLAGS="SHLIB_CFLAGS=-DSHARED_LIBRARY" R CMD SHLIB src/dbc2dbf.c src/blast.c -o dbc2dbf.so

test: dbc2dbf
	./dbc2dbf < tests/test.pk | cmp - tests/test.txt

clean:
	rm -f dbc2dbf *.o *.so *.html
