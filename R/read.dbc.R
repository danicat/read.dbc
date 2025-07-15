# read.dbc.R
# Copyright (C) 2016 Daniela Petruzalek
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

#' Read Data Stored in DBC (Compressed DBF) Files
#'
#' This function allows you to read a DBC (compressed DBF) file into a data frame.
#' @details
#' DBC is the extension for compressed DBF files (from the 'XBASE' family of databases).
#' This is a proprietary file format used by the Brazilian government to publish public healthcare data, and it is not related to the FoxPro or CANdb DBC file formats.
#'
#' The \code{read.dbc} function will decompress the input DBC file into a temporary DBF file and call \code{\link[foreign]{read.dbf}} from the \code{foreign} package to read it into a data frame.
#'
#' @note
#' DATASUS is the name of the Department of Informatics of the Brazilian Health System (Sistema Único de Saúde - SUS) and is responsible for publishing public healthcare data in Brazil.
#' Besides the DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data.
#'
#' This function was tested using files from both DATASUS and ANS to ensure compliance with the format, and hence ensure its usability by researchers.
#'
#' Neither this project, nor its author, has any association with the Brazilian government.
#' @param file The name of the DBC file (including extension)
#' @param ... Further arguments to be passed to \code{\link[foreign]{read.dbf}}
#' @importFrom foreign read.dbf
#' @return A data.frame of the data from the DBC file.
#' @keywords dbc datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{dbc2dbf}}
#' @examples
#' # The 'sids.dbc' file is the compressed version of 'sids.dbf' from the "foreign" package.
#' file <- system.file("files/sids.dbc", package="read.dbc")
#' sids <- read.dbc(file)
#' str(sids)
#' summary(sids)
#'
#' # This is a small subset of U.S. NOAA storm database.
#' file <- system.file("files/storm.dbc", package="read.dbc")
#' storm <- read.dbc(file)
#' head(storm)
#' str(storm)
#'
read.dbc <- function(file, ...) {
        # Output file name
        out <- tempfile(fileext = ".dbf")

        # Decompress the dbc file. dbc2dbf will error out if it fails.
        dbc2dbf(file, out)

        # Use read.dbf from foreing package to read the uncompressed file
        df <- foreign::read.dbf(out, ...)

        # Delete temp file
        file.remove(out)

        # Return data frame
        return(df)
}
