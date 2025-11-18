## Release information

This is a new release (version 1.1.0) to modernize the package and address potential stability issues.

Major changes include:
* **Thread Safety**: Major C code refactoring to ensure thread safety. Removed static buffers and global state.
* **Modernization**: Updated C code to use modern `stdint.h` types and replaced legacy `setjmp`/`longjmp` with explicit error codes.
* **Robustness**: Improved error handling with detailed messages for I/O errors, memory allocation failures, and corrupted files.
* **Safety**: Replaced Variable Length Arrays (VLAs) with heap allocation to prevent potential stack overflows.

## R CMD check results

0 errors | 0 warnings | 1 note

* NOTE: "Package was archived on CRAN". This submission is intended to restore the package to CRAN with significant improvements to code quality and safety.

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

