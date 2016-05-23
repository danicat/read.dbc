## CHANGELOG.md

### Version 0.1: (Initial Release)  

- Fork of the code available on https://github.com/eaglebh/blast-dbf.  
- Fixed the code to work with standard input/output redirection.  
- Split the core blast code (blast.c) from the dbc2dbf code (dbc2dbf.c).  
- Added conditional compilation to shared library (.so) or command line.  
- Makefile: added option to install to R.  
- Note: the original test.pk decompression test is broken in this version because it has no header (as opposed to a .dbc file).  
