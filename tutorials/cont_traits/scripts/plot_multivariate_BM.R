library(RevGadgets)

# read the output
samples <- readTrace("output/multivariate_BM.log")

# plot the posterior distribution
pdf("correlations.pdf", height=4)
plotTrace(samples, vars=paste0("correlations[",1:8,"]"))
dev.off()
