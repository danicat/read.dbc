test_that("read.dbc handles non-existent files", {
  expect_error(read.dbc("non-existent-file.dbc"), "Error opening input file 'non-existent-file.dbc': No such file or directory")
})

test_that("dbc2dbf handles non-existent files", {
  expect_error(dbc2dbf("non-existent-file.dbc", "output.dbf"), "Error opening input file 'non-existent-file.dbc': No such file or directory")
})

test_that("dbc2dbf handles invalid output paths", {
  input  <- system.file("files/sids.dbc", package = "read.dbc")
  expect_error(dbc2dbf(input, "/non-existent-dir/output.dbf"), "Error creating output file '/non-existent-dir/output.dbf': No such file or directory")
})

test_that("read.dbc handles corrupted files", {
  # Create a dummy invalid DBC file
  invalid_dbc_file <- tempfile(fileext = ".dbc")
  writeLines("invalid file", invalid_dbc_file)
  expect_error(read.dbc(invalid_dbc_file), "Error reading header content")
  unlink(invalid_dbc_file)
})

test_that("dbc2dbf handles corrupted files", {
  # Create a dummy invalid DBC file
  invalid_dbc_file <- tempfile(fileext = ".dbc")
  writeLines("invalid file", invalid_dbc_file)
  expect_error(dbc2dbf(invalid_dbc_file, tempfile(fileext = ".dbf")), "Error reading header content")
  unlink(invalid_dbc_file)
})
