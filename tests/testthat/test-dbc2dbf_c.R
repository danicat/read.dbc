test_that("dbc2dbf C implementation works correctly", {
  # Path to the sample .dbc file
  dbc_file <- system.file("files/sids.dbc", package = "read.dbc")
  expect_true(file.exists(dbc_file))

  # Create a temporary output file
  dbf_file <- tempfile(fileext = ".dbf")
  on.exit(unlink(dbf_file))

  # Call the C wrapper function (dbc2dbf is exported by the package)
  result <- read.dbc::dbc2dbf(dbc_file, dbf_file)
  
  # Check if the function returned TRUE (success)
  expect_true(result)
  
  # Check if the output file exists and has content
  expect_true(file.exists(dbf_file))
  expect_gt(file.size(dbf_file), 0)
  
  # Verify the content using foreign::read.dbf
  df <- foreign::read.dbf(dbf_file)
  expect_s3_class(df, "data.frame")
  expect_gt(nrow(df), 0)
})

test_that("dbc2dbf handles non-existent input file", {
  input_file <- "non_existent_file.dbc"
  output_file <- tempfile(fileext = ".dbf")
  
  # Expect an error when input file is missing
  expect_error(read.dbc::dbc2dbf(input_file, output_file))
})

test_that("dbc2dbf handles invalid file content gracefully", {
  # Create a dummy file with invalid content
  input_file <- tempfile(fileext = ".dbc")
  writeLines("This is not a valid DBC file", input_file)
  output_file <- tempfile(fileext = ".dbf")
  on.exit(unlink(c(input_file, output_file)))

  # Expect an error or failure when file content is invalid
  expect_error(read.dbc::dbc2dbf(input_file, output_file))
})
