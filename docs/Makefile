TYP = typst compile
SRC = master.typ
PDF = AA_Challenge_2025-2026_Steiner-tree.pdf

.PHONY: all clean
$(VERBOSE).SILENT:

all: $(SRC)
	$(TYP) $< $(PDF)

clean:
	rm $(PDF) 2>/dev/null || echo "Nothing to clean."
