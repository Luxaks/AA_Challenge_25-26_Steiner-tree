#==================================================
#                    PREPARATION
#==================================================

# GET EXECS
EXEC_BKT="backtrack.py"
EXEC_DPF="fuchs.py"
EXEC_GDY="greedy.py"

cp "../src/$EXEC_BKT" $EXEC_BKT
cp "../src/$EXEC_DPF" $EXEC_DPF
cp "../src/$EXEC_GDY" $EXEC_GDY

# GET INPUTS
TESTS_SML="input/small/"
TESTS_MED="input/medium/"
TESTS_LRG="input/large/"
TESTS_ULT="input/extreme/"

# GET OUTPUTS
RES_SML="output/${TESTS_SML#input/}results.out"
RES_MED="output/${TESTS_MED#input/}results.out"
RES_LRG="output/${TESTS_LRG#input/}results.out"
RES_ULT="output/${TESTS_ULT#input/}results.out"

[ -d $(dirname $RES_SML) ] || mkdir -p $(dirname $RES_SML)
[ -d $(dirname $RES_MED) ] || mkdir -p $(dirname $RES_MED)
[ -d $(dirname $RES_LRG) ] || mkdir -p $(dirname $RES_LRG)
[ -d $(dirname $RES_ULT) ] || mkdir -p $(dirname $RES_ULT)

#==================================================
#                   MAIN TESTING
#==================================================

# SMALL TESTS
echo -n > $RES_SML
echo "Testing small..."
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
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_SML
    echo "3... "
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_SML

done
echo -e "Finished small tests.\n"

# MEDIUM TESTS
echo -n > $RES_MED
echo "Testing medium..."
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
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_MED
    echo "3... "
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_MED

done
echo -e "Finished medium tests.\n"

# LARGE TESTS
# at this point, BT is too slow to continue
echo -n > $RES_LRG
echo "Testing large..."
for INFILE in "$TESTS_LRG"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    NUMB="${STRIP#$TESTS_LRG}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST $NUMB.\n" >> $RES_LRG
    echo -n "$NUMB: "

    echo -n "1... "
    python3 $EXEC_DPF $INFILE "$OUTFILE.dpf.out" >> $RES_LRG
    echo "2... "
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_LRG
done
echo -e "Finished large tests.\n"

#==================================================
#        ABANDON ALL HOPE, YE WHO ENTER HERE
#==================================================

echo -n "Are you ready for the final challenge? (Y/N) "
while true; do
    read -r answer; answer=${answer^^} # toUpper
    case "$answer" in
        Y)  echo -n "Are you sure!? "
            break;;
        N)  echo "OK... coward!!"
            exit;;
        *)  echo -n "Invalid response!! ";;
    esac
done
while true; do
    read -r answer; answer=${answer^^} # toUpper
    case "$answer" in
        Y)  echo -n "Extreme tests incoming! "
            break;;
        N)  echo "You give up so easily..."
            exit;;
        *)  echo -n "Still invalid!! ";;
    esac
done

# ULTIMATE EXTREME TESTS
# at this point, both BT and DP would be far too slow
echo -n > $RES_ULT
echo "Testing ultimate..."
for INFILE in "$TESTS_ULT"*; do
    [ -f "$INFILE" ] || continue

    STRIP="${INFILE%.*}"
    NUMB="${STRIP#$TESTS_ULT}"
    OUTFILE="output/${STRIP#input/}"

    echo -e "TEST $NUMB.\n" >> $RES_ULT
    echo "$NUMB..."
    python3 $EXEC_GDY $INFILE "$OUTFILE.gdy.out" >> $RES_ULT
done
echo -e "Finished large tests.\n"
