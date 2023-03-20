import os
import pandas as pd
import re
from glob import glob

file_path = "/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/PGS/"
params_list = ["VA.2_matcor0", "VA.2_matcor.2", "VA.2_matcor.6", "VA.2_matcor.8",
               "VA.5_matcor0", "VA.5_matcor.2", "VA.5_matcor.6", "VA.5_matcor.8",
               "VA.8_matcor0", "VA.8_matcor.2", "VA.8_matcor.6", "VA.8_matcor.8"]

# Combining the Phenotype and PGS files:
for params in params_list:
    phen_file = os.path.join(file_path, f"Sample_Phenotypes/{params}.info.pop1.gen10.sample")
    phen = pd.read_csv(phen_file, sep="\t", usecols=["ID", "ph1_P", "ph1_A"])[1:]
    phen["ID"] = "per" + phen["ID"].astype(str)

    pgs_path = os.path.join(file_path, f"Sample_PGSs/{params}/")
    pgs_files = glob(os.path.join(pgs_path, "*.sscore"))

    phen_pgs = phen
    for pgs_file in pgs_files:
        pgs_temp = pd.read_csv(pgs_file, sep="\t", usecols=[0, 3])
        pgs_name = re.search('Discovery_\\s*(.*?)\\s*.sscore', pgs_file).group(1)
        pgs_temp.columns = ["ID", pgs_name]
        phen_pgs = pd.merge(phen_pgs, pgs_temp, on="ID")


    new_phen_pgs = phen_pgs[['ID','ph1_A','ph1_P']]
    for param in params_list:
        # Sum across chromosomes:
        phen_pgs_temp = phen_pgs
        chr_cols = [param + '_chr' + str(i) for i in range(1, 23)]
        phen_pgs_temp[param] = phen_pgs_temp[chr_cols].sum(axis=1)
        phen_pgs_temp = pd.DataFrame(phen_pgs_temp[['ID', param]])
        phen_pgs_temp.columns = ["ID", "PGS_" + param]
        new_phen_pgs = pd.merge(new_phen_pgs, phen_pgs_temp, on="ID")
    
    minus_phen = new_phen_pgs.pop("ph1_P")
    new_phen_pgs.insert(1, "ph1_P", minus_phen)

    # Save the Output:
    output_file = os.path.join(file_path, f"Phen_PGS/PGS_{params}.txt")
    new_phen_pgs.to_csv(output_file, sep=",", index=False)
    
# Maybe the issue is due to the scale? So I'll try standardizing all of the PGS's.       
for params in params_list:
    input_file = os.path.join(file_path, f"Phen_PGS/PGS_{params}.txt")
    phen_pgs = pd.read_csv(input_file, sep=",")

    phen_pgs_std = phen_pgs
    phen_pgs_std.iloc[:,1:] = (phen_pgs_std.iloc[:,1:] - phen_pgs_std.iloc[:,1:].mean()) / phen_pgs_std.iloc[:,1:].std()

    output_file_std = os.path.join(file_path, f"Phen_PGS/Standardized_PGS_{params}.txt")
    phen_pgs_std.to_csv(output_file_std, sep=",", index=False)

#############################
# Regression Stage
#############################

import pandas as pd
import numpy as np
import re
from glob import glob

params_list = ["VA.2_matcor0", "VA.2_matcor.2", "VA.2_matcor.6", "VA.2_matcor.8",
               "VA.5_matcor0", "VA.5_matcor.2", "VA.5_matcor.6", "VA.5_matcor.8",
               "VA.8_matcor0", "VA.8_matcor.2", "VA.8_matcor.6", "VA.8_matcor.8"]

def regression_task(file):
    # Read in the Phen/ PGS File, and change the names to make them more informative:
    pgs_df = pd.read_csv(file, sep=',', header=0)
    pgs_df = pgs_df.iloc[:, 1:]
    sim_params = re.search(r'PGS_(.*).txt', file).group(1)
    pgs_df = pgs_df.rename(columns={'ph1_A': 'True_VA', 'ph1_P': 'Phen_' + sim_params})

    # Function to separately regress the phenotype on all other columns: 
    regressions = [round(np.corrcoef(pgs_df.iloc[:, 0], pgs_df[col])[0, 1] ** 2, 4) for col in pgs_df.columns[1:]]
    #
    # Put the regression results into the proper format
    results = pd.DataFrame({'Target': [pgs_df.columns[0]], 'True_VA': [regressions[0]], 
                            **{'PGS_' + params_list[i]: [regressions[i+1]] for i in range(len(params_list))}})

    return results

# create a list of data frames to perform the regression task on
df_list = [f for f in glob('/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/PGS/Phen_PGS/PGS*.txt')]

df_list_std = [f for f in glob('/pl/active/KellerLab/jared/Vertical_Transmission/GeneEvolve/Update_2023/Target_Samples/PGS/Phen_PGS/Standardized*.txt')]

# perform the regression task for each data frame in the list
results_list = [regression_task(f) for f in df_list]
results_list_std = [regression_task(f) for f in df_list_std]

# combine the results into a single data frame
df_final = pd.concat(results_list, ignore_index=True)
df_final_std = pd.concat(results_list, ignore_index=True)
