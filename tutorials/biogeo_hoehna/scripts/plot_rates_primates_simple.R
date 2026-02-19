################################################################################
#
# Plot rates of morphological evolution
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

# specify the input file
file <- "output/primates_simple.model.log"

# read the trace and discard burnin
trace_quant <- readTrace(path = file, burnin = 0.25)

# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_quant, vars = c( "extirpation_rate", "dispersal_rate"))[[1]] +
     # modify legend location using ggplot2
     theme(legend.position = c(0.85,0.80))

ggsave(paste0("Primates_biogeo_rates.pdf"), p, width = 5, height = 5)




# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_quant, vars = c( paste0("clado_event_probs[",1:4,"]") ))[[1]] +
     # modify legend location using ggplot2
     theme(legend.position = c(0.85,0.80))

ggsave(paste0("Primates_biogeo_clado_probs.pdf"), p, width = 5, height = 5)
