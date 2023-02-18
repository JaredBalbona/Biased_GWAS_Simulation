#!/bin/sh
#SBATCH --mem=40gb
#SBATCH --ntasks=1
#SBATCH --time=3:00:00

module purge
ml intel gcc

file_path = "/path/to/main/directory/"

mkdir "${file_path}/Target_Samples/GeneEvolve_Output/VA"$1"_VF0_matcor"$2
path = "${file_path}/Target_Samples/GeneEvolve_Output/VA"$1"_VF0_matcor"$2

/pl/active/KellerLab/Emmanuel/GeneEvolve/bin/GeneEvolve_20190708 \
    --file_gen_info "${file_path}/Target_Samples/GeneEvolve_Input/par.pop1.info/par.pop1.info.matcor"$2".txt" \
	--file_hap_name "${file_path}/Target_Samples/GeneEvolve_Input/par.pop1.info/par.pop1.hap1_sample_address.txt" \
	--file_recom_map "${file_path}/Target_Samples/GeneEvolve_Input/Recom.Map.b37.50KbDiff" \
	--file_cvs "${file_path}/Target_Samples/GeneEvolve_Input/par.pop1.info/par.pop1.cv_hap_files.txt" \
	--file_cv_info "${file_path}/Target_Samples/GeneEvolve_Input/par.pop1.info/par.pop1.cv_info.txt" \
    --seed 124 \
    --va $1 \
    --ve $3 \
    --vd 0 \
    --avoid_inbreeding \
    --out_hap \
    --file_output_generations "${file_path}/Target_Samples/GeneEvolve_Input/par.pop1.info/Target_Samples/GeneEvolve_Input/par.gen_output.txt" \
    --prefix $path | tee "/VA"$1"_VF0_matcor"$2".out"

