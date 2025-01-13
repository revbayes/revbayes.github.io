################################################################################
#
# Plot diversification rates inferred using the episodic birth-death process
# with environmental correlation.
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

# the CO2 values as a reference in our plot
co2 <- c(297.6, 301.36, 304.84, 307.86, 310.36, 312.53, 314.48, 316.31,
         317.42, 317.63, 317.74, 318.51, 318.29, 316.5, 315.49, 317.64, 
         318.61, 316.6, 317.77, 328.27, 351.12, 381.87, 415.47, 446.86, 
         478.31, 513.77, 550.74, 586.68, 631.48, 684.13, 725.83, 757.81, 
         789.39, 813.79, 824.25, 812.6, 784.79, 755.25, 738.41, 727.53,
         710.48, 693.55, 683.04, 683.99, 690.93, 694.44, 701.62, 718.05, 
         731.95, 731.56, 717.76)

MAX_VAR_AGE = 50
NUM_INTERVALS = length(co2)
co2_age <- MAX_VAR_AGE * (1:NUM_INTERVALS) / NUM_INTERVALS

rates <- processDivRates(
  speciation_time_log = "output/primates_EBD_Corr_speciation_times.log",
  speciation_rate_log = "output/primates_EBD_Corr_speciation_rates.log",
  extinction_time_log = "output/primates_EBD_Corr_extinction_times.log",
  extinction_rate_log = "output/primates_EBD_Corr_extinction_rates.log",
  burnin=0.25)

p <- plotDivRates(rates, env_age = co2_age, env_var = co2, env_label = "co2 (ppm)", env_scaling = 1000)
ggsave("figures/EBD_Corr.pdf", p, width = 180, height = 130, units = "mm")
