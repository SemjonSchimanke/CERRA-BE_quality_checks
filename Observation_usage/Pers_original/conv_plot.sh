#!/bin/bash

function plot_surf {

    DTG1=$1
    DTG2=$2

    YM1=$(echo $DTG1 | cut -c1-6)
    YM2=$(echo $DTG2 | cut -c1-6)

    for DOMAIN in carra2;do

        FIG=${DOMAIN}_surf_z_${YM1}_${YM2}.png

	gnuplot <<EOF
set terminal pngcairo dashed size 1500,1500
set output "$FIG"
set grid
set multiplot
set xdata time
set timefmt "%Y%m%d%H"
set xrange ["$DTG1":"$DTG2"]
set format x "%Y"
set style data linespoints
set xtics rotate by 30 offset -7.0,-2.1

set size 0.95,0.17
set origin 0.01,0.82
set title "CARRA $DOMAIN SYNOP z"
set ylabel "m"
set xlabel ""
set key outside right
plot "$DDIR/carra2_landsynop_z.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/carra2_landsynop_z.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

set size 0.92,0.14
set origin 0.01,0.66
set title ""
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/carra2_landsynop_z.dat" u 1:4  t "Nr obs" with linesp lc rgb "black" lt 1 lw 3

set size 0.95,0.17
set origin 0.01,0.48
set title "CARRA $DOMAIN SHIP z"
set ylabel "m"
set xlabel ""
set key outside right
plot "$DDIR/carra2_ship_z.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/carra2_ship_z.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

set size 0.92,0.14
set origin 0.01,0.32
set title ""
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/carra2_ship_z.dat" u 1:4  t "Nr obs" with linesp lc rgb "black" lt 1 lw 3

set size 0.95,0.17
set origin 0.01,0.15
set title "CARRA $DOMAIN DRIBU z"
set ylabel "m"
set xlabel ""
set key outside right
plot "$DDIR/carra2_dribu_z.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/carra2_dribu_z.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

set size 0.92,0.14
set origin 0.01,0.01
set title ""
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/carra2_dribu_z.dat" u 1:4  t "Nr obs" with linesp lc rgb "black" lt 1 lw 3

EOF

        FIG=${DOMAIN}_surfana_${YM1}_${YM2}.png

	gnuplot <<EOF
set terminal pngcairo dashed size 1500,1500
set output "$FIG"
set grid
set multiplot
set xdata time
set timefmt "%Y%m%d%H"
set xrange ["$DTG1":"$DTG2"]
set format x "%Y"
set style data linespoints
set xtics rotate by 30 offset -7.0,-2.1

set size 0.95,0.17
set origin 0.01,0.82
set title "CARRA $DOMAIN SYNOP T2m"
set ylabel "K"
set xlabel ""
set key outside right
plot "$DDIR/carra2_landsynop_t2m.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/carra2_landsynop_t2m.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

set size 0.92,0.14
set origin 0.01,0.66
set title ""
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/carra2_landsynop_t2m.dat" u 1:4  t "Nr obs" with linesp lc rgb "black" lt 1 lw 3

set size 0.95,0.17
set origin 0.01,0.48
set title "CARRA $DOMAIN SYNOP RH2m"
set ylabel "%"
set xlabel ""
set key outside right
plot "$DDIR/carra2_landsynop_rh2m.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/carra2_landsynop_rh2m.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

set size 0.92,0.14
set origin 0.01,0.32
set title ""
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/carra2_landsynop_rh2m.dat" u 1:4  t "Nr obs" with linesp lc rgb "black" lt 1 lw 3
EOF

    done

}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
function plot_temp {

    DTG1=$1
    DTG2=$2

    YM1=$(echo $DTG1 | cut -c1-6)
    YM2=$(echo $DTG2 | cut -c1-6)
    
    YMD1=$(echo $DTG1 | cut -c1-8)
    YMD2=$(echo $DTG2 | cut -c1-8)
    
    LEVL="0 1500 2500 4000 6500 8500 12500 17500 22500 27500 35000 45000 60000 80000 92500 200000"
    NUMLEVS=15

    for DOMAIN in carra2;do
    for VARNO in 2 3 7;do

    for nlev in 1 6 11;do
	
	((nleve=$nlev + 4))


	# Set header, filename, etc
	FIG1=temp_${DOMAIN}_${VARNO}_${YM1}_${YM2}_${nlev}_fgdep.png
	FIG2=temp_${DOMAIN}_${VARNO}_${YM1}_${YM2}_${nlev}_nobs.png
	cat > gplot_temp.dat <<EOF
set terminal pngcairo dashed size 1500,1500
set output "$FIG1"
set grid
set multiplot
set xdata time
set timefmt "%Y%m%d"
set xrange ["$YMD1":"$YMD2"]
set format x "%Y"
set style data linespoints
set xtics rotate by 30 offset -7.0,-2.1

EOF
	
	cat > gplot_temp_nobs.dat <<EOF
set terminal pngcairo dashed size 1500,1500
set output "$FIG2"
set grid
set multiplot
set xdata time
set timefmt "%Y%m%d"
set xrange ["$YMD1":"$YMD2"]
set format x "%Y"
set style data linespoints
set xtics rotate by 30 offset -7.0,-2.1

EOF

	isubplot=1
	while (( "$nlev" <= "$nleve" ));do

	    plev1=$(echo $LEVL | awk -v nlev=$nlev  '{print $nlev}')
	    plev2=$(echo $LEVL | awk -v nlev=$nlev  '{print $(nlev+1)}')

	    plev1p=$(echo $plev1 | awk '{printf("%3.3i\n",$1/100)}')
	    if (( $nlev == $NUMLEVS ));then
		plev2p="sfc"
	    else
		plev2p=$(echo $plev2 | awk '{printf("%3.3i\n",$1/100)}')
	    fi
	    echo $nlev $plev1p $plev2p
	
	# cat plotfile
	# set 2 subplots: (O-B), nobs

	#    cat ${YM1}/${DOMAIN}_temp_${VARNO}_${plev1}_${plev2}_${YM1}.dat \
	#	${YM2}/${DOMAIN}_temp_${VARNO}_${plev1}_${plev2}_${YM2}.dat > temp_plotfile_${isubplot}.dat

	    yori1="0.82"
	    if (( "$isubplot" == "2" ));then 
		yori1="0.64"
	    elif (( "$isubplot" == "3" ));then 
		yori1="0.44"
	    elif (( "$isubplot" == "4" ));then 
		yori1="0.26"
	    elif (( "$isubplot" == "5" ));then 
		yori1="0.08"
	    fi

	    if (( "$VARNO" == "2" ));then 
		PLOTTITLE="Temperature. $plev1p - $plev2p hPa"
		PLOTUNIT="K"
	    elif (( "$VARNO" == "3" ));then 
		PLOTTITLE="u-wind. $plev1p - $plev2p hPa"
		PLOTUNIT="m/s"
	    elif (( "$VARNO" == "7" ));then 
		PLOTTITLE="Specfific humidity. $plev1p - $plev2p hPa"
		PLOTUNIT="kg/kg"
	    fi


	    
	    cat >> gplot_temp.dat <<EOF

set size 0.95,0.17
set origin 0.01,$yori1
set title "CARRA $DOMAIN TEMP $PLOTTITLE"
set ylabel "$PLOTUNIT"
set xlabel ""
set key outside right
plot "$DDIR/${DOMAIN}_temp_${VARNO}_${plev1}_${plev2}.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/${DOMAIN}_temp_${VARNO}_${plev1}_${plev2}.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

EOF
	    
	    cat >> gplot_temp_nobs.dat <<EOF

set size 0.95,0.17
set origin 0.01,$yori1
set title "CARRA $DOMAIN TEMP $PLOTTITLE Nobs"
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/${DOMAIN}_temp_${VARNO}_${plev1}_${plev2}.dat" u 1:4  t "Nr of obs" with linesp lc rgb "black" lt 1 lw 3

EOF

	    ((isubplot=$isubplot + 1))
	    ((nlev=$nlev + 1))
	done # while (( "$nlev" <= "$nleve" ));do


	
	gnuplot < gplot_temp.dat
	gnuplot < gplot_temp_nobs.dat
	echo '-------------------'
    done # for nlev in 1 6 11;do


    done # VARNO
    done # DOMAIN
}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
function plot_tempdesc {

    DTG1=$1
    DTG2=$2

    YM1=$(echo $DTG1 | cut -c1-6)
    YM2=$(echo $DTG2 | cut -c1-6)
    
    YMD1=$(echo $DTG1 | cut -c1-8)
    YMD2=$(echo $DTG2 | cut -c1-8)
    
    LEVL="0 1500 2500 4000 6500 8500 12500 17500 22500 27500 35000 45000 60000 80000 92500 200000"
    NUMLEVS=15

    for DOMAIN in carra2;do
    for VARNO in 2 3 7;do

    for nlev in 1 6 11;do
	
	((nleve=$nlev + 4))


	# Set header, filename, etc
	FIG1=tempdesc_${DOMAIN}_${VARNO}_${YM1}_${YM2}_${nlev}_fgdep.png
	FIG2=tempdesc_${DOMAIN}_${VARNO}_${YM1}_${YM2}_${nlev}_nobs.png
	cat > gplot_tempdesc.dat <<EOF
set terminal pngcairo dashed size 1500,1500
set output "$FIG1"
set grid
set multiplot
set xdata time
set timefmt "%Y%m%d"
set xrange ["$YMD1":"$YMD2"]
set format x "%Y"
set style data linespoints
set xtics rotate by 30 offset -7.0,-2.1

EOF
	
	cat > gplot_tempdesc_nobs.dat <<EOF
set terminal pngcairo dashed size 1500,1500
set output "$FIG2"
set grid
set multiplot
set xdata time
set timefmt "%Y%m%d"
set xrange ["$YMD1":"$YMD2"]
set format x "%Y"
set style data linespoints
set xtics rotate by 30 offset -7.0,-2.1

EOF

	isubplot=1
	while (( "$nlev" <= "$nleve" ));do

	    plev1=$(echo $LEVL | awk -v nlev=$nlev  '{print $nlev}')
	    plev2=$(echo $LEVL | awk -v nlev=$nlev  '{print $(nlev+1)}')

	    plev1p=$(echo $plev1 | awk '{printf("%3.3i\n",$1/100)}')
	    if (( $nlev == $NUMLEVS ));then
		plev2p="sfc"
	    else
		plev2p=$(echo $plev2 | awk '{printf("%3.3i\n",$1/100)}')
	    fi
	    echo $nlev $plev1p $plev2p
	
	# cat plotfile
	# set 2 subplots: (O-B), nobs

	#    cat ${YM1}/${DOMAIN}_tempdesc_${VARNO}_${plev1}_${plev2}_${YM1}.dat \
	#	${YM2}/${DOMAIN}_tempdesc_${VARNO}_${plev1}_${plev2}_${YM2}.dat > tempdesc_plotfile_${isubplot}.dat

	    yori1="0.82"
	    if (( "$isubplot" == "2" ));then 
		yori1="0.64"
	    elif (( "$isubplot" == "3" ));then 
		yori1="0.44"
	    elif (( "$isubplot" == "4" ));then 
		yori1="0.26"
	    elif (( "$isubplot" == "5" ));then 
		yori1="0.08"
	    fi

	    if (( "$VARNO" == "2" ));then 
		PLOTTITLE="Temperature. $plev1p - $plev2p hPa"
		PLOTUNIT="K"
	    elif (( "$VARNO" == "3" ));then 
		PLOTTITLE="u-wind. $plev1p - $plev2p hPa"
		PLOTUNIT="m/s"
	    elif (( "$VARNO" == "7" ));then 
		PLOTTITLE="Specfific humidity. $plev1p - $plev2p hPa"
		PLOTUNIT="kg/kg"
	    fi


	    
	    cat >> gplot_tempdesc.dat <<EOF

set size 0.95,0.17
set origin 0.01,$yori1
set title "CARRA $DOMAIN TEMPDESC $PLOTTITLE"
set ylabel "$PLOTUNIT"
set xlabel ""
set key outside right
plot "$DDIR/${DOMAIN}_tempdesc_${VARNO}_${plev1}_${plev2}.dat" u 1:2  t "STDEV(O-B)" with linesp lc rgb "blue" lt 1 lw 3, \
     "$DDIR/${DOMAIN}_tempdesc_${VARNO}_${plev1}_${plev2}.dat" u 1:3  t "STDEV(O-A)" with linesp lc rgb "red" lt 1 lw 3

EOF
	    
	    cat >> gplot_tempdesc_nobs.dat <<EOF

set size 0.95,0.17
set origin 0.01,$yori1
set title "CARRA $DOMAIN TEMPDESC $PLOTTITLE Nobs"
set ylabel "Nobs"
set xlabel ""
set key outside right
plot "$DDIR/${DOMAIN}_tempdesc_${VARNO}_${plev1}_${plev2}.dat" u 1:4  t "Nr of obs" with linesp lc rgb "black" lt 1 lw 3

EOF

	    ((isubplot=$isubplot + 1))
	    ((nlev=$nlev + 1))
	done # while (( "$nlev" <= "$nleve" ));do


	
	gnuplot < gplot_tempdesc.dat
	gnuplot < gplot_tempdesc_nobs.dat
	echo '-------------------'
    done # for nlev in 1 6 11;do


    done # VARNO
    done # DOMAIN
}
#================================================
#================================================
#================================================
#================================================

DDIR=/scratch/fasg/CARRA2/aggregated_stats_wrk2/full_time_series

plot_surf 1985090100 2025123121
plot_temp 1985090100 2025123121
plot_tempdesc 1985090100 2025123121
