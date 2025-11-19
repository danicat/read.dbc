/* dbf2dbc.c
 * Copyright (C) 2025 Daniela Petruzalek
 * For conditions of distribution and use, see copyright notice in read.dbc.R
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <R.h>
#include <Rinternals.h>
#include "implode.h"

#define CHUNK 4096

struct io_state {
    FILE *f;
    unsigned char buf[CHUNK];
};

static unsigned read_file(void *how, unsigned char **buf) {
    struct io_state *state = (struct io_state *)how;
    *buf = state->buf;
    return fread(state->buf, 1, CHUNK, state->f);
}

static int write_file(void *how, unsigned char *buf, unsigned len) {
    struct io_state *state = (struct io_state *)how;
    return fwrite(buf, 1, len, state->f) != len;
}

SEXP dbf2dbc(SEXP input, SEXP output) {
    const char *infile = CHAR(STRING_ELT(input, 0));
    const char *outfile = CHAR(STRING_ELT(output, 0));
    struct io_state in = {0}, out = {0};
    int ret;
    SEXP result;

    in.f = fopen(infile, "rb");
    if (!in.f) {
        error("Could not open input file %s", infile);
    }

    out.f = fopen(outfile, "wb");
    if (!out.f) {
        fclose(in.f);
        error("Could not open output file %s", outfile);
    }

    /* Read DBF Header Size */
    unsigned char header_bytes[2];
    if (fseek(in.f, 8, SEEK_SET) || fread(header_bytes, 1, 2, in.f) != 2) {
        fclose(in.f);
        fclose(out.f);
        error("Could not read DBF header size from %s", infile);
    }
    
    uint16_t header_size = header_bytes[0] | (header_bytes[1] << 8);
    
    /* Copy Uncompressed Header */
    rewind(in.f);
    unsigned char *hdr_buf = (unsigned char *)malloc(header_size);
    if (!hdr_buf) {
        fclose(in.f);
        fclose(out.f);
        error("Memory allocation failed");
    }
    
    if (fread(hdr_buf, 1, header_size, in.f) != header_size) {
        free(hdr_buf);
        fclose(in.f);
        fclose(out.f);
        error("Failed to read DBF header");
    }
    
    if (fwrite(hdr_buf, 1, header_size, out.f) != header_size) {
        free(hdr_buf);
        fclose(in.f);
        fclose(out.f);
        error("Failed to write DBC header");
    }
    free(hdr_buf);
    
    /* Write Padding (CRC/Trash) - 4 bytes */
    unsigned char padding[4] = {0, 0, 0, 0};
    if (fwrite(padding, 1, 4, out.f) != 4) {
        fclose(in.f);
        fclose(out.f);
        error("Failed to write DBC padding");
    }
    
    /* Compress the rest (Records) */
    /* in.f is already at position header_size */
    ret = implode(read_file, &in, write_file, &out);

    fclose(in.f);
    fclose(out.f);

    if (ret != 0) {
        remove(outfile); /* Clean up incomplete file */
        error("Compression failed with error code %d", ret);
    }

    PROTECT(result = allocVector(LGLSXP, 1));
    LOGICAL(result)[0] = 1;
    UNPROTECT(1);
    return result;
}
