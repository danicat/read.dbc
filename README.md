# read.dbc

Written by Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
May, 22nd 2016

## Introduction

`read.dbc` is a helper program to enable the import of `.dbc` files (compressed `.dbf`) whithin R. It is based on the work of [Mark Adler](mailto:madler@alumni.caltech.edu) (blast decompressor) and [Pablo Fonseca](https://github.com/eaglebh/blast-dbf) (blast-dbf).

This repo includes the original C code forked from https://github.com/eaglebh/blast-dbf with some customizations. This code can be compiled as a standalone program or as a shared library.

As a standalone program, it has a few improvements over the original code, like enabling shell redirections to be used in command line or shell scripts (which was broken in the original blast-dbf). 

For a complete description of the changes, please check the [CHANGELOG.md](/CHANGELOG.md) file.

## Repository Contents

- `blast.c`: decompression tools for PKWare Data Compression Library (DCL).  
- `blast.h`: `blast.c` header and usage notes.  
- `dbc2dbf.c`: the main program to decompress the dbc files to dbf.  
- `Makefile`: define rules for building both standalone and shared library versions.  
- `test.pk`: File compressed with DCL
- `test.txt`: Expected output from decompressing `test.pk`. Please note that this test is *currently broken*, since `test.pk` is not a `.dbc` file (it is missing the file header). I've kept this file from the original repo for historic purposes.  
- `README.orig`: original README file from Mark Adler.  
- `README.md`: this file.  
- `CHANGELOG.md`: change history.  
- `read.dbc.R`: the code for reading `.dbc` files within R.

## Installation

The easiest way to copy the source code to your computer is by running `git clone`:

        cd [source-code-directory]
        git clone --depth=1 https://github.com/danicat/read.dbc

This command will create a directory named `read.dbc` in `[source-code-directory]` and download all required files.

### dbc2dbf

In order to install `dbc2dbf` you must compile it from the source. I've provided a `Makefile` for ease of usage. To compile it as a standalone program, just run:  

        cd [source-code-directory]/read.dbc
        make

It will create a executable file named `dbc2dbf` in the source directory.

If you want to compile dbc2dbf as a shared library instead, please run:

        cd [source-code-directory]/read.dbc
        make shared

### read.dbc

In the current release the `read.dbc` function is provided in the file `read.dbc.R`. You need to source it from your R session before use. For future releases I'll turn it into an installable package. From within the R session run:

        setwd("[source-code-directory]/read.dbc")
        source("read.dbc.R")

Also, make sure the file `dbc2dbf.so` is in the current working dir before sourcing the script, or the `dyn.load` call will fail. This will also be corrected by the conversion of this code into a package.

## Usage

The R script has the code for two functions, one to decompress the `.dbc` file, called `dbc2dbf`, and the other to make a transparent read from the `.dbc` file directly to a data.frame, called `read.dbc`. Here is the sample usage:

        > source('~/read.dbc/read.dbc.R')
        > dbc2dbf(input.file = "test/tb_rc_01.dbc", output.file = "test/tb_rc_01.dbf" )
        > df <- read.dbc("test/tb_rc_01.dbc")
        > str(df)
        'data.frame':	1985 obs. of  9 variables:
        $ ANO       : Factor w/ 1 level "2001": 1 1 1 1 1 1 1 1 1 1 ...
        $ MODALIDADE: Factor w/ 7 levels "22","23","24",..: 1 1 1 1 1 1 1 1 1 1 ...
        $ CD_OPERADO: Factor w/ 1985 levels "000027","000299",..: 321 363 886 479 387 793 629 288 317 416 ...
        $ RECEITA   : Factor w/ 1538 levels "0","1","1001739",..: 779 1491 672 1473 739 1512 264 505 1002 818 ...
        $ DESP_AST  : Factor w/ 1270 levels "0","10009865",..: 680 1182 425 1112 532 1125 9 264 713 508 ...
        $ DESP_ADM  : Factor w/ 1535 levels "0","1000","1000544",..: 1124 513 1 1510 873 29 655 699 1424 1384 ...
        $ OUTRAS_REC: int  0 0 0 0 0 0 0 0 0 0 ...
        $ DESPESAS_C: int  0 0 0 0 0 0 0 0 0 0 ...
        $ OUTRAS_DES: int  0 0 0 0 0 0 0 0 0 0 ...
        - attr(*, "data_types")= chr  "C" "C" "C" "C" ...
        > names(df)
        [1] "ANO"        "MODALIDADE" "CD_OPERADO" "RECEITA"    "DESP_AST"   "DESP_ADM"   "OUTRAS_REC" "DESPESAS_C" "OUTRAS_DES"

Note: the sample file above is not supplied in this repository, but it's freely available from [DATASUS](http://datasus.saude.gov.br/) (sorry, the referred site is in portuguese only)

## Planned Updates

For the next release this code will be packaged to make it easier to deploy.

## Contact Info

If you have any questions, please contact me at daniela.petruzalek@gmail.com. You may also follow me on [Twitter](http://www.twitter.com/danicat83).
