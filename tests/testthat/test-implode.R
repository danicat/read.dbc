test_that("dbf2dbc compresses simple data correctly", {
  # Create a simple DBF-like file (header + data)
  # Header size 32 bytes.
  # Data: "AAAAABBBBB"
  
  tf_in <- tempfile(fileext = ".dbf")
  tf_dbc <- tempfile(fileext = ".dbc")
  tf_out <- tempfile(fileext = ".dbf")
  
  con <- file(tf_in, "wb")
  # Header: 32 bytes.
  # Bytes 8-9 must be 32 (0x20 0x00)
  header <- raw(32)
  header[9] <- as.raw(0x20) # 32
  header[10] <- as.raw(0x00)
  # Note: 1-based index in R. 8-9 is [9], [10]?
  # C 0-based: 8, 9. R 1-based: 9, 10.
  # Actually 32 is 0x20. So header[9] = 0x20.
  
  writeBin(header, con)
  
  # Data
  data <- charToRaw("AAAAABBBBBCCCCC")
  writeBin(data, con)
  close(con)
  
  # Compress
  expect_true(dbf2dbc(tf_in, tf_dbc))
  
  # Decompress
  expect_true(dbc2dbf(tf_dbc, tf_out))
  
  # Compare
  expect_equal(file.info(tf_in)$size, file.info(tf_out)$size)
})

test_that("dbf2dbc compresses sids.dbc correctly", {
  # Input file
  input_dbc <- system.file("files/sids.dbc", package = "read.dbc")
  
  # Temp files
  temp_dbf_orig <- tempfile(fileext = ".dbf")
  temp_dbc_new <- tempfile(fileext = ".dbc")
  temp_dbf_new <- tempfile(fileext = ".dbf")
  
  on.exit({
    if (file.exists(temp_dbf_orig)) unlink(temp_dbf_orig)
    if (file.exists(temp_dbc_new)) unlink(temp_dbc_new)
    if (file.exists(temp_dbf_new)) unlink(temp_dbf_new)
  })
  
  # 1. Decompress original sids.dbc -> temp_dbf_orig
  expect_true(dbc2dbf(input_dbc, temp_dbf_orig))
  
  # 2. Compress temp_dbf_orig -> temp_dbc_new
  expect_true(dbf2dbc(temp_dbf_orig, temp_dbc_new))
  
  # 3. Decompress temp_dbc_new -> temp_dbf_new
  expect_true(dbc2dbf(temp_dbc_new, temp_dbf_new))
  
  # 4. Compare original DBF and new DBF
  # We can use tools::md5sum or read them as binary
  
  # Check file sizes first
  info_orig <- file.info(temp_dbf_orig)
  info_new <- file.info(temp_dbf_new)
  expect_equal(info_orig$size, info_new$size)
  
  # Check content
  con_orig <- file(temp_dbf_orig, "rb")
  bytes_orig <- readBin(con_orig, "raw", n = info_orig$size)
  close(con_orig)
  
  con_new <- file(temp_dbf_new, "rb")
  bytes_new <- readBin(con_new, "raw", n = info_new$size)
  close(con_new)
  
  expect_equal(bytes_orig, bytes_new)
})

test_that("dbf2dbc compresses storm.dbc correctly", {
    # Input file
    input_dbc <- system.file("files/storm.dbc", package = "read.dbc")
    
    # Temp files
    temp_dbf_orig <- tempfile(fileext = ".dbf")
    temp_dbc_new <- tempfile(fileext = ".dbc")
    temp_dbf_new <- tempfile(fileext = ".dbf")
    
    on.exit({
      if (file.exists(temp_dbf_orig)) unlink(temp_dbf_orig)
      if (file.exists(temp_dbc_new)) unlink(temp_dbc_new)
      if (file.exists(temp_dbf_new)) unlink(temp_dbf_new)
    })
    
    # 1. Decompress original storm.dbc -> temp_dbf_orig
    expect_true(dbc2dbf(input_dbc, temp_dbf_orig))
    
    # 2. Compress temp_dbf_orig -> temp_dbc_new
    expect_true(dbf2dbc(temp_dbf_orig, temp_dbc_new))
    
    # 3. Decompress temp_dbc_new -> temp_dbf_new
    expect_true(dbc2dbf(temp_dbc_new, temp_dbf_new))
    
    # 4. Compare original DBF and new DBF
    
    # Check file sizes first
    info_orig <- file.info(temp_dbf_orig)
    info_new <- file.info(temp_dbf_new)
    expect_equal(info_orig$size, info_new$size)
    
    # Check content
    con_orig <- file(temp_dbf_orig, "rb")
    bytes_orig <- readBin(con_orig, "raw", n = info_orig$size)
    close(con_orig)
    
    con_new <- file(temp_dbf_new, "rb")
    bytes_new <- readBin(con_new, "raw", n = info_new$size)
    close(con_new)
    
    expect_equal(bytes_orig, bytes_new)
  })
