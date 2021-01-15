# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)

mass_extinction_probabilities <- readTrace("output/crocs_EFBDME_mass_extinction_probabilities.log",burnin = 0.25)

# prior probability of mass extinction at any time
prior_n_expected <- 0.1
n_intervals <- 100
prior_prob <- prior_n_expected/(n_intervals-1)

# times when mass extinctions were allowed
tree_age <- 243.5
interval_times <- tree_age * seq(1/n_intervals,(n_intervals-1)/n_intervals,1/n_intervals)

# then plot results:
p <- plotMassExtinctions(mass.extinction.trace=mass_extinction_probabilities,mass.extinction.times=interval_times,mass.extinction.name="mass_extinction_probabilities",prior_prob)

pdf("mass_extinction_Bayes_factors.pdf")
p
dev.off()