################################################################################
#
# Plotting the diversification rates under a BiSSE model
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

DATASET <- "activity_period"

# read in and process the log file
bisse_file <- paste0("output/primates_BiSSE_",DATASET,".log")
pdata <- processSSE(bisse_file)

# plot the rates
plot <- plotMuSSE(pdata) +
        theme(legend.position = c(0.875,0.915),
              legend.key.size = unit(0.4, 'cm'), #change legend key size
              legend.title = element_text(size=8), #change legend title font size
              legend.text = element_text(size=6))

ggsave(paste0("BiSSE_div_rates_",DATASET,".png"),plot, width=5, height=5)
