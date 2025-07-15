# Check for UBSan and ASan issues
# To run locally:
# docker run -it --rm -v $(pwd):/mypkg -w /mypkg wch/r-debug
# R -f scripts/run-sanitizer-checks.R
devtools::check(args = c("--as-cran"), env = c("ASAN_OPTIONS=detect_leaks=0", "_R_CHECK_AS_CRAN_" = "true"))
