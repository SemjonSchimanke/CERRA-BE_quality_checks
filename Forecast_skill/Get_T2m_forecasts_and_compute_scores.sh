#!/bin/bash -e
#SBATCH --job-name=fetching
#SBATCH --time=1-00:00:00

#set -ax 
OUTDIR=/ec/res4/scratch/smos/Forecast_skill
mkdir -p $OUTDIR


# Start and end year
START_YEAR=1960
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
levtype=sfc,
origin=SE-AL-EC,
param=167,
time=12:00:00,
step=${fc},
stream=oper,
type=fc,
target="$OUTDIR/CERRA_T2m_${YYYY}_${fc}h.grb"
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
levtype=sfc,
origin=SE-AL-EC,
param=167,
time=12:00:00,
step=${fc},
stream=oper,
type=fc,
target="$OUTDIR/CERRA_T2m_${YYYY}_${fc}h.grb"
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
	$OUTDIR/CERRA_T2m_${YYYY}_30h.grb $OUTDIR/CERRA_T2m_${YYYY}_6h.grb \
	>> Forecast_skill_T2m_std.txt
    cdo outputtab,name,date,value,nohead -fldmean -timmean -sub \
	$OUTDIR/CERRA_T2m_${YYYY}_30h.grb $OUTDIR/CERRA_T2m_${YYYY}_6h.grb \
	>> Forecast_skill_T2m_diff.txt
    # Inner domain
    cdo outputtab,name,date,value,nohead -fldmean -selindexbox,201,869,201,869 -timstd -sub \
	$OUTDIR/CERRA_T2m_${YYYY}_30h.grb $OUTDIR/CERRA_T2m_${YYYY}_6h.grb \
	>> Forecast_skill_T2m_std_inner.txt
    cdo outputtab,name,date,value,nohead -fldmean -selindexbox,201,869,201,869 -timmean -sub \
	$OUTDIR/CERRA_T2m_${YYYY}_30h.grb $OUTDIR/CERRA_T2m_${YYYY}_6h.grb \
	>> Forecast_skill_T2m_diff_inner.txt

    rm $OUTDIR/CERRA_T2m_${YYYY}_30h.grb $OUTDIR/CERRA_T2m_${YYYY}_6h.grb
done

echo "All years processed successfully."




exit
