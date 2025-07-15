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
