#!/bin/bash -e
#SBATCH --job-name=fetching
#SBATCH --time=1-00:00:00

#set -ax 
OUTDIR=/ec/res4/scratch/smos/Forecast_skill
mkdir -p $OUTDIR


# Start and end year
START_YEAR=2022
END_YEAR=2025

for YYYY in $(seq $START_YEAR $END_YEAR); do
    echo "======================================"
    echo "Processing year: $YYYY"
    echo "======================================"

    YYYY1=$((YYYY+1))

    
    # 6h forecast
    fc=6
    cat >marsdir$$ <<EOF         
retrieve,
class=rr,
date=${YYYY}-12-02/to/${YYYY1}-02-28,
expver=prod,
levtype=pl,
levelist=500,
origin=SE-AL-EC,
param=129,
time=12:00:00,
step=${fc},
stream=oper,
type=fc,
target="$OUTDIR/CERRA_GPH_500_${YYYY}_${fc}h.grb"
end
EOF

#-------------------------------
# do the mars retrieval, 6h forecasts
#-------------------------------
    mars marsdir$$
    rm marsdir$$ 

    #-------------------------------
    # Now, 30h forecast
    #-------------------------------
    fc=30
    cat >marsdir$$ <<EOF         
retrieve,
class=rr,
date=${YYYY}-12-01/to/${YYYY1}-02-27,
expver=prod,
levtype=pl,
levelist=500,
origin=SE-AL-EC,
param=129,
time=12:00:00,
step=${fc},
stream=oper,
type=fc,
target="$OUTDIR/CERRA_GPH_500_${YYYY}_${fc}h.grb"
end
EOF

#-------------------------------
# do the mars retrieval, 6h forecasts
#-------------------------------
    mars marsdir$$
    rm marsdir$$ 

#-------------------------------
# do the computations
#-------------------------------
    # Whole domain
    cdo outputtab,name,date,value,nohead -fldmean -timstd -sub \
	$OUTDIR/CERRA_GPH_500_${YYYY}_30h.grb $OUTDIR/CERRA_GPH_500_${YYYY}_6h.grb \
	>> Forecast_skill_std_2015.txt
    cdo outputtab,name,date,value,nohead -fldmean -timmean -sub \
	$OUTDIR/CERRA_GPH_500_${YYYY}_30h.grb $OUTDIR/CERRA_GPH_500_${YYYY}_6h.grb \
	>> Forecast_skill_diff_2015.txt
    # Inner domain
    cdo outputtab,name,date,value,nohead -fldmean -selindexbox,201,800,201,800 -timstd -sub \
	$OUTDIR/CERRA_GPH_500_${YYYY}_30h.grb $OUTDIR/CERRA_GPH_500_${YYYY}_6h.grb \
	>> Forecast_skill_std_inner_2015.txt
    cdo outputtab,name,date,value,nohead -fldmean -selindexbox,201,800,201,800 -timmean -sub \
	$OUTDIR/CERRA_GPH_500_${YYYY}_30h.grb $OUTDIR/CERRA_GPH_500_${YYYY}_6h.grb \
	>> Forecast_skill_diff_inner_2015.txt

#    rm $OUTDIR/CERRA_GPH_500_${YYYY}_30h.grb $OUTDIR/CERRA_GPH_500_${YYYY}_6h.grb
done

echo "All years processed successfully."




exit
