/* dbc2dbf.c
  Copyright (C) 2016 Daniela Petruzalek
  Version 1.0, 22 May 2016

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

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

#ifdef SHARED_LIBRARY
#include <R.h>
#endif /* SHARED_LIBRARY */

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

#ifdef SHARED_LIBRARY

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

#endif /* SHARED_LIBRARY */

