#' Compress a standard DBF file into a DBC file
#'
#' This function compresses a standard DBF file into a DBC file using the PKWare DCL Implode algorithm.
#'
#' @param input The input DBF file path.
#' @param output The output DBC file path.
#' @return TRUE if successful.
#' @export
#' @examples
#' \dontrun{
#' # Compress a file
#' dbf2dbc("data.dbf", "data.dbc")
#' }
dbf2dbc <- function(input, output) {
  if (!file.exists(input)) {
    stop("Input file does not exist")
  }
  
  input <- path.expand(input)
  output <- path.expand(output)
  
  invisible(.Call("dbf2dbc", input, output))
}
