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
  
    This code is based on the work of Mark Adler <madler@alumni.caltech.edu>
    and Pablo Fonseca (https://github.com/eaglebh/blast-dbf).
*/

/*
    Author Notes
    ============

    This program decompresses .dbc files to .dbf. It was altered from the original to
    enable it's compilation as a shared library for import within R. I've also fixed
    the command line usage to enable standard input/output redirection.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "blast.h"

#ifndef CMD_LINE
#include <R.h>
#endif /* CMD_LINE */

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

/*  core_dbc2dbf(FILE* input, FILE* output)
    This function handles the processing of input to output given both file descriptors.
    I've isolated this code to be able to conditional compile the both the shell version and
    the shared library object (for use within R).
 */
int core_dbc2dbf(FILE* input, FILE* output) {
    int     read, err, header, ret, n;

    read = fseek(input, 8, SEEK_SET);
    err = ferror(input);
    read = fread(&header, 2, 1, input);
    err = ferror(input);

    read = fseek(input, 0, SEEK_SET);
    err = ferror(input);

    unsigned char buf[header];

    read = fread(buf, 1, header, input);
    err = ferror(input);
    read = fwrite(buf, 1, header, output);
    err = ferror(output);

    read = fseek(input, header + 4, SEEK_SET);
    err = ferror(input);

    /* decompress */
    ret = blast(inf, input, outf, output);
    if (ret != 0) fprintf(stderr, "blast error: %d\n", ret);

    /* see if there are any leftover bytes */
    n = 0;
    while (fgetc(input) != EOF) n++;
    if (n) fprintf(stderr, "blast warning: %d unused bytes of input\n", n);

    // return code from blast()
    return ret;
}

#ifndef CMD_LINE

/* Function to be called from R */
void dbc2dbf(char** input_file, char** output_file) {
    int ret;
    FILE    *input, *output;

    input  = fopen(input_file[0], "rb");
    output = fopen(output_file[0], "wb");

    ret = core_dbc2dbf(input, output);
    if( ret ) error("blast error code: %d", ret);

    fclose(input);
    fclose(output);
}

#else /* Not shared library, it's command line*/

/* Print program usage */
void help(char* prog_name){
    fprintf(stderr, "Syntax error!\n");
    fprintf(stderr, "\tUsage: %s input.dbc output.dbf\n", prog_name);
}

/* The command line version of the dbc2dbf converter */
int main(int argc, char **argv)
{
    int ret;
    FILE* input, *output;

    if(argc == 3){
        input = fopen(argv[1], "rb");
        output = fopen(argv[2], "wb");
    }
    /* if stdin is a terminal, it was expecting file names */
    else if( isatty(STDIN_FILENO) ) {
        help(argv[0]);
        exit(1);
    }
    /* not a terminal,the stdin is being redirected */
    else
    {
        input  = stdin;
        output = stdout;
    }

    ret = core_dbc2dbf(input, output);

    fclose(input);
    fclose(output);

    /* return blast() error code */
    return ret;
}

#endif /* #ifndef CMD_LINE */

