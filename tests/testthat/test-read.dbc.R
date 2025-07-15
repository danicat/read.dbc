test_that("read.dbc handles non-existent files", {
  expect_error(read.dbc("non-existent-file.dbc"), "Error reading input file: non-existent-file.dbc - No such file or directory")
})

test_that("dbc2dbf handles non-existent files", {
  expect_error(dbc2dbf("non-existent-file.dbc", "output.dbf"), "Error reading input file: non-existent-file.dbc - No such file or directory")
})

test_that("dbc2dbf handles invalid output paths", {
  input  <- system.file("files/sids.dbc", package = "read.dbc")
  expect_error(dbc2dbf(input, "/non-existent-dir/output.dbf"), "Error creating output file: /non-existent-dir/output.dbf - No such file or directory")
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

#
# Positive Scenarios
#

test_that("dbc2dbf successfully decompresses a file", {
  input  <- system.file("files/sids.dbc", package = "read.dbc")
  output <- tempfile(fileext = ".dbf")
  expect_true(dbc2dbf(input, output))
  expect_true(file.exists(output))
  unlink(output)
})

test_that("read.dbc reads sids.dbc correctly", {
  file <- system.file("files/sids.dbc", package="read.dbc")
  sids <- read.dbc(file)
  expect_s3_class(sids, "data.frame")
  expect_equal(nrow(sids), 100)
  expect_equal(ncol(sids), 14)
})

test_that("read.dbc reads storm.dbc correctly", {
  file <- system.file("files/storm.dbc", package="read.dbc")
  storm <- read.dbc(file)
  expect_s3_class(storm, "data.frame")
  expect_equal(nrow(storm), 100)
  expect_equal(ncol(storm), 6)
})
