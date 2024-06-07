# library(devtools)
# devtools::install_github("revbayes/RevGadgets", force = TRUE, ref = "dev_pop_size")
library(RevGadgets)
# library(ggplot2)

burnin = 0.1
probs = c(0.025, 0.975)
summary = "median"

num_grid_points = 500

max_age_iso = 5e5
max_age_het = 1.2e6

####################
# isochronous data #
####################

# CPP
population_size_log = "../output/horses_iso_CPP_NEs.log"
interval_change_points_log = "../output/horses_iso_CPP_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_iso_CPP.png", p)

# CPP, MAP tree based (MAP tree from constant analysis)
population_size_log = "../output/horses_iso_CPP_maptreebased_NEs.log"
interval_change_points_log = "../output/horses_iso_CPP_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_iso_CPP_maptreebased.png", p)
