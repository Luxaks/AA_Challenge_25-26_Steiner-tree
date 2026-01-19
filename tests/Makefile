.PHONY: all clean
$(VERBOSE).SILENT:

all: checker.sh
	./checker.sh

clean:
	rm -rf output/ 2>/dev/null
	rm *.py 2>/dev/null || echo "Nothing to clean."