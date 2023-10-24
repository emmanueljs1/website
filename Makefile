all: resume

resume:
	latexmk -bibtex -xelatex -outdir=files/ tex/resume.tex
