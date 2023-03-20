#!/bin/sh
#SBATCH --mem=50gb
#SBATCH --ntasks=1
#SBATCH --time=7:00:00

module purge
ml intel gcc

mkdir "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Output/VA"$1"_matcor"$2
path="/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Output/VA"$1"_matcor"$2

/pl/active/KellerLab/Emmanuel/GeneEvolve/bin/GeneEvolve_20190708 \
    --file_gen_info "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Input/par.pop1.info/par.pop1.info.matcor"$2".txt" \
	--file_hap_name /pl/active/KellerLab/Emmanuel/gameticphasing/pl/active/KellerLab/Emmanuel/GeneEvolverun/With30000individualsfromUKBsecondrun/Input_files/par.pop1.hap1_sample_address.txt \
	--file_recom_map /pl/active/KellerLab/Emmanuel/gameticphasing/pl/active/KellerLab/Emmanuel/GeneEvolverun/With30000individualsfromUKBsecondrun/Input_files/Recom.Map.b37.50KbDiff \
	--file_cvs /pl/active/KellerLab/Emmanuel/gameticphasing/pl/active/KellerLab/Emmanuel/GeneEvolverun/With30000individualsfromUKBsecondrun/Input_files/par.pop1.cv_hap_files.txt \
	--file_cv_info /pl/active/KellerLab/Emmanuel/gameticphasing/pl/active/KellerLab/Emmanuel/GeneEvolverun/With30000individualsfromUKBsecondrun/Input_files/par.pop1.cv_info.txt \
    --seed 123 \
    --va $1 \
    --ve $3 \
    --vd 0 \
    --avoid_inbreeding \
    --out_hap \
    --file_output_generations /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Input/par.gen_output.txt \
    --prefix $path | tee "/VA"$1"_matcor"$2".out"
