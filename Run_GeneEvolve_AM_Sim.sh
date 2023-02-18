#!/bin/sh
#SBATCH --mem=10gb
#SBATCH --ntasks=1
#SBATCH --time=0:15:00


ml intel
ml gcc

for VA in .2 .5 .8; do
for AM in 0 .05 .2 .8; do

VE=$(echo "1-$VA" | bc -l)

file_path = "/path/to/main/directory/"

sbatch "${file_path}/Target_Samples/GeneEvolve_AM_Sim.sh" "$VA" "$AM" "$VE"

done
done



