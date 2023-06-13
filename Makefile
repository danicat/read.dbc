check:
	Rscript -e "devtools::check()"

generate:
	Rscript -e 'tools::package_native_routine_registration_skeleton(".")' > src/read_dbc_init.c

setup:
	Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
	Rscript -e 'install.packages("roxygen2", repos="http://cran.us.r-project.org")'

document:
	Rscript -e "devtools::document()"