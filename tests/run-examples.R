# Test for dbc2dbf()
# -------------------
# Input file name
input  <- system.file("files/sids.dbc", package = "read.dbc")

# Output file name
output <- tempfile(fileext = ".dbc")

# The call returns TRUE on success
if( read.dbc::dbc2dbf(input.file = input, output.file = output) ) {
     print("File decompressed!")
     # do things with the file
}

file.remove(output) # clean up example, don't do in real life :)


# Tests for read.dbc()
# --------------------
# The 'sids.dbc' file is the compressed version of 'sids.dbf' from the "foreign" package.
file <- system.file("files/sids.dbc", package="read.dbc")
sids <- read.dbc::read.dbc(file)
str(sids)
summary(sids)

# This is a small subset of U.S. NOAA storm database.
file <- system.file("files/storm.dbc", package="read.dbc")
storm <- read.dbc::read.dbc(file)
head(storm)
str(storm)
