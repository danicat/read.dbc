## Release information

* Removed broken links
* Improved error handling in blast.c to prevent runtime errors (fixes gcc-UBSAN)
* Update DESCRIPTION with collaborators
* Documentation edits for conciseness
* Overall doc improvements

## R CMD check results

Duration: 28s

❯ checking CRAN incoming feasibility ... [3s/18s] NOTE
  Maintainer: ‘Daniela Petruzalek <daniela.petruzalek@gmail.com>’
  
  New submission
  
  Package was archived on CRAN
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2023-11-20 as issues were not corrected
      in time.

0 errors ✔ | 0 warnings ✔ | 1 note ✖
Rscript -e "urlchecker::url_check()"
✔ All URLs are correct!
Rscript -e "devtools::check_win_devel()"
Building windows version of read.dbc (1.0.7)
ℹ Using R-devel with win-builder.r-project.org.

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

