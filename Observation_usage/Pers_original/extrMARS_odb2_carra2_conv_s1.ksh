#!/bin/ksh
#SBATCH --error=/scratch/fasg/CARRA2/aggregated_stats_wrk2/c2stat1.%j.log
#SBATCH --output=/scratch/fasg/CARRA2/aggregated_stats_wrk2/c2stat1.%j.log
#SBATCH --job-name=c2stat1
#SBATCH --qos=nf
#SBATCH --account=c3srrp

function stat_surf {

    YM=$1

    [[ -e out.dat ]] && /bin/rm out.dat
    odc sql -q "SELECT 
andate,
antime,
STDEV(fg_depar@body) as stdev_fgdep,
STDEV(an_depar@body) as stdev_andep,
count(*) as numobs 
WHERE varno=1 AND obstype=1 AND 
(codetype=11 OR codetype=14 OR codetype=170)" -i conv_carra2_${YM}.mfb -o out.dat -f ascii
    grep $YM out.dat | awk '{printf("%6.6i%2.2i %f %f %f\n",$1,$2/10000,$3,$4,$5)}' > carra2_landsynop_z_${YM}.dat

    [[ -e out.dat ]] && /bin/rm out.dat
    odc sql -q "SELECT 
andate,
antime,
STDEV(fg_depar@surfbody_feedback) as stdev_fgdep,
STDEV(an_depar@surfbody_feedback) as stdev_andep,
count(*) as numobs 
WHERE varno=39 AND obstype=1 AND datum_status@surfbody_feedback=1 AND  
(codetype=11 OR codetype=14 OR codetype=170)" -i conv_carra2_${YM}.mfb -o out.dat -f ascii
    grep $YM out.dat | awk '{printf("%6.6i%2.2i %f %f %f\n",$1,$2/10000,$3,$4,$5)}' > carra2_landsynop_t2m_${YM}.dat
    
    [[ -e out.dat ]] && /bin/rm out.dat
    odc sql -q "SELECT 
andate,
antime,
STDEV(fg_depar@surfbody_feedback) as stdev_fgdep,
STDEV(an_depar@surfbody_feedback) as stdev_andep,
count(*) as numobs 
WHERE varno=58 AND obstype=1 AND datum_status@surfbody_feedback=1 AND  
(codetype=11 OR codetype=14 OR codetype=170)" -i conv_carra2_${YM}.mfb -o out.dat -f ascii
    grep $YM out.dat | awk '{printf("%6.6i%2.2i %f %f %f\n",$1,$2/10000,$3,$4,$5)}' > carra2_landsynop_rh2m_${YM}.dat

    [[ -e out.dat ]] && /bin/rm out.dat
    odc sql -q "SELECT 
andate,
antime,
STDEV(fg_depar@body) as stdev_fgdep,
STDEV(an_depar@body) as stdev_andep,
count(*) as numobs 
WHERE varno=1 AND obstype=1 AND 
(codetype=21 OR codetype=24 OR codetype=182)" -i conv_carra2_${YM}.mfb -o out.dat -f ascii
    grep $YM out.dat | awk '{printf("%6.6i%2.2i %f %f %f\n",$1,$2/10000,$3,$4,$5)}' > carra2_ship_z_${YM}.dat
    
    [[ -e out.dat ]] && /bin/rm out.dat
    odc sql -q "SELECT 
andate,
antime,
STDEV(fg_depar@body) as stdev_fgdep,
STDEV(an_depar@body) as stdev_andep,
count(*) as numobs 
WHERE varno=1 AND obstype=4" -i conv_carra2_${YM}.mfb -o out.dat -f ascii
    grep $YM out.dat | awk '{printf("%6.6i%2.2i %f %f %f\n",$1,$2/10000,$3,$4,$5)}' > carra2_dribu_z_${YM}.dat

    /bin/rm out.dat

    DTG1=${YM}0100
    YMtmp=$($MANDTG $DTG1 + 768 | cut -c1-6)
    DTG2=$($MANDTG ${YMtmp}0100 + -3)

    OFILES="
carra2_dribu_z_${YM}.dat
carra2_landsynop_z_${YM}.dat
carra2_ship_z_${YM}.dat
carra2_landsynop_t2m_${YM}.dat
carra2_landsynop_rh2m_${YM}.dat
"
    
    DTG=$DTG1
    while [[ $DTG -le $DTG2 ]];do
	for FF in $OFILES;do
	    OUT=$(grep $DTG $FF | awk '{print $2,$3,$4}')
	    [[ $OUT == "" ]] && OUT="NaN NaN NaN"
	    echo $DTG $OUT >> ${FF}.new
	done
	DTG=$($MANDTG $DTG + 3)
    done

    for FF in $OFILES;do
	/bin/mv ${FF}.new $FF
    done


}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
function stat_temp {

    YM=$1

    LEVL="0 1500 2500 4000 6500 8500 12500 17500 22500 27500 35000 45000 60000 80000 92500 200000"
    NUMLEVS=15

    for DOMAIN in carra2;do
    for varno in 2 3 7;do

    nlev=1
    while (( "$nlev" <= "$NUMLEVS" ));do

	plev1=$(echo $LEVL | awk -v nlev=$nlev  '{print $nlev}')
	plev2=$(echo $LEVL | awk -v nlev=$nlev  '{print $(nlev+1)}')
    
	[[ -e out.dat ]] && /bin/rm out.dat
	odc sql -q "SELECT 
andate,
STDEV(fg_depar@body) as stdev_fgdep,
STDEV(an_depar@body) as stdev_andep,
count(*) as numobs 
WHERE varno=$varno AND obstype=5 AND codetype!=231 AND datum_status@body=1 AND an_depar@body is not NULL AND 
vertco_reference_1>$plev1 AND vertco_reference_1<=$plev2" -i conv_${DOMAIN}_${YM}.mfb -o out.dat -f ascii
	grep $YM out.dat | awk '{printf("%6.6i %f %f %f\n",$1,$2,$3,$4)}' > ${DOMAIN}_temp_${varno}_${plev1}_${plev2}_${YM}.dat
	
	[[ -e out.dat ]] && /bin/rm out.dat
	odc sql -q "SELECT 
andate,
STDEV(fg_depar@body) as stdev_fgdep,
STDEV(an_depar@body) as stdev_andep,
count(*) as numobs 
WHERE varno=$varno AND obstype=5 AND codetype=231 AND datum_status@body=1 AND an_depar@body is not NULL AND 
vertco_reference_1>$plev1 AND vertco_reference_1<=$plev2" -i conv_${DOMAIN}_${YM}.mfb -o out.dat -f ascii
	grep $YM out.dat | awk '{printf("%6.6i %f %f %f\n",$1,$2,$3,$4)}' > ${DOMAIN}_tempdesc_${varno}_${plev1}_${plev2}_${YM}.dat

	
	((nlev=$nlev + 1))
    done
    
    done
    done

    DTG1=${YM}01
    YMtmp=$($MANDTG $DTG1"00" + 768 | cut -c1-6)
    DTG2=$($MANDTG ${YMtmp}0100 + -3 | cut -c1-8)

    OFILES=$(ls -1 *temp*)
    
    DTG=$DTG1
    while [[ $DTG -le $DTG2 ]];do
	for FF in $OFILES;do
	    OUT=$(grep $DTG $FF | awk '{print $2,$3,$4}')
	    [[ $OUT == "" ]] && OUT="NaN NaN NaN"
	    echo $DTG $OUT >> ${FF}.new
	done
	DTG=$($MANDTG $DTG"21" + 3 | cut -c1-8)
    done

    for FF in $OFILES;do
	/bin/mv ${FF}.new $FF
    done

    
}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
function stat_airep {

    YM=$1

    LEVL="0 1500 2500 4000 6500 8500 12500 17500 22500 27500 35000 45000 60000 80000 92500 200000"
    NUMLEVS=15

    for DOMAIN in carra2;do
    for varno in 2 3;do

    nlev=1
    while (( "$nlev" <= "$NUMLEVS" ));do

	plev1=$(echo $LEVL | awk -v nlev=$nlev  '{print $nlev}')
	plev2=$(echo $LEVL | awk -v nlev=$nlev  '{print $(nlev+1)}')
    
	[[ -e out.dat ]] && /bin/rm out.dat
	odc sql -q "SELECT 
andate,
STDEV(fg_depar@body) as stdev_fgdep,
STDEV(an_depar@body) as stdev_andep,
count(*) as numobs 
WHERE varno=$varno AND obstype=2 AND datum_status@body=1 AND an_depar@body is not NULL AND 
vertco_reference_1>$plev1 AND vertco_reference_1<=$plev2" -i conv_${DOMAIN}_${YM}.mfb -o out.dat -f ascii
	grep $YM out.dat | awk '{printf("%6.6i %f %f %f\n",$1,$2,$3,$4)}' > ${DOMAIN}_airep_${varno}_${plev1}_${plev2}_${YM}.dat

	
	((nlev=$nlev + 1))
    done
    
    done
    done

    DTG1=${YM}01
    YMtmp=$($MANDTG $DTG1"00" + 768 | cut -c1-6)
    DTG2=$($MANDTG ${YMtmp}0100 + -3 | cut -c1-8)

    OFILES=$(ls -1 carra2_airep*dat)
    
    DTG=$DTG1
    while [[ $DTG -le $DTG2 ]];do
	for FF in $OFILES;do
	    OUT=$(grep $DTG $FF | awk '{print $2,$3,$4}')
	    [[ $OUT == "" ]] && OUT="NaN NaN NaN"
	    echo $DTG $OUT >> ${FF}.new
	done
	DTG=$($MANDTG $DTG"21" + 3 | cut -c1-8)
    done

    for FF in $OFILES;do
	/bin/mv ${FF}.new $FF
    done

    
}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
function create_request {
    
    cat > mars_request.dat <<EOF
RETRIEVE,
    ORIGIN     = se-al-ec,
    CLASS      = rr,
    EXPVER     = prod,
    STREAM     = oper,
    TYPE       = mfb,
    OBSGROUP   = CONV,
    DATE       = ${YMDLIST},
    TIME       = 00/03/06/09/12/15/18/21,
    TARGET     = "$WDIR/$YM/conv_carra2_${YM}.mfb"
EOF


}

#================================================
#================================================
#================================================

module load ecmwf-toolbox

MANDTG=/home/fasg/bin/mandtg
WDIR=/scratch/fasg/CARRA2/aggregated_stats_wrk2

#YMLIST=$(grep -m 4 f ../fetchlists/s1_flist.dat | awk '{print $1}')
YMLIST="199003 199004 199005"

[[ -d $WDIR ]] || mkdir -p $WDIR

cd $WDIR

for YM in $YMLIST;do

    YEAR=$(echo $YM | cut -c1-4)
    MONTH=$(echo $YM | cut -c5-6)

    DTG1=${YEAR}${MONTH}0100
    YMtmp=$($MANDTG $DTG1 + 768 | cut -c1-6)
    DTG2=$($MANDTG ${YMtmp}0100 + -3)
	
    echo $YM $DTG1 $DTG2

    YMDLIST=""
    DTG=$DTG1
    while [[ $DTG -le $DTG2 ]];do
	YMD=$(echo $DTG | cut -c1-8)
	if [[ $DTG -eq $DTG1 ]];then
	    YMDLIST=$YMD
	else
	    YMDLIST=$YMDLIST"/"$YMD
	fi
	DTG=$($MANDTG $DTG + 24)
    done

    [[ -d $WDIR/$YM ]] || mkdir $WDIR/$YM
    cd $WDIR/$YM
    if [[ -s getmarsdone.dat ]];then
	echo "Data already fetched from MARS"
    else
	create_request
	mars < mars_request.dat
	echo "yes" > getmarsdone.dat
    fi

     stat_surf $YM
     stat_temp $YM
     stat_airep $YM

     /bin/rm conv_carra2_${YM}.mfb
     /bin/rm getmarsdone.dat
     /bin/rm mars_request.dat
     /bin/rm out.dat
         
done
