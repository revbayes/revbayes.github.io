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

CHARACTER  <- "solitariness"
CHARACTER  <- "habitat"
CHARACTER  <- "terrestrially"
NUM_HIDDEN_STATES <- 2

# specify the input file
file <- paste0("output/",CHARACTER,"_hrm.log")

# read the trace and discard burnin
trace_quant <- readTrace(path = file, burnin = 0.25)

# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_quant, vars = c( paste0("rate_loss[",1:NUM_HIDDEN_STATES,"]"), paste0("rate_gain[",1:NUM_HIDDEN_STATES,"]")))[[1]] +
     # modify legend location using ggplot2
     theme(legend.position = c(0.85,0.80))

ggsave(paste0("Primates_",CHARACTER,"_rates_HRM.pdf"), p, width = 5, height = 5)
