test_that("read.dbc handles non-existent files", {
  expect_error(read.dbc("non-existent-file.dbc"), "Input file does not exist.")
})

test_that("dbc2dbf handles non-existent files", {
  expect_error(dbc2dbf("non-existent-file.dbc", "output.dbf"), "Input file does not exist.")
})

test_that("dbc2dbf handles invalid output paths", {
  input  <- system.file("files/sids.dbc", package = "read.dbc")
  expect_error(dbc2dbf(input, "/non-existent-dir/output.dbf"), "Output directory does not exist or is not writable.")
})

test_that("read.dbc handles corrupted files", {
  # Create a dummy invalid DBC file
  invalid_dbc_file <- tempfile(fileext = ".dbc")
  writeLines("invalid file", invalid_dbc_file)
  expect_error(read.dbc(invalid_dbc_file), "Error decompressing file")
  unlink(invalid_dbc_file)
})

test_that("dbc2dbf handles corrupted files", {
  # Create a dummy invalid DBC file
  invalid_dbc_file <- tempfile(fileext = ".dbc")
  writeLines("invalid file", invalid_dbc_file)
  expect_error(dbc2dbf(invalid_dbc_file, tempfile(fileext = ".dbf")), "Error decompressing file")
  unlink(invalid_dbc_file)
})
