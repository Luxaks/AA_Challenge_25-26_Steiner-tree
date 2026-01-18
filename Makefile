.PHONY: all docs check clean
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

clean:
	$(MAKE) -C docs  clean
	$(MAKE) -C tests clean