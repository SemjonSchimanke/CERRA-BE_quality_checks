#!/bin/bash

MANDTG=/home/fasg/bin/mandtg
DDIR=/scratch/fasg/CARRA2/aggregated_stats_wrk2
INDIR=$DDIR/full_time_series
OUTDIR=$DDIR/full_time_series_30davg

YMBEG=198509
YMEND=202512

cd $INDIR
INLIST=$(ls -1 *.dat)
cd ..


YM=$YMBEG
while (( "$YM" <= "$YMEND" ));do
    
    echo $YM
    
    for INF in $INLIST;do
	
	OF=$(echo $INF | sed s/\.dat/\_30davg\.dat/g)

	awk -v zym=$YM '{if(substr($1,1,6)==zym && $2 != "NaN")print $0}' $INDIR/$INF > tmp.dat
	if [[ -s tmp.dat ]];then
	    ZD=$(awk '{s1=s1+$2;s2=s2+$3;s3=s3+$4}END{print s1/NR,s2/NR,s3}' tmp.dat)
	    OUTDATA="$YM $ZD"
	else
	    OUTDATA="$YM NaN NaN NaN"
	fi

	echo $OUTDATA >> $OUTDIR/$OF

    done
       
    YM=$($MANDTG $YM"2800" + 120 | cut -c1-6)
done

