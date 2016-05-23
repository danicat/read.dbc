# read.dbc.R
# Copyright (C) 2016 Daniela Petruzalek
# Version 1.0, 22 May 2016
# 
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the author be held liable for any damages
# arising from the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#         
# 1. The origin of this software must not be misrepresented; you must not
# claim that you wrote the original software. If you use this software
# in a product, an acknowledgment in the product documentation would be
# appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
# misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

# Load package dependencies (read.dbf)
library(foreign)

# Load external library
dyn.load("dbc2dbf.so")

# dbc2dbf: take a .dbc file and decompress it to .dbf
#
# Input Parameters:
#   input.file (char): the name of the file to decompress (with extension)
#   output.file (char): the name of the output filename (with extension)
dbc2dbf <- function(input.file, output.file) {
        if( !file.exists(input.file) )
                stop("Input file doesn't exists.")
        out <- .C("dbc2dbf", input = as.character(input.file), output = as.character(output.file))
}

# read.dbc: read a .dbc file and return a data.frame
#
# Input Parameters:
#   filename (char): the name of the .dbc file to read with extension
#   keep.dbf (logi): keeps the dbf after compression (default is to delete)
#
# Return: a data.frame
#
# Sample Usage:
#   df <- read.dbc("file.dbc")
read.dbc <- function(filename, keep.dbf = FALSE, ...) {
        # Output file name
        out <- paste(strsplit(filename, ".")[1], "dbf", sep = ".")
        
        # Decompress the dbc file using the blast library wrapper.
        dbc2dbf(filename, out)
        
        # Use read.dbf from foreing package to read the uncompressed file
        df <- read.dbf(out, ...)
        
        # By default, remove the uncompressed file
        if( !keep.dbf ) file.remove(out)
        
        # Return data frame
        df
}