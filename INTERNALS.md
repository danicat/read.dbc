# Internals: The DBC Format and Algorithms

**Author**: Daniela Petruzalek
**Date**: 2025-11-19

# Introduction

This document serves as a technical specification for the **DBC** file format and the algorithms used in the `read.dbc` package. It is intended for developers who wish to understand the low-level details of the format, how the compression works, or who are looking to port the logic to other languages.

The DBC format is a proprietary compression wrapper around standard DBF (dBase) files, used primarily by the Brazilian Ministry of Health (DATASUS).

# 1. The DBC File Format

A `.dbc` file is essentially a container that holds a single `.dbf` file. The file is split into two main sections: an uncompressed header and a compressed data stream.

## File Layout

| Offset (Hex) | Size (Bytes) | Description |
|:-------------|:-------------|:------------|
| `0x00` | 8 | **Magic / Signature**. Often ignored, but always present. |
| `0x08` | 2 | **Header Size (`H`)**. A 16-bit unsigned integer (Little Endian). This indicates the size of the original DBF header. |
| `0x0A` | `H` | **Uncompressed DBF Header**. The first `H` bytes of the original file are stored here exactly as they appear in the DBF. This allows tools to read the schema (field names, types, record count) without decompressing the entire file. |
| `0x0A + H` | 4 | **Padding**. Typically zero-filled padding bytes. |
| `0x0E + H` | Variable | **Compressed Data Stream**. The remainder of the DBF file (the records) compressed using the PKWare DCL Implode algorithm. |

# 2. The Compression Algorithm ("Implode")

The compression used is a variant of the **PKWARE Data Compression Library (DCL) Implode** algorithm. It combines LZ77 sliding-window compression with Shannon-Fano/Huffman coding.

## Key Characteristics

*   **Algorithm Family**: LZ77 + Huffman.
*   **Dictionary Size (Window)**: 4096 bytes.
*   **Literal Mode**: Binary / Uncoded (Type 0).
*   **Huffman Trees**: **Fixed**. Unlike generic Deflate (ZIP) or some Implode variants where trees are stored in the file, the DBC format uses hardcoded Huffman trees for Lengths and Distances.

## Bit Stream Encoding (The "Magic")

A distinct feature of the DBC implementation—and the source of much confusion for reverse-engineers—is the specific bit manipulation applied to the Huffman codes.

Standard Huffman coding usually writes the code directly or MSB-first. The DBC format uses the following transformation pipeline:

1.  **Canonical Code Generation**: Symbols are assigned codes based on standard canonical Huffman rules (sorted by bit length, then by symbol value).
2.  **Bitwise Inversion**: The resulting code value is bitwise inverted (`~code`).
3.  **Bit Reversal**: The bits of the inverted code are reversed (MSB $\leftrightarrow$ LSB).
4.  **Stream Write**: The resulting bits are written to the byte stream starting from the Least Significant Bit (LSB).

This sequence (Canonical $\rightarrow$ Invert $\rightarrow$ Reverse) is necessary to match the decoding logic expected by the `blast` decompression implementation.

## Fixed Huffman Tables

The format uses fixed tables for encoding match lengths and distances. These are hardcoded in both `src/blast.c` (for reading) and `src/implode.c` (for writing).

### Length Codes (16 codes)
Used to encode the length of a match (sequence of repeated bytes).

| Index | Bits | Description |
|:------|:-----|:------------|
| 0-15 | Variable | Maps to base length + extra bits. |

### Distance Codes (64 codes)
Used to encode the distance (offset) backwards in the sliding window to find the match.

| Index | Bits | Description |
|:------|:-----|:------------|
| 0-63 | Variable | Maps to base distance + extra bits. |

# 3. The Decompression Algorithm ("Blast")

The decompression logic is implemented in `src/blast.c`. It operates as a bit-stream state machine.

## 1. Initialization
*   The fixed Huffman decoding tables are constructed in memory from the hardcoded `lenlen`, `distlen`, and `litlen` arrays.
*   The output buffer (sliding window) is initialized.

## 2. Header Handshake
The first two bytes of the compressed stream (after the file header padding) define the parameters:
1.  **Literal Mode**: Must be `0` (Binary) or `1` (ASCII). DBC files are typically `0`.
2.  **Dictionary Size**: Must be `4`, `5`, or `6` (representing $2^4, 2^5, 2^6$ KB). DBC files typically use `6` (4096 bytes).

## 3. Main Decoding Loop
The decompressor reads a control bit:

*   **If Control Bit is 1 (Match)**:
    1.  **Decode Length**: Read bits and traverse the Length Huffman tree to find the `Symbol`.
        *   Map `Symbol` to a `Base Length`.
        *   Read specific `Extra Bits` associated with that symbol to calculate the final `Length`.
    2.  **Check for EOS**: If the calculated `Length` is **519**, this marks the **End of Stream**. Decompression stops.
    3.  **Decode Distance**: Read bits and traverse the Distance Huffman tree to find the `Symbol`.
        *   Map `Symbol` to a `Base Distance`.
        *   Read `Extra Bits` to calculate the final `Distance`.
    4.  **Copy**: Copy `Length` bytes from the history buffer at position `(Current - Distance)` to the current output position.

*   **If Control Bit is 0 (Literal)**:
    *   **If Mode 0 (Binary)**: Read next 8 bits directly as a raw byte.
    *   **If Mode 1 (ASCII)**: Decode the next symbol using the Literal Huffman tree (rarely used in DBC).
    *   **Output**: Write the byte to the output stream.

# 4. Implementation Notes

*   **`src/blast.c`**:
    *   Handles decompression.
    *   Modified from the original Mark Adler version for thread safety (removed static globals) and R compatibility (proper error handling).
*   **`src/implode.c`**:
    *   Handles compression.
    *   Implements the "greedy" LZ77 search.
    *   Manually constructs the "Inverted & Reversed" canonical codes to ensure the output is compatible with `blast`.
*   **`src/dbf2dbc.c`**:
    *   Acts as the file format wrapper.
    *   Reads the input DBF, extracts the header size, writes the DBC header, and then streams the rest of the file through `implode`.

# References

*   **PKWARE DCL**: The original Data Compression Library specification.
*   **Blast**: Mark Adler's open-source implementation of the DCL decompressor.
