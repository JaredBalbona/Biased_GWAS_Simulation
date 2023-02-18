#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --qos=blanca-ibg
#SBATCH --mem=20gb
#SBATCH --time=1:00:00

module purge
ml intel

for chr in {1..22}; do

file_path = "/path/to/main/directory/"
mkdir "${file_path}/Target_Samples/PGS/Sample_PGSs/VA"$1"_VF0_matcor"$2

plink2 \
    --haps "${file_path}/Target_Samples/GeneEvolve_Output/VA"$1"_VF0_matcor"$2"/VA"$1"_VF0_matcor"$2".pop1.gen10.chr" "$chr" ".hap" 'ref-first' \
    --legend "${file_path}/Target_Samples/GeneEvolve_Input/sample.chr"$chr".legend" "$chr" \
    --score "${file_path}/Discovery_Samples/GWAS/GWAS_Output/VA"$3"_VF0_matcor"$4"/VA"$3"_VF0_matcor"$4".pop1.gen10.chr" "$chr" ".ph1_P.glm.linear" 3 4 9 header \
    --out "${file_path}/Target_Samples/PGS/Sample_PGSs/VA"$1"_VF0_matcor"$2"/PGS_VA"$1"_VF0_matcor"$2"_From_VA"$3"_VF0_matcor"$4"

done

