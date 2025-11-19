# TODO

## Future Improvements

### Performance Optimization
- [ ] **Optimize `implode.c` Match Finding**: Currently, `implode.c` uses a brute-force search within the sliding window (`O(N*W)`). For larger files, this should be replaced with the hash chain implementation (stubbed in the code) or a similar accelerated matching algorithm (e.g., standard LZ77 hash chains) to achieve `O(N)` performance.

### Feature Enhancements
- [ ] **Streaming Support**: The current `dbf2dbc` implementation reads and writes in chunks but relies on file-based I/O. Exposing a true streaming interface (R connection support) would allow compressing/decompressing directly from/to memory or network streams.

### Testing
- [ ] **C-Level Unit Tests**: Add a framework for testing internal C functions (bit manipulation, Huffman table generation) directly, independent of the R interface, to catch edge cases in bit logic earlier.
- [ ] **Fuzz Testing**: Implement fuzz testing for `blast.c` (decompression) to ensure robustness against malformed or malicious DBC files.

### Documentation
- [ ] **Format Specification**: Document the reverse-engineered details of the DBC format (header structure, bit-inversion logic, DCL parameters) more formally in a vignette or developer guide.
