PDF = AA_Challenge_2025-2026_Steiner-tree.pdf
ARX = ST_Ciuca-Lucas_Tanasa-Cosmin_324CC.zip

.PHONY: all docs check pack clean
$(VERBOSE).SILENT:

all:
	echo "Choose between:"
	echo -e "\tdocs\tCreate documentation PDF."
	echo -e "\tcheck\tRun tests."
	echo -e "\tclean\tRemove created files."

docs:
	$(MAKE) -C docs all

check:
	$(MAKE) -C tests all

pack: docs
	cp docs/$(PDF) $(PDF)
	7z a -tzip $(ARX) README.md Makefile $(PDF) \
	src/README.md src/*.py \
	tests/README.md tests/Makefile tests/checker.sh tests/input/*
	rm $(PDF)

clean:
	$(MAKE) -C docs  clean
	$(MAKE) -C tests clean
	rm *.zip 2>/dev/null || echo "Nothing to clean."
