test_that("End-to-end workflow: CSV -> DBF -> DBC -> DataFrame", {
  # 1. Create a simple dataset
  # Using a mix of types: numeric, character, factor (will become char in DBF usually)
  original_data <- data.frame(
    ID = 1:10,
    Name = c("Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Heidi", "Ivan", "Judy"),
    Score = c(95.5, 88.0, 76.5, 92.0, 99.5, 85.0, 79.5, 91.0, 88.5, 94.0),
    Active = c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  
  # 2. Write to CSV (as requested)
  csv_file <- tempfile(fileext = ".csv")
  write.csv(original_data, csv_file, row.names = FALSE)
  
  # 3. Read CSV back (to ensure we work with what's on disk)
  csv_data <- read.csv(csv_file, stringsAsFactors = FALSE)
  
  # 4. Write to DBF
  # We need foreign package (suggested/imported by read.dbc)
  # But write.dbf is not exported by read.dbc, so we load foreign namespace or check availability.
  # DESCRIPTION says Imports: foreign.
  
  if (!requireNamespace("foreign", quietly = TRUE)) {
    skip("foreign package not available for writing DBF")
  }
  
  dbf_file <- tempfile(fileext = ".dbf")
  foreign::write.dbf(csv_data, dbf_file)
  
  # 5. Compress to DBC
  dbc_file <- tempfile(fileext = ".dbc")
  expect_true(dbf2dbc(dbf_file, dbc_file))
  
  # 6. Read DBC as DataFrame
  final_data <- read.dbc(dbc_file)
  
  # 7. Compare
  # Note: DBF format has limitations (e.g., column names length, character width, no boolean type usually maps to Logical/Character)
  # foreign::write.dbf might convert logicals to something else?
  # Let's check structure match.
  
  # ID (int) -> should remain int or numeric
  expect_equal(as.numeric(final_data$ID), csv_data$ID)
  
  # Name (char) -> should remain char or factor. read.dbc might return factors by default?
  # read.dbc documentation says it calls foreign::read.dbf.
  # default as.is = FALSE (so factors).
  # csv_data has chars.
  expect_equal(as.character(final_data$Name), csv_data$Name)
  
  # Score (numeric) -> numeric
  expect_equal(final_data$Score, csv_data$Score)
  
  # Active (logical) -> DBF usually stores as 'T'/'F' or 1/0. 
  # foreign::read.dbf reads logicals correctly if they were stored as logicals.
  # Let's verify.
  expect_equal(as.logical(final_data$Active), csv_data$Active)
  
  # Clean up
  unlink(csv_file)
  unlink(dbf_file)
  unlink(dbc_file)
})
