#!/bin/bash -e
MANDTG=/home/fasg/bin/mandtg
DDIR=/scratch/smos/Observations/MFB
cd $DDIR

ls -l ??????/CERRA_landsynop_t2m_??????.dat > tmp_list.txt

YBEG=1961
YEND=2025

YYYY=$YBEG
while (( "$YYYY" <= "$YEND" ));do
    for MM in `seq -w 1 12`; do
	if ! grep -q "${YYYY}${MM}" tmp_list.txt; then
	    echo "    Missing:  $YYYY$MM"
	fi
    done
    YYYY=$((YYYY + 1))
done

rm tmp_list.txt



