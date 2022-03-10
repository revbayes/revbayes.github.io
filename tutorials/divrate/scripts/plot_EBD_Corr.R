library(RevGadgets)
library(ggplot2)
library(tibble)

# path files
speciation_time_file <- "output/primates_EBD_Corr_speciation_times_run_1.log"
speciation_rate_file <- "output/primates_EBD_Corr_speciation_rates_run_1.log"
extinction_time_file <- "output/primates_EBD_Corr_extinction_times_run_1.log"
extinction_rate_file <- "output/primates_EBD_Corr_extinction_rates_run_1.log"

rates <- processDivRates(speciation_time_log = speciation_time_file,
                         speciation_rate_log = speciation_rate_file,
                         extinction_time_log = extinction_time_file,
                         extinction_rate_log = extinction_rate_file,
                         burnin = 0.25,
                         summary = "median")

ex_df <- read.table(extinction_time_file, sep ="\t", header = TRUE)


# the CO2 values as a reference in our plot
co2 <- c(297.6, 301.36, 304.84, 307.86, 310.36, 312.53, 314.48, 316.31, 317.42, 
         317.63, 317.74, 318.51, 318.29, 316.5, 315.49, 317.64, 318.61, 316.6, 317.77,
         328.27, 351.12, 381.87, 415.47, 446.86, 478.31, 513.77, 550.74, 586.68, 631.48, 
         684.13, 725.83, 757.81, 789.39, 813.79, 824.25, 812.6, 784.79, 755.25, 738.41, 
         727.53, 710.48, 693.55, 683.04, 683.99, 690.93, 694.44, 701.62, 718.05, 731.95,
         731.56, 717.76)

MAX_VAR_AGE <- 50
NUM_INTERVALS <- length(co2)
co2_age <- MAX_VAR_AGE * (1:NUM_INTERVALS) / NUM_INTERVALS
predictor.ages <- co2_age
predictor.var <- co2



co2_df <- tibble("co2" = co2, "co2_age" = co2_age)


p1 <- plotDivRates(rates)

## We can add the Co2 measurements on top of the ggplot object
coeff <- 1500 ## Change the relative plotting scale between rate units and co2 units (ppm)
p2 <- p1 +
  geom_line(data=co2_df, mapping = aes(x = co2_age, y = co2/coeff), inherit.aes = FALSE) +
  scale_y_continuous(
    name = "Rate", ## First y-axis (left)
    sec.axis = sec_axis(~.*coeff, name="Co2 (parts per million)") ## Second y-axis (right)
  )

ggsave("EBD_corr.pdf", plot = p2, width = 150, height = 120, units = "mm")

