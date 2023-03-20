#!/bin/sh
#SBATCH --mem=5gb
#SBATCH --ntasks=1
#SBATCH --time=0:15:00


ml intel
ml gcc

for VA in .2 .5 .8; do
for AM in 0 .2 .6 .8; do

VE=$(echo "1-$VA" | bc -l)

sbatch /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_AM_Sim.sh "$VA" "$AM" "$VE"

done
done
