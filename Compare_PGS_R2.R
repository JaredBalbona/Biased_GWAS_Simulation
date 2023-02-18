
library(data.table)
library(stringr)

setwd("/path/to/main/directory/")

#############################
# Data Munging Stage
#############################

# The different parameters used in our initial simulation:
Params_List <- c("VA.2_VF0_matcor0", "VA.2_VF0_matcor.05", "VA.2_VF0_matcor.2", "VA.2_VF0_matcor.8", "VA.5_VF0_matcor0", "VA.5_VF0_matcor.05", "VA.5_VF0_matcor.2", "VA.5_VF0_matcor.8", "VA.8_VF0_matcor0", "VA.8_VF0_matcor.05", "VA.8_VF0_matcor.2", "VA.8_VF0_matcor.8")

# Combining the Phenotype and PGS files:
for(i in 1:length(Params_List)) {
    # Read in each phenotype file, and append 'per' to the ID#'s so that it can be merged with the PGS file:
    Phen <- fread(paste0(file_path, "Sample_Phenotypes/", Params_List[i],".info.pop1.gen10.sample"), h=T)[-1,c('ID', "ph1_P", "ph1_A")]
    Phen$ID <- paste0('per', Phen$ID)

    # Get list of PGS files that correspond to this phenotype file: 
    PGS_Path <- paste0(file_path, "Sample_PGSs/", Params_List[i], "/")
    PGS_List <- paste0(PGS_Path, list.files(path =  PGS_Path, pattern = "*.sscore", recursive = TRUE))

    # Combine the PGSs (taken from the files in that list) and append them to the phenotype file
    # Then, rename the newly added PGS column so that it describes the discovery sample from which it was derived
    Phen_PGS <- Phen
    for(j in 1:length(PGS_List)){
        PGS_Temp <- fread(PGS_List[j], header = T)[,c(1,4)]
            colnames(PGS_Temp)[1] <- 'ID'
            colnames(PGS_Temp)[2] <- paste0('PGS_', str_match(PGS_List[j], "From_\\s*(.*?)\\s*.sscore")[,2])
            Phen_PGS <- merge(Phen_PGS, PGS_Temp, by = 'ID')
            head(Phen_PGS)
    }
    # Save the Output:
    fwrite(Phen_PGS, paste0('Target_Samples/PGS/Phen_PGS/',Params_List[i], '.txt'), sep=',')
}

#############################
# Regression Stage
#############################

library(data.table)
library(stringr)

rm(list=ls())
Params_List <- c("VA.2_VF0_matcor0", "VA.2_VF0_matcor.05", "VA.2_VF0_matcor.2", "VA.2_VF0_matcor.8", "VA.5_VF0_matcor0", "VA.5_VF0_matcor.05", "VA.5_VF0_matcor.2", "VA.5_VF0_matcor.8", "VA.8_VF0_matcor0", "VA.8_VF0_matcor.05", "VA.8_VF0_matcor.2", "VA.8_VF0_matcor.8")

regression_task <- function(File) {
    
    # Read in the Phen/ PGS File, and change the names to make them more informative:
    DF <- fread(File, h=T)[,-1]

    Sim_Params = str_match(File, "_PGS/\\s*(.*?)\\s*.txt")[,2]
    names(DF)[names(DF) == 'ph1_A'] <- 'True_VA'
    names(DF)[names(DF) == 'ph1_P'] <- paste0("Phen_", Sim_Params)

    # Function to separately regress the phenotype on all other columns: 
    regressions <- lapply(colnames(DF)[-1], function(col) {
        formula <- as.formula(paste(colnames(DF)[1], "~", col))
        fit <- lm(formula, data = DF)
        return(round(summary(fit)$r.squared,4))
    })

    # Put the regression results into the proper format
    results <- data.frame(colnames(DF)[1], regressions)
    colnames(results) <- c("Variable", colnames(DF)[-1])
    #results <- results[,c('Variable', paste0("Gen_", Sim_Params), paste0('PGS_', Params_List))]
    results <- results[,c('Variable', 'True_VA', paste0('PGS_', Params_List))]

    return(results)
}

# create a list of data frames to perform the regression task on
DF_list <- list.files(path = "Target_Samples/PGS/Phen_PGS", pattern = "*.txt", full.names = TRUE)

# perform the regression task for each data frame in the list
results_list <- lapply(DF_list, regression_task)

# combine the results into a single data frame
DF_Final <- do.call(rbind, results_list)