library(RevGadgets)
library(ggplot2)
library(grid)

setwd("your_directory")

# specify the simulated statistics file
sim <- "data/simulated_data_pps_example.csv"

# specify the empirical statistics file
emp <- "data/empirical_data_pps_example.csv"

# read the statistics files
stats <- processPostPredStats(path_sim = sim, 
                              path_emp = emp)

# create the posterior-predictive plots
plots <- plotPostPredStats(data = stats)

# arrange a subset of them with grid and ggplot2
grid.newpage()
grid.draw( # draw the following matrix of plots
  cbind( # bind together the columns into a matrix
    rbind( # bind together the first column
      ggplotGrob(plots[[1]]),
      ggplotGrob(plots[[5]])),
    rbind( # bind together the last column (exclude the y-axis label in the last column)
      ggplotGrob(plots[[3]] + theme(axis.title.y = element_blank())),
      ggplotGrob(plots[[7]] + theme(axis.title.y = element_blank())))))
  
