This repository contains an article about AngularJS and some AngularJS modules
to make use of library-related services. The article is written in Pandoc
Markdown syntax in file `angularjs-library-services.md`. References are given
in BibTeX syntax in file `angularjs-library-services.bib`. The file `Makefile`
can be used to call the conversion from Markdown and BibTeX to HTML:

    apt-get install pandoc pandoc-citeproc
    make

HTML layout (defined in `code4lib.css`) and reference style (defined in
`council-of-science-editors-author-date.csl`) are chosen to reproduce layout of
[Code4Li Journal](http://journal.code4lib.org/).

The directory `examples` contains the code examples included in the article
with all of its dependencies.

![](https://travis-ci.org/jakobib/angularjs2014.svg?branch=master)
