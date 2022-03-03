################################################################################
#
# Plot support for OU model vs BM model
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

# specify the input file
file <- paste0("output/simple_OU_RJ.log")

# read the trace and discard burnin
trace_qual <- readTrace(path = file, burnin = 0.25)

BF <- c(3.2, 10, 100)
p = BF/(1+BF)
# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_qual,
          vars = c("is_OU"))[[1]] +
          ylim(0,1) +
          geom_hline(yintercept=0.5, linetype="solid", color = "black") +
          geom_hline(yintercept=p, linetype=c("longdash","dashed","dotted"), color = "red") +
          geom_hline(yintercept=1-p, linetype=c("longdash","dashed","dotted"), color = "red") +
     # modify legend location using ggplot2
     theme(legend.position = c(0.40,0.825))

ggsave(paste0("ou_RJ.pdf"), p, width = 5, height = 5)
