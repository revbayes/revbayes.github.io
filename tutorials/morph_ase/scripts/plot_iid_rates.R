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
NUM_STATES <- 2
NUM_RATES  <- NUM_STATES * (NUM_STATES-1)

# specify the input file
file <- paste0("output/",CHARACTER,"_freeK.log")

# read the trace and discard burnin
trace_quant <- readTrace(path = file, burnin = 0.25)

# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_quant, vars = paste0("rate[",1:NUM_RATES,"]"))[[1]] +
     # modify legend location using ggplot2
     theme(legend.position = c(0.88,0.85))

ggsave(paste0("Primates_",CHARACTER,"_rates_freeK.pdf"), p, width = 5, height = 5)
