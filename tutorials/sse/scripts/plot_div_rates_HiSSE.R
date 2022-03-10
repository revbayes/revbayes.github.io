################################################################################
#
# Plotting the diversification rates under a HiSSE model
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

DATASET <- "activity_period"

# read in and process the log file
bisse_file <- paste0("output/primates_HiSSE_",DATASET,"_run_1.log")
pdata <- processSSE(bisse_file)

# plot the rates
plot <- plotHiSSE(pdata)

ggsave(paste0("HiSSE_div_rates_",DATASET,".png"),plot, width=10, height=10)
