# read.dbc

Written by Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
May, 22nd 2016

## Introduction

`read.dbc` is a R package to enable importing data from `DBC` files. DBC is the extension for compressed DBF files (from the 'XBASE' family of databases).

While it's not a very common format, the DBC file has extensive usage by the Brazilian government to publish Public Health data.

DATASUS is the name of the Department of Informatics of Brazilian Health System and is resposible for publishing those data. The Brazilian National Agency for Supplementary Health (ANS) also uses the DBC format for its public data.

This code was tested using files from both DATASUS and ANS to ensure compliance with the format, and hence ensure its usability by researchers.

It is based on the work of [Mark Adler](https://github.com/madler/zlib/tree/master/contrib/blast) (blast) and [Pablo Fonseca](https://github.com/eaglebh/blast-dbf) (blast-dbf).

## Changelog

For a complete description of the changes, please check [CHANGELOG.md](/inst/CHANGELOG.md).

## Repository Contents

- `README.md`: this file.  
- `CHANGELOG.md`: change history.  
- `src/blast.c`: decompression tools for PKWare Data Compression Library (DCL).  
- `src/blast.h`: `blast.c` header and usage notes.  
- `src/dbc2dbf.c`: the main program to decompress the dbc files to dbf.  
- `R/read.dbc.R`: the code for reading `.dbc` files within R.
- `R/dbc2dbf.R`: a helper function to decompress the `.dbc` files, it works as a wrapper to the "blast" code.
- `man/*`: package manuals
- `inst/*`: test and misc files

## Installation

The easiest way to install this package is using the `devtools` library:

        devtools::install_github("danicat/read.dbc")
        
## Usage

Reading a DBC file to a data frame:

        # The 'sids.dbc' file is the compressed version of 'sids.dbf' from the "foreign" package.
        x <- read.dbc(system.file("files/sids.dbc", package="read.dbc"))
        str(x)
        summary(x)
        
        # This is a small subset of U.S. National Oceanic and Atmospheric Administration’s (NOAA) storm database.
        storm <- read.dbc(system.file("files/storm.dbc", package="read.dbc"))
        head(x)
        str(x)
        
        # Don't run!
        # The following code will download data from the "Declarations of Death" database for
        # the Brazilian state of Parana, year 2013. Source: DATASUS / Brazilian Ministry of Health
        url <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DOPR2013.dbc"
        download.file(url, destfile = "DOPR2013.dbc")
        dopr <- read.dbc("DOPR2013.dbc")
        head(dopr)
        str(dopr)
        
Decompressing a DBC file to a DBF:

        # Input file name
        in.f  <- system.file("files/sids.dbc", package = "read.dbc")
        
        # Output file name
        out.f <- tempfile(fileext = ".dbc")
        
        # The call return logi = TRUE on success
        if( dbc2dbf(input.file = in.f, output.file = out.f) ) {
             print("File decompressed!")
             file.remove(out.f)
        }

## Contact Info

If you have any questions, please contact me at daniela.petruzalek@gmail.com. You may also follow me on [Twitter](http://www.twitter.com/danicat83).
