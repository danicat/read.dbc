# dbc2dbf.R
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

#' Decompress a DBC file to DBF
#'
#' This function allows you decompress a DBC file into its DBF counterpart.
#' @param input.file The name of the DBC file (including extension)
#' @param output.file The output file name (including extension)
#' @return Return TRUE if succeded, FALSE otherwise.
#' @details
#' DBC is the extension for compressed DBF files (from the 'XBASE' family of databases). It uses internally the PKWare's Data Compression Library (DCL) "implode" compression algorithm.
#' @source
#' The internal C code for \code{dbc2dbf} is based on \code{blast} decompressor and \code{blast-dbf} (see \emph{References}).
#' @keywords dbc dbf
#' @export
#' @useDynLib read.dbc
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{read.dbc}}
#' @examples
#' # Input file name
#' in.f  <- system.file("files/sids.dbc", package = "read.dbc")
#' 
#' # Output file name
#' out.f <- paste(strsplit(in.f, ".")[1], "dbf", sep = ".")
#' 
#' # The call return logi = TRUE on success
#' if( dbc2dbf(input.file = in.f, output.file = out.f) ) {
#'      print("File decompressed!")
#' }
#'
#' @references
#' The PKWare ZIP file format documentation (contains the "implode" algorithm specification) available at \url{https://support.pkware.com/display/PKZIP/APPNOTE}, current version \url{https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT}.
#'
#' \code{blast} source code in C: \url{https://github.com/madler/zlib/tree/master/contrib/blast}
#'
#' \code{blast-dbf}, DBC to DBF command-line decompression tool: \url{https://github.com/eaglebh/blast-dbf}
#'
dbc2dbf <- function(input.file, output.file) {
        if( !file.exists(input.file) )
                stop("Input file does not exist.")
        out <- .C("dbc2dbf", input = as.character(input.file), output = as.character(output.file))
        file.exists(output.file)
}
