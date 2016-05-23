dbc2dbf: dbc2dbf.c blast.c blast.h
	cc -DCMD_LINE -static -o dbc2dbf blast.c dbc2dbf.c

shared: dbc2dbf.c blast.c blast.h
	MAKEFLAGS="SHLIB_CFLAGS=-DSHARED_LIBRARY" R CMD SHLIB dbc2dbf.c blast.c

showme:
	R CMD SHLIB -n dbc2dbf.c blast.c

test: dbc2dbf
	./dbc2dbf < test.pk | cmp - test.txt

clean:
	rm -f dbc2dbf *.o *.so

#install: shared
# TODO:
#	R CMD INSTALL

