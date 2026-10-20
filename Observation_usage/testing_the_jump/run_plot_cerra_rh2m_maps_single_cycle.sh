#!/bin/bash -e

# Everything will happen in $In_dir
In_dir="/ec/res4/scratch/smos/Observations/MFB_active/testing_the_jump/"

# Copy the scripts to $In_dir
cp mars_request_1978122906.dat \
   mars_request_1979010306.dat \
   plot_cerra_rh2m_single_cycle.py $In_dir
cd $In_dir

# Fetch and prepare the data
#mars < mars_request_1978122906.dat
#odc sql -q "SELECT lat@hdr, lon@hdr WHERE 
#    	varno@body=58 AND obstype@hdr=1 AND 
#       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
#       datum_status@surfbody_feedback=1" \
#	   -i conv_CERRA_1978122906.ofb \
#	   -o obs1978122906.dat -f ascii
#
#mars < mars_request_1979010306.dat
#odc sql -q "SELECT lat@hdr, lon@hdr WHERE 
#    	varno@body=58 AND obstype@hdr=1 AND 
#       (codetype@hdr=11 OR codetype@hdr=14 OR codetype@hdr=170) AND 
#       datum_status@surfbody_feedback=1" \
#	   -i conv_CERRA_1979010306.ofb \
#	   -o obs1979010306.dat -f ascii

# Plot the maps
python3 plot_cerra_rh2m_single_cycle.py 

