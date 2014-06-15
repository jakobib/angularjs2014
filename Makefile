NAME=angularjs-library-services

$(NAME).html: $(NAME).md $(NAME).bib
	pandoc -s -S $< -o $@ --bibliography $(NAME).bib
