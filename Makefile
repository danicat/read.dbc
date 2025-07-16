.DEFAULT_GOAL := help

SRC := ./src
PKG_NAME := read.dbc

.PHONY: all
all: document generate lib ## Generate all package files

.PHONY: lib
lib: src/read_dbc_init.c ## Build the shared library
	R CMD SHLIB -o $(SRC)/$(PKG_NAME).so $(SRC)/*.c

.PHONY: clean
clean: ## Clean generated build files
	rm -f $(SRC)/*.o
	rm -f $(SRC)/*.so
	rm -f man/*.Rd
	rm -f src/read_dbc_init.c

.PHONY: clean-revdep
clean-revdep: ## Clean reverse dependency check files
	rm -rf revdep/*

.PHONY: check
check: all ## Run CRAN checks
	Rscript -e "devtools::check(remote = TRUE, manual = FALSE)"
	Rscript -e "urlchecker::url_check()"

.PHONY: test
test: ## Run tests
	Rscript -e "devtools::test()"

.PHONY: check-sanitized
check-sanitized: ## Run CRAN checks with ASAN and UBSAN
	docker run --rm -v $PWD:/work r-devel-sanitized R CMD check /work

.PHONY: wincheck
wincheck: ## Run CRAN checks on Windows
	Rscript -e "devtools::check_win_devel()"

.PHONY: revdep
revdep: ## Reverse dependency checks
	Rscript -e "revdepcheck::revdep_check(num_workers = 4)"

.PHONY: generate
generate: src/read_dbc_init.c ## Generate C to R interface code

src/read_dbc_init.c: $(SRC)/dbc2dbf.c $(SRC)/blast.c
	Rscript -e 'tools::package_native_routine_registration_skeleton(".")' > src/read_dbc_init.c

.PHONY: setup
setup: ## Install development dependencies
	Rscript -e 'install.packages(c("devtools", "roxygen2", "usethis", "revdepcheck"), repos="http://cran.us.r-project.org")'
	Rscript -e "usethis::use_revdep()"

.PHONY: document
document: ## Generate R docs from source code
	Rscript -e "devtools::document()"

.PHONY: cran
cran: all check revdep ## Prepare the package for CRAN release
	@echo "======== BUILD COMPLETE ========"
	@echo
	@echo "New version is ready for publishing."
	@echo
	@echo "Please check that the following tasks are completed before submitting to CRAN:"
	@echo "- Update inst/CHANGELOG.md"
	@echo "- Update NEWS.md"
	@echo "- Update cran-comments.md"
	@echo
	@echo "After the tasks above are completed, run 'devtools::submit_cran()' from R to submit to CRAN."

.PHONY: help
help: ## Show help for each of the Makefile recipes
	@grep -E '^[a-zA-Z0-9 -]+:.*##' Makefile | sort | while read -r l; do printf " [1;32m$$(echo $$l | cut -f 1 -d':') [00m:$$(echo $$l | cut -f 2- -d'#')\n"; done