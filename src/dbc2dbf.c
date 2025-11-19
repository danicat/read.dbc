/* dbc2dbf.c
   Copyright (C) 2016 Daniela Petruzalek

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
#include <errno.h>
#include <string.h>
#include <stdint.h>
#include <stdarg.h>
#include <R.h>

#include "blast.h"

#define CHUNK 4096
#define MAX_ERR 255

/* Thread-safe context for input operations */
struct input_context {
    FILE *fp;
    unsigned char buffer[CHUNK];
};

/* Input file helper function */
static unsigned inf(void *how, unsigned char **buf)
{
    struct input_context *ctx = (struct input_context *)how;
    *buf = ctx->buffer;
    return fread(ctx->buffer, 1, CHUNK, ctx->fp);
}

/* Output file helper function */
static int outf(void *how, unsigned char *buf, unsigned len)
{
    return fwrite(buf, 1, len, (FILE *)how) != len;
}


/* Close open files before exit */
void cleanup(FILE* input, FILE* output) {
    if( input  ) fclose(input);
    if( output ) fclose(output);
}

/* Helper to format error strings */
void set_error(char** error_str, const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);
    vsnprintf(error_str[0], MAX_ERR, fmt, args);
    va_end(args);
    error_str[0][MAX_ERR] = '\0';
}

#define HEADER_OFFSET 8
#define CRC_OFFSET 4
#define MAX_HEADER_SIZE 65535 // 16-bit unsigned integer max

/*
    dbc2dbf(char** input_file, char** output_file)
    This function decompresses a given .dbc input file into the corresponding .dbf.

    Please provide fully qualified names, including file extension.
 */
void dbc2dbf(char** input_file, char** output_file, int* ret_code, char** error_str) {
    FILE          *input = 0, *output = 0;
    int           ret = 0;
    unsigned char rawHeader[2];
    uint16_t      header = 0;

    /* Open input file */
    input  = fopen(input_file[0], "rb");
    if(input == NULL) {
        *ret_code = -1;
        set_error(error_str, "Error opening input file '%s': %s", input_file[0], strerror(errno));
        return;
    }

    /* Open output file */
    output = fopen(output_file[0], "wb");
    if(output == NULL) {
        cleanup(input, output);
        *ret_code = -2;
        set_error(error_str, "Error creating output file '%s': %s", output_file[0], strerror(errno));
        return;
    }

    /* Process file header - skip 8 bytes */
    if( fseek(input, HEADER_OFFSET, SEEK_SET) ) {
        cleanup(input, output);
        *ret_code = -3;
        set_error(error_str, "Error seeking input file header '%s': %s", input_file[0], strerror(errno));
        return;
    }

    /* Reads two bytes from the header = header size */
    ret = fread(rawHeader, 2, 1, input);
    if( ret != 1 || ferror(input) ) {
        cleanup(input, output);
        *ret_code = -4;
        set_error(error_str, "Error reading header size from '%s': %s", input_file[0], ferror(input) ? strerror(errno) : "Short read/Unexpected EOF");
        return;
    }

    /* Platform independent code (header is stored in little endian format) */
    header = rawHeader[0] + (rawHeader[1] << 8);
    
    /* Reset file pointer */
    rewind(input);

    /* Copy file header from input to output */
    unsigned char *buf = (unsigned char *)malloc(header);
    if (buf == NULL) {
        cleanup(input, output);
        *ret_code = -9; // New error code for memory allocation failure
        set_error(error_str, "Memory allocation failed for header (%d bytes)", header);
        return;
    }

    ret = fread(buf, 1, header, input);
    if( ret != header || ferror(input) ) {
        free(buf);
        cleanup(input, output);
        *ret_code = -5;
        set_error(error_str, "Error reading header content from '%s': %s", input_file[0], ferror(input) ? strerror(errno) : "Short read/Unexpected EOF");
        return;
    }

    ret = fwrite(buf, 1, header, output);
    if( ret != header || ferror(output) ) {
        free(buf);
        cleanup(input, output);
        *ret_code = -6;
        set_error(error_str, "Error writing header to '%s': %s", output_file[0], ferror(output) ? strerror(errno) : "Short write/Disk full?");
        return;
    }

    free(buf); // Don't forget to free the memory!

    /* Jump to the data (Skip CRC32) */
    if( fseek(input, header + CRC_OFFSET, SEEK_SET) ) {
        cleanup(input, output);
        *ret_code = -7;
        set_error(error_str, "Error seeking to compressed data in '%s': %s", input_file[0], strerror(errno));
        return;
    }

    /* decompress */
    struct input_context ctx;
    ctx.fp = input;
    ret = blast(inf, &ctx, outf, output);
    if( ret ) {
        cleanup(input, output);
        *ret_code = ret;
        const char *msg = "Unknown decompression error";
        switch (ret) {
            case 2: msg = "Ran out of input before completing decompression"; break;
            case 1: msg = "Output error before completing decompression"; break;
            case -1: msg = "Literal flag not zero or one (invalid format)"; break;
            case -2: msg = "Dictionary size not in 4..6 (invalid format)"; break;
            case -3: msg = "Distance is too far back (invalid format)"; break;
        }
        set_error(error_str, "Decompression failed: %s", msg);
        return;
    }

    /* see if there are any leftover bytes */
    int n = 0;
    while (fgetc(input) != EOF) n++;
    if (n) {
        cleanup(input, output);
        *ret_code = -8;
        set_error(error_str, "Decompression warning: %d unused bytes of input found", n);
        return;
    }

    cleanup(input, output);
    *ret_code = 0;
}
