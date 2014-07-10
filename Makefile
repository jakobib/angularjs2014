NAME  = angularjs-library-services
ABOUT = metadata.yml

PANDOC = $(shell which pandoc)
ifeq ($(PANDOC),)
	PANDOC = $(error pandoc with pandoc-citeproc is required but not installed)
endif

$(NAME).html: $(ABOUT) $(NAME).md $(NAME).bib
	@$(PANDOC) -s -S -t html5 $(ABOUT) $(NAME).md \
	   --template code4lib.html \
	   --bibliography $(NAME).bib \
	   --css code4lib.css \
	   --csl council-of-science-editors-author-date.csl \
	   | sed 's/^<hr \/>/<h1>Endnotes<\/h1>/' > $@
