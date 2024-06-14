################################################################################
#
# R script: Plotting the demographic history from a StairwayPlot analysis.
#
#
# authors: Sebastian Hoehna
#
################################################################################


library(RevGadgets)
library(ggplot2)

burnin = 0.1
probs = c(0.025, 0.975)
summary = "median"

x.lim <- c(1E2,1E7)
y.lim <- c(1E3,1E7)

num_grid_points = 500

for (run in 1:4) {

  population_size_log = paste0("output/StairwayPlot_iid_ordered_Ne_run_",run,".log")
  interval_change_points_log = paste0("output/StairwayPlot_iid_ordered_times_run_",run,".log")

  df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points)

  p <- plotPopSizes(df) +
       ggtitle( paste0("Demography of Lampyris noctiluca (Munich) - Rep ", run ) ) + theme(plot.title = element_text(hjust = 0.5, size=10, face="bold.italic")) +
       xlab("Time before present (in years)") + theme(axis.title.x = element_text(size=10, face="bold")) +
       scale_x_continuous(trans='log10', limits = x.lim, breaks=c(1E2,1E3,1E4,1E5,1E6,1E7), labels=c("1E2","1E3","1E4","1E5","1E6","1E7")) +
       ylab("Effective Population Size") + theme(axis.title.y = element_text(size=10, face="bold")) +
       scale_y_continuous(trans='log10', limits = y.lim, breaks=c(1E2,1E3,1E4,1E5,1E6,1E7), labels=c("1E2","1E3","1E4","1E5","1E6","1E7"))

  ggplot2::ggsave(filename=paste0("figures/StairwayPlot_iid_",run,".pdf"), plot=p, width=4, height=4)
  ggplot2::ggsave(filename=paste0("figures/StairwayPlot_iid_",run,".png"), plot=p, width=4, height=4)
}
