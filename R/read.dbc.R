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

#' Read a .dbc File
#'
#' This function allows you to read a .dbc (compressed .dbf) file into a data frame.
#' @param filename The name of the .dbc file (including extension)
#' @param keep.dbf Keeps the temporary .dbf file instead of deleting it (Defaults to FALSE)
#' @param ... Further arguments to be passed to read.dbf
#' @keywords dbc
#' @export
#' @examples
#' df <- read.dbc("mydata.dbc")

read.dbc <- function(filename, keep.dbf = FALSE, ...) {
        # Output file name
        out <- paste(strsplit(filename, ".")[1], "dbf", sep = ".")

        # Decompress the dbc file using the blast library wrapper.
        dbc2dbf(filename, out)

        # Use read.dbf from foreing package to read the uncompressed file
        df <- foreign::read.dbf(out, ...)

        # By default, remove the uncompressed file
        if( !keep.dbf ) file.remove(out)

        # Return data frame
        df
}
