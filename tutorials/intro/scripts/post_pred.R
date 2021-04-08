# posterior predictive simulation
library(ggplot2)
library(gridExtra)

# read in and proces data
sim <- "simulated_data_pps_example.csv"
emp <- "empirical_data_pps_example.csv"
t <- processPostPredStats(path_sim = sim, 
                          path_emp = emp)

# plots will produce a list of plots, one for each metric
plots <- plotPostPredStats(data = t)

# arrange a subset of them with gridExtra
grid.arrange(plots[[1]] + theme(axis.title.y =element_blank()),
             plots[[3]] + theme(axis.title.y = element_blank()),
             plots[[5]] + theme(axis.title.y = element_blank()),
             plots[[7]] + theme(axis.title.y = element_blank()),
             left = "Density")