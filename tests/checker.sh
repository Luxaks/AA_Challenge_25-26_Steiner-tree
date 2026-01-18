SRC="../src"

EXEC_BKT="backtrack.py"
EXEC_GDY="greedy.py"
EXEC_DPF="fuchs.py"

TESTS_SML="input/small/"
TESTS_MED="input/medium/"
TESTS_LRG="input/large/"

RES_SML="output/${TESTS_SML#input/}results.out"
RES_MED="output/${TESTS_MED#input/}results.out"
RES_LRG="output/${TESTS_LRG#input/}results.out"

cp "$SRC/$EXEC_BKT" $EXEC_BKT
cp "$SRC/$EXEC_GDY" $EXEC_GDY
cp "$SRC/$EXEC_DPF" $EXEC_DPF

# SMALL TESTS
echo -n > $RES_SML
for INFILE in "$TESTS_SML"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST ${STRIP#$TESTS_SML}.\n" >> $RES_SML

    python3 $EXEC_BKT $INFILE "$OUTFILE.bkt.out" >> $RES_SML
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_SML
    # python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out"
done

# MEDIUM TESTS
echo -n > $RES_MED
for INFILE in "$TESTS_MED"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST ${STRIP#$TESTS_MED}.\n" >> $RES_MED

    python3 $EXEC_BKT $INFILE "$OUTFILE.bkt.out" >> $RES_MED
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_MED
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_MED
done

# LARGE TESTS
echo -n > $RES_LRG
for INFILE in "$TESTS_LRG"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST ${STRIP#$TESTS_LRG}.\n" >> $RES_LRG

    # at this point, BT would be far too slow
    # python3 $EXEC_BKT $INFILE "$OUTFILE.bkt.out" >> $RES_LRG
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_LRG
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_LRG
done