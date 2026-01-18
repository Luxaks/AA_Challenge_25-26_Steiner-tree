.PHONY: all docs check clean
$(VERBOSE).SILENT:

all: docs check clean

check:
	$(MAKE) -C tests all

docs:
	$(MAKE) -C docs all

clean:
	$(MAKE) -C docs clean