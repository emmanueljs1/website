all: resume

resume:
	latexmk -bibtex -xelatex -outdir=app/public/files/ tex/resume.tex
