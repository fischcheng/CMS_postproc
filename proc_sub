#!/bin/bash
#BSUB -J proc_chunk01
#BSUB -e %J.err
#BSUB -W 10:00
#BSUB -P cpp
#BSUB -q general
#BSUB -n 1
#BSUB -N
#BSUB -u yucheng@rsmas.miami.edu
#
# Run serial executable on 1 cpu of one node
module load matlab
/share/opt/MATLAB/R2016a/bin/matlab -nojvm -nodisplay -nosplash -r proc_traj_chunk01 > proc_chunk01.log

