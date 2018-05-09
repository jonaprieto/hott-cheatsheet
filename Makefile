sheets := $(wildcard src/hott-*.tex)
pdfs   := $(subst src/,docs/,$(subst .tex,.pdf,$(sheets)))
thumbnails := $(subst src/,assets/,$(subst .tex,.png,$(sheets)))

all: $(pdfs) $(thumbnails)

docs/%.pdf : src/%.tex
	- @rm $@
	- @latexmk -cd -e -f -pdf -interaction=nonstopmode -synctex=1 \
		-output-directory=./../docs \
		$<
	- @find docs ! -name *.pdf -maxdepth 1 -type f -delete

assets/%.png : docs/%.pdf
	- @rm $@
	- @gs -sDEVICE=png16m \
		 -r1200 \
		 -dPDFFitPage=true \
		 -dDEVICEWIDTHPOINTS=250 \
		 -dDEVICEHEIGHTPOINTS=150 \
		 -dDownScaleFactor=4 \
		 -sOutputFile=$@ \
		 -dLastPage=1 \
		 -dBATCH -dNOPAUSE \
		 $<

.phony: watch
watch:
	- watchmedo shell-command \
		--patterns="*" \
		--recursive \
		--command='make' \
		src

.phony: clean
clean:
	- rm assets/*
	- rm docs/*
