library(RevGadgets)
source("posterior_summary/utils.R")

# read the samples
strict_samples  <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC_run_01/tree.trees", tree_name = "timetree")
UCLN_samples    <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC_run_01/tree.trees", tree_name = "timetree")
UCE_samples     <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCE_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC_run_01/tree.trees", tree_name = "timetree")
epochal_samples <- readTrees("output_MCMC/div_epochal_foss_epochal_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC_run_01/tree.trees", tree_name = "timetree")
F81Mix_samples  <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_F81Mix_MCMC_run_01/tree.trees", tree_name = "timetree")

# combine the samples into one list
combined_samples <- list(strict  = strict_samples[[1]],
                         UCLN    = UCLN_samples[[1]],
                         UCE     = UCE_samples[[1]],
                         epochal = epochal_samples[[1]],
                         F81Mix  = F81Mix_samples[[1]])

# plot the LTTs
LTTs <- processLTT(combined_samples, num_bins = 1001)

pdf("figures/LTTs.pdf", height = 4)
print(plotLTT(LTTs, plotCI = FALSE))
dev.off()

# make the RF MDS plots
RF_MDS <- processMDS(combined_samples, n = 100, type = "RF")

# plot the RF MDS
RF_plot <- plotMDS(RF_MDS)

# save the plot
pdf("figures/mds_RF.pdf")
print(RF_plot)
dev.off()

# make the KF MDS plots
KF_MDS <- processMDS(combined_samples, n = 100, type = "KF")

# plot the KF MDS
KF_plot <- plotMDS(KF_MDS)

# save the plot
pdf("figures/mds_KF.pdf")
print(KF_plot)
dev.off()
