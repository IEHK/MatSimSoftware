#!/usr/bin/env zsh
#########################
#  Abaqus Job Template
#    for LSF cluster
#      ITC, RWTH
#########################

### Job name
#BSUB -J YourJobNameHere

### File / path where STDOUT & STDERR will be written
###    %J is the job ID, %I is the array ID
#BSUB -o YourJobNameHere.%J.%I

### Request the time you need for execution in minutes
### The format for the parameter is: [hour:]minute,
### that means for 80 minutes you could also use this: 1:20
#BSUB -W 5:00

### Request memory you need for your job in TOTAL in MB
#BSUB -M 5024

### Request the number of compute slots you want to use
#BSUB -n 4

### Use esub for OpenMP/shared memeory jobs
#BSUB -a openmp

## Reference: https://doc.itc.rwth-aachen.de/display/CC/Example+scripts#Examplescripts-lsfshared

echo "Starting with $LSB_DJOB_NUMPROC slots on $LSB_HOSTS"
module load  TECHNICS abaqus/2018

## Run Abaqus commands (please modify according to your requirments)

abaqus interactive -job 'ABAQUS_JOB_NAME' -input 'YOUR_INPUT_FILE.inp'  -cpus $LSB_DJOB_NUMPROC

echo "$LSB_JOBNAME Finished"
