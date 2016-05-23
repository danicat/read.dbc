# read.dbc

Written by Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
May, 22nd 2016

## Introduction

`read.dbc` is a R package to enable importing data from `.dbc` files (which are actually compressed `.dbf` files).  

It is based on the work of [Mark Adler](mailto:madler@alumni.caltech.edu) (blast decompressor) and [Pablo Fonseca](https://github.com/eaglebh/blast-dbf) (blast-dbf).

This repo also includes the original C code forked from https://github.com/eaglebh/blast-dbf with some customizations. This code can be compiled as a standalone program or as a shared library. As a standalone program, it has a few improvements over the original code, like enabling shell/terminal redirections (which was broken in the original blast-dbf).  

For a complete description of the changes, please check the [CHANGELOG.md](/CHANGELOG.md) file.

## Repository Contents

- `README.md`: this file.  
- `README.orig`: original README file from Mark Adler.  
- `CHANGELOG.md`: change history.  
- `Makefile`: define rules for building both standalone and shared library versions. (not necessary for R package usage)
- `src/blast.c`: decompression tools for PKWare Data Compression Library (DCL).  
- `src/blast.h`: `blast.c` header and usage notes.  
- `src/dbc2dbf.c`: the main program to decompress the dbc files to dbf.  
- `R/read.dbc.R`: the code for reading `.dbc` files within R.
- `R/dbc2dbf.R`: a helper function to decompress the `.dbc` files, it works as a wrapper to the "blast" code.
- `man/*`: package manuals
- `tests/test.pk`: File compressed with DCL
- `tests/test.txt`: Expected output from decompressing `test.pk`. Please note that this test is *currently broken*, since `test.pk` is not a `.dbc` file (it is missing the file header). I've kept this file from the original repo only for historic purposes.  

## Installation

The easiest way to install this package is using the `devtools` library:

        devtools::install_github("danicat/read.dbc")
        
### Standalone decompressor: dbc2dbf

In order to install `dbc2dbf` as a standalone program you must compile it from the source. I've provided a `Makefile` for ease of usage. To compile it as a standalone program, you must run on the command line:  

        cd [source-code-directory]
        git clone --depth=1 https://github.com/danicat/read.dbc
        cd read.dbc
        make dbc2dbf

It will create a executable file named `dbc2dbf` in the project directory.

### Decompressor as a shared library: dbc2dbf.so

If you want to compile dbc2dbf as a shared library instead, you must run on the command line:

        cd [source-code-directory]
        git clone --depth=1 https://github.com/danicat/read.dbc
        cd read.dbc
        make shared

This will create a file named `dbc2dbf.so` in the project directory.

## Usage

Reading a .dbc file to a data frame:

        df <- read.dbc("mydata.dbc")
        
Decompressing a .dbc file to a .dbf:

        dbc2dbf("mydata.dbc","mydata.dbf")

## Contact Info

If you have any questions, please contact me at daniela.petruzalek@gmail.com. You may also follow me on [Twitter](http://www.twitter.com/danicat83).
