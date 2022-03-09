################################################################################
#
# Plot estimates of the birth-death model
#
# authors: Sebastian Höhna
#
################################################################################

library(RevGadgets)
library(ggplot2)

# read the posterior and prior output
bd_posterior <- readTrace("output/primates_BD.log")

# plot the prior vs the posterior
plot <- plotTrace(bd_posterior, vars=c("birth_rate", "death_rate"))[[1]]  +
     # modify legend location using ggplot2
     theme(legend.position = c(0.80,0.80))

ggsave("birth_death_rate.png", plot, height=5, width=5)
