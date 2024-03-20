AUTHORS = $(shell head -1 LICENSE |cut -d\  -f3-)

SRC = $(notdir $(wildcard src/*))
OBJ = build/obj/neutr.ins build/obj/neutr.dtx
DOC_PDF = build/doc/neutr.pdf
LICENSE = build/dist/neutr/COPYING
ARCHIVE = dist/neutr.zip
LICENSE_TEXT = $(shell cat LICENSE)

VPATH = src

#LATEXMK = latexmk -latexoption=-interaction=nonstopmode -latexoption=-halt-on-error -pdf
LATEXMK = texliveonfly --compiler=latexmk --arguments='-shell-escape -pdf'

MAKEDTX = build/tools/makedtx/makedtx.pl
MAKEDTX_ARCHIVE = makedtx-1_2.zip

default: compile

compile: $(OBJ) $(DOC_PDF)

dist : $(ARCHIVE)

$(ARCHIVE) : $(OBJ) $(DOC_PDF) $(LICENSE)
	mkdir -p build/dist/neutr
	cp -r static/* build/dist/neutr
	cd build/dist/neutr; unzip -o *.zip -d "template"
	rm build/dist/neutr/*.zip
	cp $(OBJ) $(DOC_PDF) build/dist/neutr
	chmod -R -x+X build/dist
	echo "== check files: falsely marked as executable? =="
	ls -l build/dist/neutr/*
	echo "== /check files =="
	mkdir -p dist
	cd build/dist; zip -r ../../$@ *

# Extract makedtx.pl
$(MAKEDTX) : dependencies/$(MAKEDTX_ARCHIVE)
	mkdir -p build/tools
	cd build/tools; unzip -o ../../$<
	cd build/tools/makedtx; latex makedtx.ins

# build dtx and ins files
$(OBJ) : $(SRC) $(MAKEDTX)
	mkdir -p build/obj
	perl $(MAKEDTX) \
		-macrocode ".*" \
		-src "($(subst $() $(),|,$(SRC)))=>\1" \
		-dir "src" \
		-author "$(AUTHORS)" \
		-date "0.1" \
		-setambles ".*=>\nopreamble" \
		-doc "doc/neutr.tex" \
		-preamble "$(LICENSE_TEXT)" \
		neutr
		# alternative to version-as-date (above): -date "2024-$(shell date +%Y)"
	sed -e "$$(($$(wc -l < neutr.ins)-1))r patch/msg.txt" neutr.ins
	mv $(notdir $(OBJ)) build/obj

# Build Documentation PDF from neutr.dtx
$(DOC_PDF) : build/obj/neutr.dtx
	mkdir -p build/doc
	cp $< build/doc
	cd build/doc; $(LATEXMK) neutr.dtx

$(LICENSE) : LICENSE
	mkdir -p build/dist/neutr
	cp $^ $@

clean:
	rm -rf build
	rm -rf dist

.PHONY: default compile dist clean