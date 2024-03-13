library(devtools)
devtools::install_github("lfabreti/convenience", force = TRUE)
library(convenience)

converged = checkConvergence(list_files = c("../output/horses_constant_run_1.log",
                                            "../output/horses_constant_run_2.log",
                                            "../output/horses_constant_run_1.trees",
                                            "../output/horses_constant_run_2.trees"),
                             format = "revbayes")

converged

converged$continuous_parameters

converged$continuous_parameters$means     
converged$continuous_parameters$ess
converged$continuous_parameters$compare_runs

# converged$tree_parameters$frequencies
converged$tree_parameters$ess
converged$tree_parameters$compare_runs
# which(converged$tree_parameters$compare_runs[[1]] > 0.09)


converged$message_complete

converged$failed_names

plotDiffSplits(converged)
plotEssContinuous(converged)
plotEssSplits(converged)
plotKS(converged)
# plotKSPooled(converged)
