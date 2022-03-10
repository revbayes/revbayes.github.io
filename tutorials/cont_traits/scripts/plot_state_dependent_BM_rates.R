library(RevGadgets)

# read the samples
samples <- readTrace("output/state_dependent_BM_primates.log")

# plot the posterior distribution
pdf("zeta_posterior_primates.pdf", height=4)
plotTrace(samples, match="overall_rate")
dev.off()
