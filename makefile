# makefile: Rnw -> tex -> pdf
# v 2.0
# .Rnw extension is automatically added
file_name = probability_hse_exams

auto_tikz_folder = auto_figures_tikz
r_plots_folder = R_plots

r_plots_files = $(wildcard $(r_plots_folder)/*.R)
# r_done_files = $(r_chunks_files:.R=.Rdone)


tikz_files = $(wildcard $(auto_tikz_folder)/*.tex)
# just replace .tex by .pdf for every file in tikz_files
pdf_from_tikz_files = $(r_plots_files:.R=.pdf)




$(file_name).pdf: $(file_name).tex chapters/*.tex chapters/*.Rnw $(pdf_from_tikz_files) $(r_done_files)
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


$(auto_tikz_folder)/%.pdf: $(auto_tikz_folder)/%.tex
	latexmk -xelatex -cd $<
	latexmk -c $<
	# $< means the name of the first prerequisite
	# %.pdf is a wildcard (every .pdf)

$(r_chunks_folder)/%.Rdone: $(r_chunks_folder)/%.R
	Rscript $<
	touch $@


clean:
	latexmk -c $(file_name).tex
	-rm $(file_name).amc $(file_name).bbl $(file_name).log
	-rm $(file_name).fdb_latexmk $(file_name).fls $(file_name).xdv

R: $(r_done_files)
