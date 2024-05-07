default: help

SRC=./src

.PHONY: lib
lib: clean # build the shared library version of dbc2dbf
	R CMD SHLIB -o src/db2dbf.so src/*.c -fsanitize=undefined

.PHONY: clean
clean: # clean generated files
	rm -rf revdep/*
	rm -f $(SRC)/*.o
	rm -f $(SRC)/*.so

.PHONY: check
check: # run CRAN checks
	Rscript -e "devtools::check(remote = TRUE, manual = FALSE)"
	Rscript -e "urlchecker::url_check()"

.PHONY: wincheck
wincheck: # run CRAN checks on Windows. Note: it uses a remote machine, check email for results
	Rscript -e "devtools::check_win_devel()"

.PHONY: revdep
revdep: # reverse dependency checks
	Rscript -e "revdepcheck::revdep_check(num_workers = 4)"

.PHONY: generate
generate: # generate C to R interface code
	Rscript -e 'tools::package_native_routine_registration_skeleton(".")' > src/read_dbc_init.c

.PHONY: setup
setup: # install tools necessary for building the package
	Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
	Rscript -e 'install.packages("roxygen2", repos="http://cran.us.r-project.org")'
	Rscript -e 'devtools::install_github("r-lib/revdepcheck")'
	Rscript -e "usethis::use_revdep()"

.PHONY: document
document: # generate R docs from source code
	Rscript -e "devtools::document()"

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: cran
cran: clean document check revdep # prepare the package for CRAN release
	@echo ======== BUILD COMPLETE ========
	@echo
	@echo New version is ready for publishing.
	@echo
	@echo Please check that the following tasks are completed before submitting to CRAN:
	@echo - Update NEWS.md with changelog
	@echo - Update cran-comments.md
	@echo
	@echo After the tasks above are completed, run the following command on the terminal to submit to CRAN:
	@echo
	@echo Rscript -e '"'devtools::submit_cran"()"'"'
	@echo
	@echo Don"'"t forget to push the updated files to GitHub and tag the release as a release candidate. For example:
	@echo
	@echo git tag 1.0.7-rc1 # create release candidate tag
	@echo git push --tags   # publish remote tag
	@echo
	@echo Once a submission is approved, create the corresponding release tag for the latest commit.
	@echo
	@echo