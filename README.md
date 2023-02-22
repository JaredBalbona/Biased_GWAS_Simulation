## Biased Genomewide Association Study (GWAS) Simulation
----

### Broad Summary:

The motivation behind these scripts was to better understand the degree of bias that results from calculating polygenic scores using biased GWAS summary statistics. *GWAS summary statistics* reflect the magnitude of association between each genetic variant and a given outcome (e.g., height), are and used to compute (among other things) *polygenic scores*— a weighted sum reflecting an individual's genetic predisposition to that outcome. 

In the presence of [assortative mating](https://www.sciencedirect.com/topics/biochemistry-genetics-and-molecular-biology/assortative-mating#:~:text=Assortative%20mating%20is%20the%20tendency,would%20be%20expected%20by%20chance.)— the phenomenon in which people tend to preferentially chose mates who are similar to themselves on a given trait— phenotypic variance will increase (as will genetic variance to the degree that the trait is heritable). If unaccounted for, this increased variance will result in upwardly biased GWAS estimates of genetic effects and trait heritability. Thus, I created this simulation pipeline to create polygenic scores from GWAS's with varying degrees of bias due to AM in order to better understand how the level of AM in the GWAS discovery sample will impact analyses in the target sample.

Please feel free to reach out to me at jaba5258@colorado.edu with any quesitons— Thanks!

----

### Specific Steps:

 1. `Run_GeneEvolve_AM_Sim.sh` works iteratively to feed a number of different parameter combinations into `GeneEvolve_AM_Sim.sh`. This allows the resultant jobs to run in parallel. GeneEvolve_AM_Sim.sh, manewhile, runs [GeneEvolve](https://pubmed.ncbi.nlm.nih.gov/27659450/): a "forward time simulator of realistic whole-genome sequence and SNP data".
 
 2. `Make_Sample_Files.sh` converts the GeneEvolve output into a file format that is usable for [plink2](https://www.nature.com/articles/s41467-019-11337-z). 
 
 3. `GeneEvolve_AM_GWAS.sh` and `Run_GeneEvolve_AM_GWAS.sh` operate just like the scripts in Step 1. One iteratively feeds parameters into the other (a script conducting a GWAS using plink2) so that they can run in parallel.
     - I realize that, for a variety of reasons, plink2 is no longer considered the best program for running GWAS and calculating polygenic scores. But that said, I think given the relative simplicity of this simulation, it's plenty sufficient for our purposes. 
     
 4. Repeat Steps 1 and 2 to simulate a *new* sample. 
 
 5. `Calculate_PGS.sh` and `Run_Calculate_PGS.sh`: These scripts create (in parallel) 144 sets of polygenic scores using 12 sets of summary statistics crossed by 12 sets of simulations. 
 
 6. `Compare_PGS_R2.R` Compares the $R^2$ value of each of the 144 PGS's we've created, and displays the results into a user-friendly format. 
