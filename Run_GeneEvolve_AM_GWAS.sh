#!/bin/sh
#SBATCH --mem=10gb
#SBATCH --ntasks=1
#SBATCH --time=0:15:00


ml intel gcc

for VA in .2 .5 .8; do
for AM in 0 .05 .2 .8; do

file_path = "/path/to/main/directory/"

sbatch "${file_path}/Discovery_Samples/GWAS/GeneEvolve_AM_GWAS.sh" "$VA" "$AM" 

done
done



