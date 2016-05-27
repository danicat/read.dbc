/* dbc2dbf.c

    Copyright (C) 2016 Daniela Petruzalek
    Version 1.0, 22 May 2016

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
*/

/*
    Author Notes
    ============

    This program decompresses .dbc files to .dbf. This code is based on the work
    of Mark Adler <madler@alumni.caltech.edu> (zlib/blast) and Pablo Fonseca 
    (https://github.com/eaglebh/blast-dbf).
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <R.h>

#include "blast.h"

#define CHUNK 4096

/* Input file helper function */
static unsigned inf(void *how, unsigned char **buf)
{
    static unsigned char hold[CHUNK];

    *buf = hold;
    return fread(hold, 1, CHUNK, (FILE *)how);
}

/* Output file helper function */
static int outf(void *how, unsigned char *buf, unsigned len)
{
    return fwrite(buf, 1, len, (FILE *)how) != len;
}

/*  
    dbc2dbf(char** input_file, char** output_file)
    This function decompresses a given .dbc input file into the corresponding .dbf.

    Please provide fully qualified names, including file extension.
 */
void dbc2dbf(char** input_file, char** output_file) {
    FILE    *input, *output;
    int     read, err, header, ret, n;

    /* Open file descriptors */
    input  = fopen(input_file[0], "rb");
    output = fopen(output_file[0], "wb");

    /* Process file header */
    read = fseek(input, 8, SEEK_SET);
    err = ferror(input);
    read = fread(&header, 2, 1, input);
    err = ferror(input);

    read = fseek(input, 0, SEEK_SET);
    err = ferror(input);

    /* Copy file header from input to output */
    unsigned char buf[header];
    read = fread(buf, 1, header, input);
    err = ferror(input);
    read = fwrite(buf, 1, header, output);
    err = ferror(output);

    read = fseek(input, header + 4, SEEK_SET);
    err = ferror(input);

    /* decompress */
    ret = blast(inf, input, outf, output);
    if( ret ) error("blast error code: %d", ret);

    /* see if there are any leftover bytes */
    n = 0;
    while (fgetc(input) != EOF) n++;
    if (n) error("blast warning: %d unused bytes of input\n", n);

    fclose(input);
    fclose(output);
}
