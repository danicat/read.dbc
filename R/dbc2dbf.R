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

#' Decompress a .dbc file into a .dbf
#'
#' This function allows you decompress a .dbc file into its .dbf counterpart.
#' @param input.file The name of the .dbc file (including extension)
#' @param output.file The output file name (including extension)
#' @keywords dbc dbf
#' @export
#' @useDynLib read.dbc
#' @examples
#' dbc2dbf("mydata.dbc","mydata.dbf")

dbc2dbf <- function(input.file, output.file) {
        if( !file.exists(input.file) )
                stop("Input file does not exist.")
        out <- .C("dbc2dbf", input = as.character(input.file), output = as.character(output.file))
}
