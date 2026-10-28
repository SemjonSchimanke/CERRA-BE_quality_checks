#!/bin/bash -e
#SBATCH --job-name=full_series
#SBATCH --qos=nf
#SBATCH --time=0-5

MANDTG=/home/fasg/bin/mandtg
DDIR=/scratch/smos/Observations/MFB

OUTDIR=$DDIR/full_time_series
if [[ -d $OUTDIR ]];then
    # Remove data if already existing
    rm $OUTDIR/*dat
    # OR extend it
#    echo "Extend data series"
else
    mkdir -p $OUTDIR
fi

HHLIST="00 03 06 09 12 15 18 21"

YMBEG=196101
YMEND=202512


YM=$YMBEG
while (( "$YM" <= "$YMEND" ));do
    echo "Working on $YM"

    if [[ -d $DDIR/$YM ]];then
	# If data exist

	cat $DDIR/$YM/CERRA_landsynop_z_${YM}.dat    >> $OUTDIR/CERRA_landsynop_z.dat
	cat $DDIR/$YM/CERRA_landsynop_t2m_${YM}.dat  >> $OUTDIR/CERRA_landsynop_t2m.dat
	cat $DDIR/$YM/CERRA_landsynop_rh2m_${YM}.dat >> $OUTDIR/CERRA_landsynop_rh2m.dat
	cat $DDIR/$YM/CERRA_dribu_z_${YM}.dat        >> $OUTDIR/CERRA_dribu_z.dat
	cat $DDIR/$YM/CERRA_ship_z_${YM}.dat         >> $OUTDIR/CERRA_ship_z.dat

	for varno in  2 3 7;do
	    
	    cat $DDIR/$YM/CERRA_temp_${varno}_0_1500_${YM}.dat       >> $OUTDIR/CERRA_temp_${varno}_0_1500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_12500_17500_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_12500_17500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_1500_2500_${YM}.dat    >> $OUTDIR/CERRA_temp_${varno}_1500_2500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_17500_22500_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_17500_22500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_22500_27500_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_22500_27500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_2500_4000_${YM}.dat    >> $OUTDIR/CERRA_temp_${varno}_2500_4000.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_27500_35000_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_27500_35000.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_35000_45000_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_35000_45000.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_4000_6500_${YM}.dat    >> $OUTDIR/CERRA_temp_${varno}_4000_6500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_45000_60000_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_45000_60000.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_60000_80000_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_60000_80000.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_6500_8500_${YM}.dat    >> $OUTDIR/CERRA_temp_${varno}_6500_8500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_80000_92500_${YM}.dat  >> $OUTDIR/CERRA_temp_${varno}_80000_92500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_8500_12500_${YM}.dat   >> $OUTDIR/CERRA_temp_${varno}_8500_12500.dat
	    cat $DDIR/$YM/CERRA_temp_${varno}_92500_200000_${YM}.dat >> $OUTDIR/CERRA_temp_${varno}_92500_200000.dat

	    if [[ $varno != "7" ]];then
		cat $DDIR/$YM/CERRA_airep_${varno}_0_1500_${YM}.dat       >> $OUTDIR/CERRA_airep_${varno}_0_1500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_12500_17500_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_12500_17500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_1500_2500_${YM}.dat    >> $OUTDIR/CERRA_airep_${varno}_1500_2500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_17500_22500_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_17500_22500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_22500_27500_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_22500_27500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_2500_4000_${YM}.dat    >> $OUTDIR/CERRA_airep_${varno}_2500_4000.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_27500_35000_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_27500_35000.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_35000_45000_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_35000_45000.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_4000_6500_${YM}.dat    >> $OUTDIR/CERRA_airep_${varno}_4000_6500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_45000_60000_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_45000_60000.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_60000_80000_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_60000_80000.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_6500_8500_${YM}.dat    >> $OUTDIR/CERRA_airep_${varno}_6500_8500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_80000_92500_${YM}.dat  >> $OUTDIR/CERRA_airep_${varno}_80000_92500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_8500_12500_${YM}.dat   >> $OUTDIR/CERRA_airep_${varno}_8500_12500.dat
		cat $DDIR/$YM/CERRA_airep_${varno}_92500_200000_${YM}.dat >> $OUTDIR/CERRA_airep_${varno}_92500_200000.dat
	    fi

	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_0_1500_${YM}.dat       >> $OUTDIR/CERRA_tempdesc_${varno}_0_1500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_12500_17500_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_12500_17500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_1500_2500_${YM}.dat    >> $OUTDIR/CERRA_tempdesc_${varno}_1500_2500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_17500_22500_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_17500_22500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_22500_27500_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_22500_27500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_2500_4000_${YM}.dat    >> $OUTDIR/CERRA_tempdesc_${varno}_2500_4000.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_27500_35000_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_27500_35000.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_35000_45000_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_35000_45000.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_4000_6500_${YM}.dat    >> $OUTDIR/CERRA_tempdesc_${varno}_4000_6500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_45000_60000_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_45000_60000.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_60000_80000_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_60000_80000.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_6500_8500_${YM}.dat    >> $OUTDIR/CERRA_tempdesc_${varno}_6500_8500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_80000_92500_${YM}.dat  >> $OUTDIR/CERRA_tempdesc_${varno}_80000_92500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_8500_12500_${YM}.dat   >> $OUTDIR/CERRA_tempdesc_${varno}_8500_12500.dat
	    cat $DDIR/$YM/CERRA_tempdesc_${varno}_92500_200000_${YM}.dat >> $OUTDIR/CERRA_tempdesc_${varno}_92500_200000.dat

	done

    else
	# If not, create empty list with NaNs

	zYM=$YM
	YMD=$YM"01"
	while (( "$zYM" == "$YM" ));do
	    
	    for HH in $HHLIST;do
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/CERRA_landsynop_z.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/CERRA_landsynop_t2m.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/CERRA_landsynop_rh2m.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/CERRA_dribu_z.dat
		echo $YMD$HH NaN NaN NaN >> $OUTDIR/CERRA_ship_z.dat
	    done
	    
	    for varno in  2 3 7;do
		
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_0_1500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_12500_17500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_1500_2500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_17500_22500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_22500_27500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_2500_4000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_27500_35000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_35000_45000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_4000_6500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_45000_60000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_60000_80000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_6500_8500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_80000_92500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_8500_12500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_temp_${varno}_92500_200000.dat

		if [[ $varno != "7" ]];then
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_0_1500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_12500_17500.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_1500_2500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_17500_22500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_22500_27500.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_2500_4000.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_27500_35000.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_35000_45000.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_4000_6500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_45000_60000.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_60000_80000.dat
	            echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_6500_8500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_80000_92500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_8500_12500.dat
		    echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_airep_${varno}_92500_200000.dat
		fi

		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_0_1500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_12500_17500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_1500_2500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_17500_22500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_22500_27500.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_2500_4000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_27500_35000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_35000_45000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_4000_6500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_45000_60000.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_60000_80000.dat
	        echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_6500_8500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_80000_92500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_8500_12500.dat
		echo $YMD NaN NaN NaN >> $OUTDIR/CERRA_tempdesc_${varno}_92500_200000.dat
		
	    done
	    
	    YMD=$($MANDTG $YMD"00" + 24 | cut -c1-8)
	    zYM=$(echo $YMD | cut -c1-6)
	    
	done

    fi
    
    YM=$($MANDTG $YM"2800" + 120 | cut -c1-6)
done

echo "$0 finished successfully."
