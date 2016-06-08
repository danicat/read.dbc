# read.dbc

Written by Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
First published in May, 22nd 2016

## Introduction

`read.dbc` is a R package to enable importing data from `DBC` (compressed `DBF`) files into data frames. Please note that this is the file format used by the Brazilian Ministry of Health (DATASUS), and it is not related to the Microsoft FoxPro or CANdb DBC file formats.

DATASUS is the name of the Department of Informatics of Brazilian Health System. It is the agency resposible for publishing Brazilian public healthcare data. Besides DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data.

This code was tested using files from both DATASUS and ANS to ensure compliance with the format, and hence ensure its usability by researchers.

This project is based on the work of [Mark Adler](https://github.com/madler/zlib/tree/master/contrib/blast) (blast) and [Pablo Fonseca](https://github.com/eaglebh/blast-dbf) (blast-dbf).

As a final note, neither this project, nor its author, is related in any way to the Brazilian government.

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

As of June, 7 of 2016, this package officialy became part of [CRAN](https://cran.r-project.org/web/packages/read.dbc/index.html) (The Comprehensive R Archive Network). Therefore, it's current stable version can be installed by running `install.packages`:

        install.packages("read.dbc")

In case you want to install the development version of this package, you still can do it using the `devtools` library:

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
