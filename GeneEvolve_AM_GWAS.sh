#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --qos=blanca-ibg
#SBATCH --mem=20gb
#SBATCH --time=1:00:00

module purge
ml intel

for chr in {1..22}; do

mkdir "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Output/VA"$1"_matcor"$2

plink2 \
    --glm allow-no-covars \
    --const-fid \
    --sample "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Input/VA"$1"_matcor"$2".info.pop1.gen10.sample" \
    --pheno-name "ph1_P" \
    --haps "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Output/VA"$1"_matcor"$2"/VA"$1"_matcor"$2".pop1.gen10.chr"$chr".hap" 'ref-first' \
    --legend "/pl/active/KellerLab/Emmanuel/pedofUKBphased/caucasians/52249/sample.chr"$chr".legend" "$chr" \
    --out "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Output/VA"$1"_matcor"$2"/VA"$1"_matcor"$2".pop1.gen10.chr"$chr

done
