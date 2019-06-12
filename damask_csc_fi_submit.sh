#!/usr/bin/env bash
 
### Job name
#SBATCH -J damasktest
#SBATCH -o damasktest.%J_out
#SBATCH -e damasktest.%J_err

### Time your job needs to execute, e. g. 30 min
#SBATCH --time=00:30:00

### Memory your job needs per node, e. g. 500 MB
# #SBATCH --mem=8000M

## a per-process (soft) memory limit
## limit is specified in MB
## example: 1 GB is 1000
#SBATCH --mem-per-cpu=1000

##the number of processes (number of cores)
#SBATCH -n 4

##parallel queue
#SBATCH -p parallel


module load intelmpi
env > job_env_$SLURM_JOB_ID.txt

export DAMASK_NUM_THREADS=1
ulimit -s unlimited

PATH=$HOME/damask2.0.2/DAMASK/bin:$PATH
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/damask2.0.2/petsc-3.9.4/linux-gnu-intel/lib" 

srun $(which DAMASK_spectral)  -l tensionX.load -g RVE.geom
