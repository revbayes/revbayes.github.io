library(RevGadgets)
setwd("your_directory")

# read in file 
file <- "primates_cytb_GTR.log"
trace_quant <- readTrace(path = file, burnin = 0.1)

# or remove burnin later:
trace_quant <- readTrace(path = file)
trace_quant <- removeBurnin(trace = trace_quant, burnin = 0.1)

# assess convergence with coda 
trace_quant_MCMC <- coda::as.mcmc(trace_quant[[1]])
coda::effectiveSize(trace_quant_MCMC)
coda::traceplot(trace_quant_MCMC)

# summarize trace for some parameters
summarizeTrace(trace = trace_quant, 
               vars =  c("pi[1]","pi[2]","pi[3]","pi[4]"))

# plot distributions
plotTrace(trace = trace_quant, 
          vars = c("pi[1]","pi[2]","pi[3]","pi[4]"))

# for qualitative variables: 
file <- "freeK_RJ.log"
trace_qual <- readTrace(path = file)
summarizeTrace(trace_qual, 
               vars = c("prob_rate_12", "prob_rate_13", "prob_rate_21",
                        "prob_rate_23", "prob_rate_31", "prob_rate_32"))
plotTrace(trace = trace_qual, 
		  vars = c("prob_rate_12", "prob_rate_13", 
		  		   "prob_rate_31", "prob_rate_32"))

