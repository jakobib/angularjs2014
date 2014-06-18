NAME=angularjs-library-services

PANDOC = $(shell which pandoc)
ifeq ($(PANDOC),)
	PANDOC = $(error pandoc with pandoc-citeproc is required but not installed)
endif

$(NAME).html: $(NAME).md $(NAME).bib
	$(PANDOC) -s -S $< -o $@ --bibliography $(NAME).bib
