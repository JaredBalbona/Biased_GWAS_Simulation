#!/bin/sh
#SBATCH --mem=10gb
#SBATCH --ntasks=1
#SBATCH --time=0:15:00

ml intel
ml gcc

for VA_Discovery in .2 .5 .8; do
for AM_Discovery in 0 .2 .6 .8; do
for VA_Target in .2 .5 .8; do
for AM_Target in 0 .2 .6 .8; do

sbatch /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/PGS/Calculate_PGS.sh "$VA_Discovery" "$AM_Discovery" "$VA_Target" "$AM_Target"

done
done
done
done


 
