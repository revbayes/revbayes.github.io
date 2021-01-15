# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)

diversification_rates <- readTrace("output/crocs_CRFBD.log",burnin = 0.25)[[1]]

speciation_prior <- posteriorSamplesToParametricPrior(diversification_rates$speciation_rate,"gamma")
extinction_prior <- posteriorSamplesToParametricPrior(diversification_rates$extinction_rate,"gamma")
fossilization_prior <- posteriorSamplesToParametricPrior(diversification_rates$fossilization_rate,"gamma")

# Now enter these into the Rev script in place of the current values
# The first entry, e.g. speciation_prior[1] is called gamma.shape and is for <parameter_name>_hyperprior_alpha
# The second entry, e.g. speciation_prior[2] is called rate and is for <parameter_name>_hyperprior_beta
# For example,
# speciation_rate_hyperprior_alpha <- <first value in speciation_prior>
# speciation_rate_hyperprior_beta <- <second value in extinction_prior>
# extinction_rate_hyperprior_alpha <- <first value in extinction_prior>
# extinction_rate_hyperprior_beta <- <second value in speciation_prior>
# fossilization_rate_hyperprior_alpha <- <first value in fossilization_prior>
# fossilization_rate_hyperprior_beta <- <second value in fossilization_prior>
