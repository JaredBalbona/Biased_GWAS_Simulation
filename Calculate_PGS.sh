#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --qos=blanca-ibg
#SBATCH --mem=20gb
#SBATCH --time=1:00:00

module purge
ml intel

for chr in {1..22}; do

mkdir "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/PGS/Sample_PGSs/VA"$1"_matcor"$2

plink2 \
    --haps /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/GeneEvolve_Output/VA"$1"_matcor"$2"/VA"$1"_matcor"$2".pop1.gen10.chr"$chr".hap 'ref-first' \
    --legend /pl/active/KellerLab/Emmanuel/pedofUKBphased/caucasians/52249/sample.chr"$chr".legend "$chr" \
    --score /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Output/VA"$3"_matcor"$4"/VA"$3"_matcor"$4".pop1.gen10.chr"$chr".ph1_P.glm.linear 3 4 9 header \
    --out /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/PGS/Sample_PGSs/VA"$1"_matcor"$2"/Target_VA"$1"_matcor"$2"_Discovery_VA"$3"_matcor"$4"_chr"$chr"

done

