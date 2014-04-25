paper.html: paper.md
	pandoc -s -S paper.md -o paper.html
