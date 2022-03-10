################################################################################
#
# Plot estimates of the Yule model
#
# authors: Sebastian Höhna
#
################################################################################

library(RevGadgets)
library(ggplot2)

# read the posterior and prior output
yule_posterior <- readTrace("output/primates_Yule.log")[[1]]
yule_prior     <- readTrace("output/primates_Yule_prior.log")[[1]]

# combine the samples into one data frame
yule_posterior$birth_rate_prior <- yule_prior$birth_rate

# plot the prior vs the posterior
plot <- plotTrace(list(yule_posterior), vars=c("birth_rate", "birth_rate_prior"))[[1]]  +
     # modify legend location using ggplot2
     theme(legend.position = c(0.80,0.80))

ggsave("birth_rate_prior_posterior.png", plot, height=5, width=5)
