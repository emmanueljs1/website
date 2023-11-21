.PHONY: all

all: site

site: drafts.html site.hs files/resume.pdf
	cabal new-run site build

watch:
	cabal new-run site watch

drafts.html: bib/drafts.bib
	bibtex2html -nodoc -nobibsource -d -r -noheader -nofooter bib/drafts.bib

files/resume.pdf: tex/resume.tex
	latexmk -bibtex -xelatex -outdir=files/ tex/resume.tex

clean:
	rm -rf dist_newstyle/ _site/ _cache/ files/resume.pdf
