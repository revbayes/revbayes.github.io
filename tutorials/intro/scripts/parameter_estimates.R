library(RevGadgets)
library(coda)
setwd("your_directory")

# specify the input file
file <- "data/primates_cytb_GTR.log"

# read the trace and discard burnin
trace_quant <- readTrace(path = file, burnin = 0.1)

# or read the trace _then_ discard burnin
trace_quant <- readTrace(path = file)
trace_quant <- removeBurnin(trace = trace_quant, burnin = 0.1)

# assess convergence with coda 
trace_quant_MCMC <- as.mcmc(trace_quant[[1]])
effectiveSize(trace_quant_MCMC)
traceplot(trace_quant_MCMC)

# back to RevGadgets - summarize trace for some parameters
summarizeTrace(trace = trace_quant, 
               vars =  c("pi[1]","pi[2]","pi[3]","pi[4]"))

# plot distributions
plotTrace(trace = trace_quant, 
          vars = c("pi[1]","pi[2]","pi[3]","pi[4]"))

# for qualitative variables: 
# read in trace
file <- "data/freeK_RJ.log"
trace_qual <- readTrace(path = file)

# summarize parameters 
summarizeTrace(trace_qual, 
               vars = c("prob_rate_12", "prob_rate_13", "prob_rate_21",
                        "prob_rate_23", "prob_rate_31", "prob_rate_32"))

# plot as histograms
plotTrace(trace = trace_qual, 
          vars = c("prob_rate_12", "prob_rate_13",
                   "prob_rate_31", "prob_rate_32"))[[1]]

