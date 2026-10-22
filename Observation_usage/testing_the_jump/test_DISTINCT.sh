#!/bin/bash -e

# Everything will happen in $In_dir
In_dir="/ec/res4/scratch/smos/Observations/MFB_active/testing_the_jump2/"
mkdir -p $In_dir

# Copy the scripts to $In_dir
cp -p mars_request_19781229.dat \
   mars_request_1978122906.dat \
   mars_request_1979010306.dat \
   check_the_observations.py $In_dir
cd $In_dir


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
odc sql -q "SELECT DISTINCT lat@hdr, lon@hdr WHERE 
    	varno@body=58 AND obstype@hdr=1 AND 
       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
       datum_status@surfbody_feedback=1" \
	   -i conv_CERRA_1978122906.ofb \
	   -o obs1978122906.dat -f ascii
#python3 check_the_observations.py obs1978122906.dat
wc obs1978122906.dat

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

