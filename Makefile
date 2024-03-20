AUTHORS = $(shell head -1 LICENSE |cut -d\  -f3-)

SRC = $(notdir $(wildcard src/*))
OBJ = build/obj/neutr.ins build/obj/neutr.dtx
DOC_PDF = build/doc/neutr.pdf
LICENSE = build/dist/COPYING
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
	mkdir -p build/dist
	cp -r static/* build/dist
	cd build/dist; unzip -o *.zip -d "template"
	rm build/dist/*.zip
	cp $(OBJ) $(DOC_PDF) build/dist
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
		-date "2023-$(shell date +%Y)" \
		-setambles ".*=>\nopreamble" \
		-doc "doc/neutr.tex" \
		-preamble "$(LICENSE_TEXT)" \
		neutr
	sed -e "$$(($$(wc -l < neutr.ins)-1))r patch/msg.txt" neutr.ins
	mv $(notdir $(OBJ)) build/obj

# Build Documentation PDF from neutr.dtx
$(DOC_PDF) : build/obj/neutr.dtx
	mkdir -p build/doc
	cp $< build/doc
	cd build/doc; $(LATEXMK) neutr.dtx

$(LICENSE) : LICENSE
	mkdir -p build/dist
	cp $^ $@

clean:
	rm -rf build
	rm -rf dist

.PHONY: default compile dist clean