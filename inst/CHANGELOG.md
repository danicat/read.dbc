## CHANGELOG.md

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
