# makefile: Rnw -> tex -> pdf
# v 2.0
# .Rnw extension is automatically added
file_name = probability_hse_exams

$(file_name).pdf: $(file_name).tex chapters/*.tex chapters/*.Rnw
	# protection against biber error
	# http://tex.stackexchange.com/questions/140814/
	rm -rf `biber --cache`

	# create pdf
	# will automatically run pdflatex/biber if necessary
	latexmk -xelatex $(file_name).tex
	
	# clean
	latexmk -c $(file_name).tex


$(file_name).tex : $(file_name).Rnw chapters/*.Rnw
	Rscript -e "library(knitr); knit('$(file_name).Rnw')"

auto_figures_tikz/%.pdf: auto_figures_tikz/%.tex
	latexmk -xelatex -cd auto_figures_tikz/%.tex
	latexmk -c auto_figures_tikz/%.tex

clean:
	latexmk -c $(file_name).tex
	-rm $(file_name).amc $(file_name).bbl $(file_name).log
	-rm $(file_name).fdb_latexmk $(file_name).fls $(file_name).xdv
