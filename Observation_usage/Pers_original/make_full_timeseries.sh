#!/bin/bash

MANDTG=/home/fasg/bin/mandtg
DDIR=/scratch/fasg/CARRA2/aggregated_stats_wrk2

OUTDIR=$DDIR/full_time_series
HHLIST="00 03 06 09 12 15 18 21"

YMBEG=198509
YMEND=202512


YM=$YMBEG
while (( "$YM" <= "$YMEND" ));do



    if [[ -d $DDIR/$YM ]];then
	
	# If data exist
	
	cat $DDIR/$YM/carra2_landsynop_z_${YM}.dat >> $OUTDIR/carra2_landsynop_z.dat
	cat $DDIR/$YM/carra2_landsynop_t2m_${YM}.dat >> $OUTDIR/carra2_landsynop_t2m.dat
	cat $DDIR/$YM/carra2_landsynop_rh2m_${YM}.dat >> $OUTDIR/carra2_landsynop_rh2m.dat
	cat $DDIR/$YM/carra2_dribu_z_${YM}.dat     >> $OUTDIR/carra2_dribu_z.dat
	cat $DDIR/$YM/carra2_ship_z_${YM}.dat      >> $OUTDIR/carra2_ship_z.dat

	for varno in  2 3 7;do
	    
	    cat $DDIR/$YM/carra2_temp_${varno}_0_1500_${YM}.dat       >> $OUTDIR/carra2_temp_${varno}_0_1500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_12500_17500_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_12500_17500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_1500_2500_${YM}.dat    >> $OUTDIR/carra2_temp_${varno}_1500_2500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_17500_22500_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_17500_22500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_22500_27500_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_22500_27500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_2500_4000_${YM}.dat    >> $OUTDIR/carra2_temp_${varno}_2500_4000.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_27500_35000_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_27500_35000.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_35000_45000_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_35000_45000.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_4000_6500_${YM}.dat    >> $OUTDIR/carra2_temp_${varno}_4000_6500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_45000_60000_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_45000_60000.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_60000_80000_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_60000_80000.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_6500_8500_${YM}.dat    >> $OUTDIR/carra2_temp_${varno}_6500_8500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_80000_92500_${YM}.dat  >> $OUTDIR/carra2_temp_${varno}_80000_92500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_8500_12500_${YM}.dat   >> $OUTDIR/carra2_temp_${varno}_8500_12500.dat
	    cat $DDIR/$YM/carra2_temp_${varno}_92500_200000_${YM}.dat >> $OUTDIR/carra2_temp_${varno}_92500_200000.dat

	    if [[ $varno != "7" ]];then
		cat $DDIR/$YM/carra2_airep_${varno}_0_1500_${YM}.dat       >> $OUTDIR/carra2_airep_${varno}_0_1500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_12500_17500_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_12500_17500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_1500_2500_${YM}.dat    >> $OUTDIR/carra2_airep_${varno}_1500_2500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_17500_22500_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_17500_22500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_22500_27500_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_22500_27500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_2500_4000_${YM}.dat    >> $OUTDIR/carra2_airep_${varno}_2500_4000.dat
		cat $DDIR/$YM/carra2_airep_${varno}_27500_35000_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_27500_35000.dat
		cat $DDIR/$YM/carra2_airep_${varno}_35000_45000_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_35000_45000.dat
		cat $DDIR/$YM/carra2_airep_${varno}_4000_6500_${YM}.dat    >> $OUTDIR/carra2_airep_${varno}_4000_6500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_45000_60000_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_45000_60000.dat
		cat $DDIR/$YM/carra2_airep_${varno}_60000_80000_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_60000_80000.dat
		cat $DDIR/$YM/carra2_airep_${varno}_6500_8500_${YM}.dat    >> $OUTDIR/carra2_airep_${varno}_6500_8500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_80000_92500_${YM}.dat  >> $OUTDIR/carra2_airep_${varno}_80000_92500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_8500_12500_${YM}.dat   >> $OUTDIR/carra2_airep_${varno}_8500_12500.dat
		cat $DDIR/$YM/carra2_airep_${varno}_92500_200000_${YM}.dat >> $OUTDIR/carra2_airep_${varno}_92500_200000.dat
	    fi

	    cat $DDIR/$YM/carra2_tempdesc_${varno}_0_1500_${YM}.dat       >> $OUTDIR/carra2_tempdesc_${varno}_0_1500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_12500_17500_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_12500_17500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_1500_2500_${YM}.dat    >> $OUTDIR/carra2_tempdesc_${varno}_1500_2500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_17500_22500_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_17500_22500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_22500_27500_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_22500_27500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_2500_4000_${YM}.dat    >> $OUTDIR/carra2_tempdesc_${varno}_2500_4000.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_27500_35000_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_27500_35000.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_35000_45000_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_35000_45000.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_4000_6500_${YM}.dat    >> $OUTDIR/carra2_tempdesc_${varno}_4000_6500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_45000_60000_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_45000_60000.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_60000_80000_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_60000_80000.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_6500_8500_${YM}.dat    >> $OUTDIR/carra2_tempdesc_${varno}_6500_8500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_80000_92500_${YM}.dat  >> $OUTDIR/carra2_tempdesc_${varno}_80000_92500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_8500_12500_${YM}.dat   >> $OUTDIR/carra2_tempdesc_${varno}_8500_12500.dat
	    cat $DDIR/$YM/carra2_tempdesc_${varno}_92500_200000_${YM}.dat >> $OUTDIR/carra2_tempdesc_${varno}_92500_200000.dat

	done
    else
	
	# If not, create empty list with NaNs


	zYM=$YM
	YMD=$YM"01"
	while (( "$zYM" == "$YM" ));do
	    
	    for HH in $HHLIST;do
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/carra2_landsynop_z.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/carra2_landsynop_t2m.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/carra2_landsynop_rh2m.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/carra2_dribu_z.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/carra2_ship_z.dat
	    done
	    
	    for varno in  2 3 7;do
		
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_0_1500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_12500_17500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_1500_2500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_17500_22500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_22500_27500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_2500_4000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_27500_35000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_35000_45000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_4000_6500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_45000_60000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_60000_80000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_6500_8500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_80000_92500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_8500_12500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_temp_${varno}_92500_200000.dat

		if [[ $varno != "7" ]];then
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_0_1500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_12500_17500.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_1500_2500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_17500_22500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_22500_27500.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_2500_4000.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_27500_35000.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_35000_45000.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_4000_6500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_45000_60000.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_60000_80000.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_6500_8500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_80000_92500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_8500_12500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/carra2_airep_${varno}_92500_200000.dat
		fi

		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_0_1500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_12500_17500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_1500_2500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_17500_22500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_22500_27500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_2500_4000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_27500_35000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_35000_45000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_4000_6500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_45000_60000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_60000_80000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_6500_8500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_80000_92500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_8500_12500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/carra2_tempdesc_${varno}_92500_200000.dat
		
	    done
	    
	    YMD=$($MANDTG $YMD"00" + 24 | cut -c1-8)
	    zYM=$(echo $YMD | cut -c1-6)
	    
	done

	
    fi
    
    YM=$($MANDTG $YM"2800" + 120 | cut -c1-6)
done

