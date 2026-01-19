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
	7z a -tzip arhiva README.md Makefile \
	docs/README.md docs/*.pdf \
	src/README.md src/*.py \
	tests/README.md tests/Makefile tests/checker.sh tests/input/*

clean:
	$(MAKE) -C docs  clean
	$(MAKE) -C tests clean
	rm *.zip 2>/dev/null || echo "Nothing to clean."