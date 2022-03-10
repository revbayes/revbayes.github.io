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

# specify the input file
file <- paste0("output/",CHARACTER,"_hrm_RJ.log")

# read the trace and discard burnin
trace_qual <- readTrace(path = file, burnin = 0.25)

# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_qual,
          vars = c("prob_gain","prob_loss"))[[1]] +
     # modify legend location using ggplot2
     theme(legend.position = c(0.15,0.85))

ggsave(paste0("Primates_",CHARACTER,"_hrm_RJ.pdf"), p, width = 5, height = 5)
