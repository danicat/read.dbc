# read.dbc 1.1.0

* **Thread Safety**: Major C code refactoring to ensure thread safety. Removed static buffers and global state.
* **Modernization**: Updated C code to use modern `stdint.h` types and replaced legacy `setjmp`/`longjmp` with explicit error codes.
* **Robustness**: Improved error handling with detailed messages for I/O errors, memory allocation failures, and corrupted files.
* **Safety**: Replaced Variable Length Arrays (VLAs) with heap allocation to prevent potential stack overflows.

# read.dbc 1.0.7

* Removed broken links
* Improved error handling in blast.c to prevent runtime errors (fixes gcc-UBSAN)
* Update DESCRIPTION with collaborators
* Documentation edits for conciseness
* Overall doc improvements
