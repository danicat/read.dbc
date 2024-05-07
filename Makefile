SRC=./src

.PHONY: lib
lib: clean
	R CMD SHLIB -o src/db2dbf.so src/*.c -fsanitize=undefined

.PHONY: clean
clean:
	rm -rf revdep/*
	rm -f $(SRC)/*.o
	rm -f $(SRC)/*.so

.PHONY: check
check:
	Rscript -e "devtools::check(remote = TRUE, manual = FALSE)"
	Rscript -e "urlchecker::url_check()"

.PHONY: wincheck
wincheck:
	Rscript -e "devtools::check_win_devel()"

.PHONY: revdepcheck
revdepcheck:
	Rscript -e 'devtools::install_github("r-lib/revdepcheck")'
	Rscript -e "usethis::use_revdep()"
	Rscript -e "revdepcheck::revdep_check(num_workers = 4)"

.PHONY: generate
generate:
	Rscript -e 'tools::package_native_routine_registration_skeleton(".")' > src/read_dbc_init.c

.PHONY: setup
setup:
	Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
	Rscript -e 'install.packages("roxygen2", repos="http://cran.us.r-project.org")'

.PHONY: document
document:
	Rscript -e "devtools::document()"

.PHONY: cran
cran: clean document check wincheck revdepcheck
	@echo ======== BUILD COMPLETE ========
	@echo
	@echo New version is ready for publishing. Please check that the following tasks are completed before submitting to CRAN:
	@echo - Update NEWS.md with changelog
	@echo - Update cran-comments.md
	@echo
	@echo After the tasks above are completed, run the following command on the terminal to submit to CRAN:
	@echo
	@echo 	Rscript -e "devtools::submit_cran()"
	@echo