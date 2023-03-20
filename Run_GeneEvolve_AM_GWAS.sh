#!/bin/sh
#SBATCH --mem=10gb
#SBATCH --ntasks=1
#SBATCH --time=0:15:00

ml intel gcc

for VA in .2 .5 .8; do
for AM in 0 .2 .6 .8; do

sbatch "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GeneEvolve_AM_GWAS.sh" "$VA" "$AM" 

done
done


