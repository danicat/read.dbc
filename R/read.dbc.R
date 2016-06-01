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
#' DBC is the extension for compressed DBF files (from the 'XBASE' family of databases). \code{read.dbc} relies on the \code{\link{dbc2dbf}} function to decompress the DBC into a temporary DBF file.
#'
#' After decompressing, it reads the temporary DBF file into a \code{data.frame} using \code{\link{read.dbf}} from the \code{foreign} package.
#'
#' @note
#' While it's not a very common format, the DBC file has extensive usage by the Brazilian government to publish Public Health data.
#'
#' DATASUS is the name of the Department of Informatics of Brazilian Health System and is resposible for publishing those data. The Brazilian National Agency for Supplementary Health (ANS) also uses the DBC format for its public data.
#'
#' This function was tested using files from both DATASUS and ANS to ensure compliance with the format, and hence ensure its usability by researchers.
#' @param file The name of the DBC file (including extension)
#' @param ... Further arguments to be passed to \code{\link{read.dbf}}
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
#'
#' \donttest{
#' ## Don't run!
#' ## The following code will download data from the "Declarations of Death" database for
#' ## the Brazilian state of Parana, year 2013. Source: DATASUS / Brazilian Ministry of Health
#' url <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DOPR2013.dbc"
#' download.file(url, destfile = "DOPR2013.dbc")
#' dopr <- read.dbc("DOPR2013.dbc")
#' head(dopr)
#' str(dopr)
#' }
read.dbc <- function(file, ...) {
        # Output file name
        out <- tempfile(fileext = ".dbf")

        # Decompress the dbc file using the blast library wrapper.
        if( dbc2dbf(file, out) ) {
                # Use read.dbf from foreing package to read the uncompressed file
                df <- foreign::read.dbf(out, ...)

                # Delete temp file
                file.remove(out)

                # Return data frame
                return(df)
        }
}
