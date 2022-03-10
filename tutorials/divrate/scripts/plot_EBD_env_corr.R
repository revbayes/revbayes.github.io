################################################################################
#
# Plot correlation factors of episodic birth-death process
# with environmental variables
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

MODEL = "fixed"

# specify the input file
file <- paste0("output/primates_EBD_",MODEL,"_env.log")

trace_env <- readTrace(path = file, burnin = 0.25)

# plot the prior vs the posterior
plot <- plotTrace(trace_env, vars=c("beta_speciation", "beta_extinction"))[[1]]  +
     # modify legend location using ggplot2
     theme(legend.position = c(0.80,0.80))

ggsave(paste0("EBD_",MODEL,"_env_factors.png"), plot, height=5, width=5)





BF <- c(3.2, 10, 100)
p = BF/(1+BF)
# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_env,
          vars = c("speciation_corr_neg_prob", "extinction_corr_neg_prob", "speciation_corr_pos_prob", "extinction_corr_pos_prob"))[[1]] +
          ylim(0,1) +
          geom_hline(yintercept=0.5, linetype="solid", color = "black") +
          geom_hline(yintercept=p, linetype=c("longdash","dashed","dotted"), color = "red") +
          geom_hline(yintercept=1-p, linetype=c("longdash","dashed","dotted"), color = "red") +
     # modify legend location using ggplot2
     theme(legend.position = c(0.825,0.525),
           legend.key.size = unit(0.4, 'cm'), #change legend key size
           legend.title = element_text(size=8), #change legend title font size
           legend.text = element_text(size=6))

ggsave(paste0("EBD_",MODEL,"_env_prob.png"), p, height=5, width=5)
