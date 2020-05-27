all: doc install check README.md site

site:
	Rscript -e 'setwd("pkg"); pkgdown::build_site()'

doc:
	Rscript -e 'setwd("pkg"); devtools::document()'

check:
	Rscript -e 'setwd("pkg"); devtools::check()'

build:
	Rscript -e 'setwd("pkg"); devtools::build()'

install:
	Rscript -e 'setwd("pkg"); devtools::install()'

README.md: README.Rmd
	Rscript -e "rmarkdown::render('README.Rmd', output_format = 'md_document')"
