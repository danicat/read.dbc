# dbc2dbf.R
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

#' Decompress a DBC file
#'
#' This function allows you decompress a DBC file.
#' Please note that this is the file format used by the Brazilian Ministry of Health (DATASUS), and it is not related to the FoxPro or CANdb DBC file formats.
#'
#' @param input.file The name of the DBC file (including extension)
#' @param output.file The output file name (including extension)
#' @return Return TRUE if succeed, FALSE otherwise.
#' @details
#' DBC is the extension for compressed DBF files (from the 'XBASE' family of databases).
#' This is a proprietary file format used by the Brazilian government to publish public healthcare data.
#' When decompressed, it becomes a regular DBF file.
#' @source
#' The internal C code for \code{dbc2dbf} is based on \code{blast} decompressor and \code{blast-dbf} (see \emph{References}).
#' @keywords dbc dbf
#' @export
#' @useDynLib read.dbc
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{read.dbc}}
#' @examples
#' # Input file name
#' input  <- system.file("files/sids.dbc", package = "read.dbc")
#'
#' # Output file name
#' output <- tempfile(fileext = ".dbc")
#'
#' # The call returns TRUE on success
#' if( dbc2dbf(input.file = input, output.file = output) ) {
#'      print("File decompressed!")
#'      # do things with the file
#' }
#'
#' file.remove(output) # clean up example, don't do in real life :)
#'
#' @references
#' \code{blast} source code in C: \url{https://github.com/madler/zlib/tree/master/contrib/blast}
#' \code{blast-dbf}, DBC to DBF command-line decompression tool: \url{https://github.com/eaglebh/blast-dbf}
#'
dbc2dbf <- function(input.file, output.file) {
        if( !file.exists(input.file) )
                stop("Input file does not exist.")
        out <- .C("dbc2dbf", input = as.character(path.expand(input.file)), output = as.character(path.expand(output.file)))
        file.exists(output.file)
}
