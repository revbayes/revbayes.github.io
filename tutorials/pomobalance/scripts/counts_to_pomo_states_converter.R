# This script reads a count file and creates a PoMo alignment in the "NaturalNumbers" type that can be uploaded into RevBayes.

# setting the working directory
setwd(getwd())

# install.packages("Rcpp")  
library("Rcpp")

# uploading the function counts_to_pomo_states_converter
sourceCpp("weighted_sampled_method.cpp")

name <- "great_apes_BS_10000"
count_file <- paste0("../data/", name, ".cf")     # count file
n_alleles  <- 4                        # the four nucleotide bases A, C, G and T
N          <- 10                        # virtual population size

alignment <- counts_to_pomo_states_converter(count_file,n_alleles,N)

# writing the PoMo alignment
writeLines(alignment,paste0("../data/", name, ".txt"))
