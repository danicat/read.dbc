<!-- badges: start -->
[![R-CMD-check](https://github.com/danicat/read.dbc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/danicat/read.dbc/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# read.dbc

**Author:** Daniela Petruzalek  
**Email:** daniela.petruzalek@gmail.com  
**License:** AGPLv3

## Overview

`read.dbc` is an R package designed to handle the **DBC** file format, a proprietary compressed database format used by the **Brazilian Ministry of Health (DATASUS)** for public healthcare datasets.

It provides functionality to:
1.  **Read** `.dbc` files directly into R data frames (`read.dbc`).
2.  **Decompress** `.dbc` files into standard `.dbf` files (`dbc2dbf`).
3.  **Compress** standard `.dbf` files into `.dbc` format (`dbf2dbc`) **(New in v1.2.0!)**.

This project is based on the work of [Mark Adler](https://github.com/madler/zlib/tree/master/contrib/blast) (blast) and [Pablo Fonseca](https://github.com/eaglebh/blast-dbf) (blast-dbf).

*Note: This project is not affiliated with the Brazilian government.*

## Recent Improvements (v1.1.0+)

The package has undergone a major overhaul to ensure stability and performance:
*   **Thread Safety**: Complete refactoring of the C codebase to remove global state, making it safe for parallel execution (e.g., `mclapply`).
*   **Compression Support**: Added experimental support for creating `.dbc` files from `.dbf` files.
*   **Robustness**: Improved error handling, buffer management (fixing stack overflows with large files), and memory safety.

## Documentation & Internals

For those interested in the technical details of the proprietary DBC format or the compression algorithms used:

*   [**DBC File Format Specification**](DBC_FORMAT.md): A high-level overview of the file structure and compression logic.
*   [**Internals & Algorithms**](INTERNALS.md): A deep dive into the "Implode" algorithm, bit stream encoding, and implementation details.
*   [**Changelog**](inst/CHANGELOG.md): Detailed history of changes.

## Installation

The stable version is available on [CRAN](https://cran.r-project.org/package=read.dbc):

```r
install.packages("read.dbc")
```

To install the latest development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("danicat/read.dbc")
```

## Usage

### Reading a DBC file

```r
library(read.dbc)

# Read a sample DBC file included in the package
sids <- read.dbc(system.file("files/sids.dbc", package="read.dbc"))

print(str(sids))
print(summary(sids))
```

### Downloading and Reading DATASUS Data

```r
# Example: Downloading "Declarations of Death" for Parana state, 2013
url <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DOPR2013.dbc"
tryCatch({
    download.file(url, destfile = "DOPR2013.dbc", mode = "wb")
    dopr <- read.dbc("DOPR2013.dbc")
    head(dopr)
}, error = function(e) {
    message("Could not download or read the file: ", e$message)
})
```

### Decompressing (DBC -> DBF)

```r
in.f  <- system.file("files/sids.dbc", package = "read.dbc")
out.f <- tempfile(fileext = ".dbf")

if( dbc2dbf(input.file = in.f, output.file = out.f) ) {
     message("File decompressed to: ", out.f)
}
```

### Compressing (DBF -> DBC)

*New in v1.2.0*

```r
# Using the DBF created in the previous step
dbc.f <- tempfile(fileext = ".dbc")

if( dbf2dbc(input.file = out.f, output.file = dbc.f) ) {
     message("File compressed to: ", dbc.f)
}
```

## Developer Information

### Build & Test

*   **Requirements**: R, RStudio (optional), C compiler (gcc/clang).
*   **Commands**:
    *   `make setup`: Install dependencies.
    *   `make check`: Run R CMD check.
    *   `make test`: Run unit tests.
    *   `make clean`: Clean build artifacts.
    *   `make help`: List all available commands.

## Contact

If you have questions or issues, please open an issue on GitHub or contact the author at [daniela.petruzalek@gmail.com](mailto:daniela.petruzalek@gmail.com).