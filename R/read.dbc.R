# read.dbc.R
# Copyright (C) 2016 Daniela Petruzalek
# Version 1.0, 22 May 2016
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Read a DBC File
#'
#' This function allows you to read a DBC (compressed DBF) file into a data frame.
#' @details
#' DBC is the extension for compressed DBF files (from the 'XBASE' family of databases). \code{read.dbc} relies on the \code{\link{dbc2dbf}} function to decompress the DBC into a DBF file.
#'
#' After decompressing, it reads the DBF file into a \code{data.frame} using \code{\link{read.dbf}} from the \code{foreign} package.
#'
#' By default, it deletes the DBF file after reading to preserve file system space, but this behaviour can be overriden with the parameter \code{keep.dbf = TRUE}.
#' @note
#' While it's not a very common format, the DBC file has extensive usage by the Brazilian government to publish Public Health data.
#'
#' DATASUS is the name of the Department of Informatics of Brazilian Health System and is resposible for publishing those data. The Brazilian National Agency for Supplementary Health (ANS) also uses the DBC format for its public data.
#'
#' This function was tested using files from both DATASUS and ANS to ensure compliance with the format, and hence ensure its usability by researchers.
#' @param file The name of the DBC file (including extension)
#' @param keep.dbf Keeps the temporary DBF file instead of deleting it (Defaults to \code{FALSE})
#' @param ... Further arguments to be passed to \code{read.dbf}
#' @return A data.frame of the data from the DBC file.
#' @keywords dbc datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{dbc2dbf}}
#' @examples
#' # The 'sids.dbc' file is the compressed version of 'sids.dbf' from the "foreign" package.
#' x <- read.dbc(system.file("files/sids.dbc", package="read.dbc"))
#' str(x)
#' summary(x)
#'
#' # This is a small subset of U.S. NOAA storm database.
#' storm <- read.dbc(system.file("files/storm.dbc", package="read.dbc"))
#' head(x)
#' str(x)
read.dbc <- function(file, keep.dbf = FALSE, ...) {
        # Output file name
        out <- paste(strsplit(file, ".")[1], "dbf", sep = ".")

        # Decompress the dbc file using the blast library wrapper.
        if( dbc2dbf(file, out) ) {
                # Use read.dbf from foreing package to read the uncompressed file
                df <- foreign::read.dbf(out, ...)

                # By default, remove the uncompressed file
                if( !keep.dbf ) file.remove(out)

                # Return data frame
                return(df)
        }
}
