################################################################################
#
# Plot estimates of the Brownian motion model
#
# authors: Michael R. May and Sebastian Höhna
#
################################################################################

library(RevGadgets)
library(ggplot2)

# read the posterior and prior output
simple_BM_posterior <- readTrace("output/simple_BM.log")[[1]]
simple_BM_prior     <- readTrace("output/simple_BM_prior.log")[[1]]

# combine the samples into one data frame
simple_BM_posterior$sigma2_prior <- simple_BM_prior$sigma2

# plot the prior vs the posterior
plot <- plotTrace(list(simple_BM_posterior), vars=c("sigma2", "sigma2_prior"))

pdf("sigma_prior_posterior.pdf", height=4)
plot
dev.off()
