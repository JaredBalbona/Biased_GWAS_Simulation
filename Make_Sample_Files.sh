#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --qos=blanca-ibg
#SBATCH --mem=10gb
#SBATCH --time=1:00:00


ml load intel

for VA in .2 .5 .8; do
for AM in 0 .05 .2 .8; do

# Extract header and first row of the input file
head -n1 /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Output/VA"$VA"_VF0_matcor"$AM"/VA"$VA"_VF0_matcor"$AM".info.pop1.gen10.txt | awk '{OFS="\t"}{print "ID","missing","father","mother","sex",$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}' > /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Input/VA"$VA"_VF0_matcor"$AM".info.pop1.gen10.sample

# Add a second row with all values set to 0 and "P"
echo -e "0\t0\tD\tD\tD\tP\tP\tP\tP\tP\tP\tP\tP\tP\tP" >> /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Input/VA"$VA"_VF0_matcor"$AM".info.pop1.gen10.sample

# Extract remaining rows of the input file and add to the sample file
tail -n+2 /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GeneEvolve_Output/VA"$VA"_VF0_matcor"$AM"/VA"$VA"_VF0_matcor"$AM".info.pop1.gen10.txt | awk '{OFS="\t"}{print $1,0,$2,$3,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}' >> /pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Discovery_Samples/GWAS/GWAS_Input/VA"$VA"_VF0_matcor"$AM".info.pop1.gen10.sample

done
done