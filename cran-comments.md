## Release information

Update: LICENSE file removed and DESCRIPTION updated

This package was available on CRAN since 2016, but was removed from CRAN due to the following:

'Packages which use Internet resources should fail gracefully with an informative message
if the resource is not available or has changed (and not give a check warning nor error).'

This was flagged because I used `download.file` in one of my examples. This example has been removed from this version. I've also made changes to make it up to current standards, e.g., adding a NEWS.md file and this cran-comments.md file, and also running all standard checks.

## R CMD check results

Duration: 16.6s

❯ checking CRAN incoming feasibility ... [2s/11s] NOTE
  Maintainer: ‘Daniela Petruzalek <daniela.petruzalek@gmail.com>’
  
  New submission
  
  Package was archived on CRAN
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2023-04-07 for policy violation.
  
    On Internet access.

0 errors ✔ | 0 warnings ✔ | 1 note ✖

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

