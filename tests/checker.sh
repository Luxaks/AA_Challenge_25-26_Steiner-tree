SRC="../src"

EXEC_BT="$SRC/backtrack.py"
EXEC_GY="$SRC/greedy.py"
EXEC_DP="$SRC/DP_Fuchs.py"

TESTS_A="input/cosmin_tests"
TESTS_B="input/luke_tests"

TESTS_B_SML="$TESTS_B/small"
TESTS_B_MED="$TESTS_B/medium"
TESTS_B_LRG="$TESTS_B/large"


for INFILE in "$TESTS_B_SMALL"/*; do
    [ -f "$INFILE" ] || continue

    OUTFILE="output/${OUTFILE#input/}"
    OUTFILE="${INFILE%.*}"

    echo $OUTFILE

    # python3 $EXEC_BT $INFILE $OUTFILE
    # python3 $EXEC_GY $INFILE $OUTFILE
done