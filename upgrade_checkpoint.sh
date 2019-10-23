#!/bin/bash

#  Routine to "upgrade" a checkpoint created prior to use of tracer code
#    to be used to reconfigure for a run with tracer code. 

#  Script works on Monsoon.  
#  Input only checkpoint file name.  
#  Output written to working directory.


#module load nco
module load nco/4.6.7-netcdf_4.4.1.1.3 # better, available on Monsoon


data=$1     # checkpoint data from an old run from which you would like to begin

stamp=`echo $data | cut -f 1 -d '.'` 
ndata=${stamp}_reformed.nc 

echo "Upgrading $data   to   $ndata"

ncap2 -s 'lev=lev*100;theta_tendency=(T_adv_h+s_adv_v)/3600.;q_tendency=(q_adv_h+q_adv_v)/3600.;' $data temp_$ndata
[ -f $ndata ] && rm $ndata
[ -f B$ndata ] && rm B$ndata
ncks -O -v time,lev,theta_tendency,q_tendency temp_$ndata $ndata
ncap2 -O -s 'time=(time-time(0))*86400.;' $ndata B$ndata

rm temp_$ndata
mv B$ndata $ndata

#All done
echo "Good to go!"

exit 0
