# The DBC File Format

**Author**: Daniela Petruzalek
**Date**: 2025-11-19

# Overview

The `.dbc` file format is a proprietary compression format used by the Brazilian Ministry of Health (DATASUS) for distributing public healthcare datasets. While often confused with FoxPro `.dbc` (Database Container) files, the DATASUS DBC format is actually a compressed version of a standard DBF (dBase) file.

This document details the internal structure of the DBC format and the compression algorithm used, as reverse-engineered during the development of the `read.dbc` package.

# File Structure

A `.dbc` file acts as a container for a single `.dbf` file. Its structure consists of a header followed by a compressed data stream.

| Offset | Size (Bytes) | Description |
|:-------|:-------------|:------------|
| 0      | 8            | **File Signature / Magic Bytes**: Often contains specific ASCII strings or markers, but `read.dbc` currently ignores these first 8 bytes. |
| 8      | 2            | **DBF Header Size**: A 16-bit unsigned integer (Little Endian) representing the size of the *original* DBF header. Let this value be `H`. |
| 10     | `H`          | **Uncompressed DBF Header**: The first `H` bytes of the original `.dbf` file are stored here **uncompressed**. This allows readers to inspect the schema without full decompression. |
| 10 + `H`| 4           | **Padding / Checksum**: 4 bytes, usually skipped or treated as padding. |
| 14 + `H`| Variable    | **Compressed Data**: The PKWare DCL compressed stream containing the rest of the DBF file (the records). |

# Compression Algorithm

The compression algorithm is the **PKWare Data Compression Library (DCL) Implode** algorithm. This is an older algorithm based on LZ77 and Shannon-Fano/Huffman coding, distinct from the "Deflate" algorithm used in ZIP files.

## Algorithm Parameters

The DCL Implode format supports various parameters. DATASUS DBC files typically use:

*   **Literals**: Uncoded (Type 0) or Coded (Type 1).
*   **Dictionary Size**: 4096 bytes (Type 6).

## Bit Stream Encoding

The most critical and unusual aspect of the DBC implementation of DCL Implode is the bit ordering:

1.  **Canonical Huffman Codes**: Symbols are assigned codes based on standard canonical Huffman rules (sorted by bit length, then symbol value).
2.  **Inversion**: The canonical code values are **bitwise inverted** (`~code`).
3.  **Bit Reversal**: The bits of the inverted code are **reversed** (MSB becomes LSB) before being written to the stream.
4.  **Stream Order**: Bits are written to the byte stream starting from the Least Significant Bit (LSB).

This specific combination (Canonical -> Invert -> Reverse) is required to match the decompression logic expected by the `blast` (PKWare DCL decompressor) implementation.

## Sliding Window

The compression uses a standard LZ77 sliding window:

*   **Window Size**: 4096 bytes.
*   **History**: Matches can reference data up to 4096 bytes back in the uncompressed stream.
*   **Constraint**: Distances cannot refer to positions before the start of the output stream (during the first 4096 bytes).

# Implementation Details

The `read.dbc` package implements both decompression (via `blast`) and compression (via `implode`).

*   **`src/blast.c`**: Handles decompression. Modified for thread safety (no static state) and R compatibility.
*   **`src/implode.c`**: Handles compression. Implements the bit-inversion and sliding window logic described above.
*   **`src/dbf2dbc.c`**: A wrapper that constructs the DBC file header (reading the DBF header size) and invokes `implode` for the record data.

# References

*   **PKWare DCL**: The original library.
*   **zlib/contrib/blast**: Mark Adler's open-source decompressor for the PKWare DCL format.
*   **blast-dbf**: An early tool for decompressing DBC files, on which this package was originally based.
