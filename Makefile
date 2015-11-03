dbc2dbf: blast.c blast.h
	cc -DTEST -static -o dbc2dbf blast.c

test: blast
	blast < test.pk | cmp - test.txt

clean:
	rm -f blast blast.o
