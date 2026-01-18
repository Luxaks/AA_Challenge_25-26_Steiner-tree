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
echo "Testing small."
for INFILE in "$TESTS_SML"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    NUMB="${STRIP#$TESTS_SML}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST $NUMB.\n" >> $RES_SML
    echo -n "$NUMB: "

    echo -n  "1... "
    python3 $EXEC_BKT $INFILE "$OUTFILE.bkt.out" >> $RES_SML
    echo -n "2... "
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_SML
    echo "3... "
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_SML

done
echo -e "Finished small tests.\n"

# MEDIUM TESTS
echo -n > $RES_MED
echo "Testing medium."
for INFILE in "$TESTS_MED"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    NUMB="${STRIP#$TESTS_MED}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST $NUMB.\n" >> $RES_MED
    echo -n "$NUMB: "

    echo -n "1... "
    python3 $EXEC_BKT $INFILE "$OUTFILE.bkt.out" >> $RES_MED
    echo -n "2... "
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_MED
    echo "3... "
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_MED

done
echo -e "Finished medium tests.\n"

# LARGE TESTS
echo -n > $RES_LRG
echo "Testing large."
for INFILE in "$TESTS_LRG"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    NUMB="${STRIP#$TESTS_LRG}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST $NUMB.\n" >> $RES_LRG
    echo -n "$NUMB: "

    # at this point, BT would be far too slow
    echo -n "1... "
    # python3 $EXEC_BKT $INFILE "$OUTFILE.bkt.out" >> $RES_LRG
    echo -n "2... "
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_LRG
    echo "3... "
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_LRG
done
echo -e "Finished large tests.\n"
