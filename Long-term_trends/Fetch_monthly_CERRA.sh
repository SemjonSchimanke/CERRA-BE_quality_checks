#!/bin/bash -e
#SBATCH --job-name=monthly
#SBATCH --qos=nf
#SBATCH --time=1-0

# Functions                                                                                        
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

create_request()
{
    local start=$1
    local end=$2

    cat > mars_request.dat <<EOF
RETRIEVE,
    ORIGIN     = se-al-ec,
    CLASS      = rr,
    EXPVER     = prod,
    levtype    = sfc,
    origin     = se-al-ec,
    param      = 167/207,
    stream     = moda,
    type       = an,
    DATE       = ${YMLIST},
    TARGET     = "${WDIR}/CERRA_monthly_${start}-${end}.grb"
EOF
}
                                                                             
# --------------------------------------------------------------------------
create_month_list()
{
    local start=$1
    local end=$2
    local year month end_year end_month
    local list=""

    year=$((10#${start:0:4}))
    month=$((10#${start:4:2}))

    end_year=$((10#${end:0:4}))
    end_month=$((10#${end:4:2}))

    while (( year < end_year || (year == end_year && month <= end_month) )); do

        [[ -n "$list" ]] && list+="/"
        list+=$(printf "%04d%02d01" "$year" "$month")

        if (( month == 12 )); then
            (( year++ ))
            month=1
        else
            (( month++ ))
        fi
    done

    echo "$list"
}


#================================================

module load ecmwf-toolbox

WDIR=/scratch/smos/Long-term/CERRA

[[ -d $WDIR ]] || mkdir -p $WDIR
cd $WDIR


START=196101
END=202612

start_year=$((10#${START:0:4}))
end_year=$((10#${END:0:4}))

for (( decade=(start_year/10)*10; decade<=end_year; decade+=10 )); do

    # Determine start and end of decade
    if (( decade == start_year/10*10 )); then
        list_start=$START
    else
        list_start=$(printf "%04d01" "$decade")
    fi

    if (( decade+9 > end_year )); then
        list_end=$END
    else
        list_end=$(printf "%04d12" "$((decade+9))")
    fi

    YMLIST=$(create_month_list "$list_start" "$list_end")

    first_year=${list_start:0:4}
    last_year=${list_end:0:4}
    echo "Processing $first_year - $last_year"
    create_request $first_year $last_year
    mars < mars_request.dat
    echo "Data fetched."
done


echo "All data fetched."


