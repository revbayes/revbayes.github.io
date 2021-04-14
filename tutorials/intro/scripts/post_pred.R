library(RevGadgets)
library(ggplot2)
library(grid)

setwd("your_directory")

# read in and proces data
sim <- "simulated_data_pps_example.csv"
emp <- "empirical_data_pps_example.csv"
t <- processPostPredStats(path_sim = sim, 
                          path_emp = emp)

# plots will produce a list of plots, one for each metric
plots <- plotPostPredStats(data = t)

# arrange a subset of them with grid and ggplot2
grid.newpage()
grid.draw(
  cbind(rbind(ggplotGrob(plots[[1]]),
              ggplotGrob(plots[[5]])),
        rbind(ggplotGrob(plots[[3]] + theme(axis.title.y = element_blank())  ),
              ggplotGrob(plots[[7]] + theme(axis.title.y = element_blank()) )))
)