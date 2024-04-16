.PHONY: all

LAGDAS=$(wildcard lagda/*.lagda.md)
POSTS=$(patsubst lagda/%.lagda.md, posts/%.md, $(LAGDAS))

all: site

posts/%.md: lagda/%.lagda.md
	agda --html --html-highlight=code $^
	mv html/lagda.$*.md posts/$*.md
	rm -rf html/

posts: $(LAGDAS)
	for post in $(POSTS) ; do \
		make $$post ; \
	done

site: site.hs files/resume.pdf $(POSTS)
	cabal new-run site build

watch:
	cabal new-run site watch

files/resume.pdf: tex/resume.tex
	latexmk -bibtex -xelatex -outdir=files/ tex/resume.tex

deploy:
	make clean
	make site
	git checkout site
	git pull
	git rm -r .
	git reset -- CNAME .gitignore
	git checkout -- CNAME .gitignore
	cp -r _site/ .
	git add .
	git commit -m "update site"
	git push
	git checkout main

clean:
	rm -rf dist_newstyle/ _site/ _cache/

realclean: clean
	cabal clean
	rm files/resume.pdf
