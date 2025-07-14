pkgname <- "read.dbc"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "read.dbc-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('read.dbc')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("dbc2dbf")
### * dbc2dbf

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: dbc2dbf
### Title: Decompress a DBC file
### Aliases: dbc2dbf
### Keywords: dbc dbf

### ** Examples

# Input file name
input  <- system.file("files/sids.dbc", package = "read.dbc")

# Output file name
output <- tempfile(fileext = ".dbc")

# The call returns TRUE on success
if( dbc2dbf(input.file = input, output.file = output) ) {
     print("File decompressed!")
     # do things with the file
}

file.remove(output) # clean up example, don't do in real life :)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("dbc2dbf", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("read.dbc")
### * read.dbc

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: read.dbc
### Title: Read Data Stored in DBC (Compressed DBF) Files
### Aliases: read.dbc
### Keywords: datasus dbc

### ** Examples

# The 'sids.dbc' file is the compressed version of 'sids.dbf' from the "foreign" package.
file <- system.file("files/sids.dbc", package="read.dbc")
sids <- read.dbc(file)
str(sids)
summary(sids)

# This is a small subset of U.S. NOAA storm database.
file <- system.file("files/storm.dbc", package="read.dbc")
storm <- read.dbc(file)
head(storm)
str(storm)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("read.dbc", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
