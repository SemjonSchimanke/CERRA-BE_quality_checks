#!/bin/bash -e

# Everything will happen in $wrk_dir
wrk_dir="/ec/res4/scratch/smos/Observations/MFB_active/testing_DISTINCT"
mkdir -p $wrk_dir
cd $wrk_dir

# The prepared odb data is here:
data_dir="/ec/res4/scratch/smos/Observations/MFB_active/testing_the_jump2/"

if [ ! -f conv_CERRA_197812.mfb ]; then
    # Copy relevant data
    cp -p ${data_dir}/conv*fb $wrk_dir
fi

## Testing DISTINCT
echo "Testing on a single time step."
odc sql -q "SELECT DISTINCT lat@hdr, lon@hdr WHERE 
    	varno@body=58 AND obstype@hdr=1 AND 
       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
       datum_status@surfbody_feedback=1" \
	   -i conv_CERRA_1978122906.ofb \
	   -o obs1978122906.dat -f ascii
echo -n "With DISTINCT, we get "
wc -l obs1978122906.dat | cut -d' ' -f1
echo " observations for this time step."

odc sql -q "SELECT  lat@hdr, lon@hdr WHERE 
    	varno@body=58 AND obstype@hdr=1 AND 
       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
       datum_status@surfbody_feedback=1" \
	   -i conv_CERRA_1978122906.ofb \
	   -o obs1978122906.dat -f ascii
echo -n "Without DISTINCT, we get "
wc -l obs1978122906.dat | cut -d' ' -f1
echo " observations for the same time step."

echo -e "\n ==> It seems that DISTINCT works for a single time step.\n\n"

echo "Testing for one day (8 time steps)."
odc sql -q "SELECT DISTINCT *
    	WHERE 
    	varno@body=58 AND obstype@hdr=1 AND 
       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
       datum_status@surfbody_feedback=1" \
	   -i conv_CERRA_19781229.ofb \
	   -o obs19781229.dat -f ascii
echo -n "With DISTINCT, we get "
wc -l obs19781229.dat | cut -d' ' -f1
echo " observations for this day."

odc sql -q "SELECT 
    	andate, antime, lat@hdr, lon@hdr WHERE 
    	varno@body=58 AND obstype@hdr=1 AND 
       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
       datum_status@surfbody_feedback=1" \
	   -i conv_CERRA_19781229.ofb \
	   -o obs19781229.dat -f ascii
echo -n "Without DISTINCT, we get "
wc -l obs19781229.dat | cut -d' ' -f1
echo " observations for the same day."




echo -e "\n\n\nScripts finished successfully."
exit

#mars < mars_request_19781229.dat
# DISTINCT
odc sql -q "SELECT DISTINCT
    andate,
    antime,
    lat@hdr, lon@hdr,
    STDEV(fg_depar@body) as stdev_fgdep,
    STDEV(an_depar@body) as stdev_andep,
    count(*) as numobs 
    WHERE varno=58 AND obstype=1 AND
    (codetype=11 OR codetype=14 OR codetype=170)" \
	-i conv_CERRA_197812.mfb \
	-o out.dat -f ascii
grep "37.402" out.dat | head -n3

echo "Scripts finished successfully."
exit

## Fetch and prepare the data
#mars < mars_request_1978122906.dat

odc sql -q "SELECT lat@hdr, lon@hdr WHERE 
    	varno@body=58 AND obstype@hdr=1 AND 
       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
       datum_status@surfbody_feedback=1" \
	   -i conv_CERRA_1978122906.ofb \
	   -o obs1978122906.dat -f ascii
#python3 check_the_observations.py obs1978122906.dat
wc obs1978122906.dat


#
#mars < mars_request_1979010306.dat
#odc sql -q "SELECT lat@hdr, lon@hdr WHERE 
#    	varno@body=58 AND obstype@hdr=1 AND 
#       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
#       datum_status@surfbody_feedback=1" \
#	   -i conv_CERRA_1979010306.ofb \
#	   -o obs1979010306.dat -f ascii
#
## Plot the maps
#python3 plot_cerra_rh2m_single_cycle.py 

#python3 check_the_observations.py obs1979010306.dat

