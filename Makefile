check:
	Rscript -e "devtools::check(remote = TRUE, manual = TRUE)"
	Rscript -e "urlchecker::url_check()"

wincheck:
	Rscript -e "devtools::check_win_devel()"

revdepcheck:
	Rscript -e 'devtools::install_github("r-lib/revdepcheck")'
	Rscript -e "usethis::use_revdep()"
	Rscript -e "revdepcheck::revdep_check(num_workers = 4)"

generate:
	Rscript -e 'tools::package_native_routine_registration_skeleton(".")' > src/read_dbc_init.c

setup:
	Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
	Rscript -e 'install.packages("roxygen2", repos="http://cran.us.r-project.org")'

document:
	Rscript -e "devtools::document()"