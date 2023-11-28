.PHONY: all

LAGDAS=$(wildcard lagda/*.lagda.md)
POSTS=$(patsubst lagda/%.lagda.md, posts/%.md, $(lagda))

all: site

posts/%.md: lagda/%.lagda.md
	agda --html --html-highlight=code $^
	mv html/lagda.$*.md posts/$*.md

posts: $(LAGDAS)
	for post in $(POSTS) ; do \
		make $$post ; \
	done

site: drafts.html site.hs files/resume.pdf $(POSTS)
	cabal new-run site build

watch:
	cabal new-run site watch

drafts.html: bib/drafts.bib
	bibtex2html -nodoc -nobibsource -d -r -noheader -nofooter bib/drafts.bib

files/resume.pdf: tex/resume.tex
	latexmk -bibtex -xelatex -outdir=files/ tex/resume.tex

deploy:
	make clean
	make
	git checkout site
	git pull
	cp -r _site/ .
	git add .
	git commit -m "update site"
	git push
	git checkout main

clean:
	rm -rf dist_newstyle/ _site/ _cache/

realclean: clean
	rm files/resume.pdf
