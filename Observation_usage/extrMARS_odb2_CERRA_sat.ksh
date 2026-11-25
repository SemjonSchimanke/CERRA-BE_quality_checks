#!/bin/ksh
#SBATCH --job-name=sat_obs
#SBATCH --qos=nf
#SBATCH --time=1-0
#SBATCH --mem=32G


# Functions
# --------------------------------------------------------------------------
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
    OBSGROUP   = AMSUA,
    DATE       = 20160803,
    TIME       = 00/03/06/09/12/15/18/21,
    TARGET     = "${WDIR}/${YM}/amsua_CERRA_${YM}.mfb"
EOF

}

# --------------------------------------------------------------------------
function create_YMLIST {
    start_year=$1
    start_month=$2
    end_year=$3
    end_month=$4

    YMLIST=""

    year=$start_year
    month=$start_month

    while (( year < end_year || (year == end_year && month <= end_month) )); do
	YMLIST="$YMLIST $(printf "%04d%02d" "$year" "$month")"
	if (( month == 12 )); then
            (( year++ ))
            month=1
	else
            (( month++ ))
	fi
    done
    printf "%s\n" "$YMLIST"
}

#================================================
#================================================
#================================================

module load ecmwf-toolbox

MANDTG=/home/fasg/bin/mandtg
WDIR=/scratch/smos/Observations/MFB

start_year=2016
start_month=08

end_year=2016
end_month=08

YMLIST=$(create_YMLIST $start_year $start_month $end_year $end_month)

[[ -d $WDIR ]] || mkdir -p $WDIR

cd $WDIR

for YM in $YMLIST;do
    echo "Working on $YM"
    
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
	echo "Data fetched."
    fi

    # Removing dublicates                                                                 
#    echo "Removing dublicates"
#    odc sql -q "SELECT DISTINCT *" \
#        -i conv_CERRA_${YM}.mfb -o conv_CERRA_${YM}_DISTINCT.mfb -f odb
#    mv conv_CERRA_${YM}_DISTINCT.mfb conv_CERRA_${YM}.mfb


#    echo "Working on stat_surf $YM"
#    stat_surf $YM
#    echo "Working on stat_temp $YM"
#    stat_temp $YM
#    echo "Working on stat_airep $YM"
#    stat_airep $YM
#    
#    /bin/rm conv_CERRA_${YM}.mfb
#    /bin/rm getmarsdone.dat
#    /bin/rm mars_request.dat
#    /bin/rm out.dat
    
done

