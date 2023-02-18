#!/bin/sh
#SBATCH --mem=10gb
#SBATCH --ntasks=1
#SBATCH --time=0:15:00

ml intel
ml gcc

for VA_Discovery in .2 .5 .8; do
for AM_Discovery in 0 .05 .2 .8; do
for VA_Target in .2 .5 .8; do
for AM_Target in 0 .05 .2 .8; do

file_path = "/path/to/main/directory/"
sbatch "${file_path}/Discovery_Samples/GWAS/GeneEvolve_AM_GWAS.sh" "$VA" "$AM" 


sbatch "${file_path}/Target_Samples/PGS/Calculate_PGS.sh" "$VA_Discovery" "$AM_Discovery" "$VA_Target" "$AM_Target"

done
done
done
done


 
