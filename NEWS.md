# read.dbc 1.2.0

* **New Feature**: Added `dbf2dbc()` function to compress standard DBF files into DBC format (Experimental).
* **Housekeeping**: Removed vignette builder and `knitr`/`rmarkdown` dependencies.
* **Bug Fix**: Fixed compilation error on systems requiring explicit `stdint.h` inclusion.

# read.dbc 1.1.1

* **Bug Fix**: Fixed a buffer overflow/stack corruption issue when decompressing files with large backward references (e.g., `sids.dbc`). Increased internal buffer size (`MAXWIN`) from 4KB to 16KB and added a safety boundary check to prevent future crashes.

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
