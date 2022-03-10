# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)
library(ggplot2)

# specify the output files
speciation_time_file <- "output/primates_CPP_speciation_times.log"
speciation_rate_file <- "output/primates_CPP_speciation_rates.log"
extinction_time_file <- "output/primates_CPP_extinction_times.log"
extinction_rate_file <- "output/primates_CPP_extinction_rates.log"

# read in and process rates
rates <- processDivRates(speciation_time_log = speciation_time_file,
                         speciation_rate_log = speciation_rate_file,
                         extinction_time_log = extinction_time_file,
                         extinction_rate_log = extinction_rate_file,
                         burnin = 0.25)

# plot rates through time
p <- plotDivRates(df = rates) +
        xlab("Millions of years ago") +
        ylab("Rate per million years")

ggsave("CPP.png", p)
