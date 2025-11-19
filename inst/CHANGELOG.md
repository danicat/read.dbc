## CHANGELOG.md

### Version 1.2.0 (2025-11-19)

* **New Feature**: Added `dbf2dbc()` function to compress standard DBF files into DBC format (Experimental).
* **Housekeeping**: Removed vignette builder and `knitr`/`rmarkdown` dependencies to streamline package dependencies.
* **Bug Fix**: Fixed compilation error on systems requiring explicit `stdint.h` inclusion (e.g., for `uint16_t` in `dbf2dbc.c`).

### Version 1.1.1 (2025-11-19)

* **Bug Fix**: Fixed a critical buffer overflow/stack corruption issue when decompressing files with large backward references (e.g., `sids.dbc`).
    * Increased internal sliding window buffer (`MAXWIN`) from 4KB to 16KB to support these files.
    * Added a safety boundary check to explicitly return an error if a file requires a larger buffer, preventing crashes/memory corruption.

### Version 1.1.0 (2025-11-19)

* **Thread Safety**: Major C code refactoring to ensure thread safety. Removed static buffers and global state, making the package safe for concurrent use (e.g., `parallel::mclapply`).
* **Modernization**: Updated C code to use modern `stdint.h` types and removed legacy `setjmp`/`longjmp` error handling in favor of explicit error codes.
* **Robustness**: Improved error handling with detailed messages for I/O errors, memory allocation failures, and corrupted files.
* **Safety**: Replaced Variable Length Arrays (VLAs) with heap allocation to prevent potential stack overflows with large headers.

### Version 1.0.7

* Removed broken links
* Improved error handling in blast.c to prevent runtime errors (fixes gcc-UBSAN)
* Update DESCRIPTION with collaborators
* Documentation edits for conciseness
* Overall doc improvements

### Version 1.0.5
- Fixed BUG that left files open on error (Issue #4)

### Version 1.0.4
- Fixed BUG on the Solaris port
- Small code cleanups

### Version 1.0.3
- Cleanup of the manual - disambiguation of the file format
- This DBC file is not compatible with FoxPro or CANdb
- Added path expansion to handle '~' in file names

### Version 1.0.2
- Preparations for CRAN
- Improved error handling in C code
- Improved examples in documentation
- Removed keep.dbf parameter from read.dbc. (useless?)
- Fixed read.dbc to use tempfiles.

### Version 1.0.1
- Documentation cleanup
- Added test files sids.dbc and storm.dbc
- Separation of code from the command-line decompressor blast-dbf to avoid conditional compilation
- Removed unused files

### Version 1.0.0: Packaged release
- Project was converted into a R package
- Now it can be installed with devtools::install_github("danicat/read.dbc")
- Added documentation
- Minor fixes and code reorganization

### Version 0.1: (Initial Release)  

- Fork of the code available on https://github.com/eaglebh/blast-dbf.  
- Fixed the code to work with standard input/output redirection.  
- Split the core blast code (blast.c) from the dbc2dbf code (dbc2dbf.c).  
- Added conditional compilation to shared library (.so) or command line.  
- Note: the original test.pk decompression test is broken in this version because it has no header (as opposed to a .dbc file).  
