#!/bin/bash -e
MANDTG=/home/fasg/bin/mandtg
DDIR=/scratch/smos/Observations/MFB
cd $DDIR

YMBEG=196101
YMEND=202512

YM=$YMBEG
while (( "$YM" <= "$YMEND" ));do
    if [[ ! -f ${YM}/CERRA_landsynop_t2m_${YM}.dat ]]; then
	echo "    Missing:  $YM"
    fi
    YM=$($MANDTG $YM"2800" + 120 | cut -c1-6)
done





