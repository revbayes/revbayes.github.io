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
file <- paste0("output/",CHARACTER,"_irrev.log")

# read the trace and discard burnin
trace_qual <- readTrace(path = file, burnin = 0.25)

BF <- c(3.2, 10, 100)
p = BF/(1+BF)
# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_qual,
          vars = paste0("prob_rate[",1:NUM_RATES,"]"))[[1]] +
          ylim(0,1) +
          geom_hline(yintercept=0.5, linetype="solid", color = "black") +
          geom_hline(yintercept=p, linetype=c("longdash","dashed","dotted"), color = "red") +
          geom_hline(yintercept=1-p, linetype=c("longdash","dashed","dotted"), color = "red") +
     # modify legend location using ggplot2
     theme(legend.position = c(0.85,0.85))

ggsave(paste0("Primates_",CHARACTER,"_irrev.pdf"), p, width = 5, height = 5)




# read the trace and discard burnin
trace_quant <- readTrace(path = file, burnin = 0.25)

# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_quant, vars = paste0("rate[",1:NUM_RATES,"]"))[[1]] +
     # modify legend location using ggplot2
     theme(legend.position = c(0.88,0.85))

ggsave(paste0("Primates_",CHARACTER,"_rates_irrev.pdf"), p, width = 5, height = 5)
