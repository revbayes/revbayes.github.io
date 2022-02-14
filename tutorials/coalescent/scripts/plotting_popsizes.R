library(devtools)
devtools::install_github("revbayes/RevGadgets", force = TRUE)
library(RevGadgets)

burnin = 0.1
probs = c(0.025, 0.975)
summary = "median"

# constant
population_size_log = "../output/horses_constant_NE.log"
df <- processPopSizes(population_size_log, method = "constant", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "constant") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8), xlim = c(1e5, 0))
ggplot2::ggsave("../figures/horses_constant.png", p)

# skyline
population_size_log = "../output/horses_skyline_NEs.log"
interval_change_points_log = "../output/horses_skyline_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "events", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_skyline.png", p)

# skyline, MAP tree based (MAP tree from constant analysis)
population_size_log = "../output/horses_skyline_maptreebased_NEs.log"
interval_change_points_log = "../output/horses_skyline_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "events", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_skyline_maptreebased.png", p)

# GMRF, 10 intervals
population_size_log = "../output/horses_GMRF_NEs.log"
interval_change_points_log = "../output/horses_GMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_GMRF.png", p)

# GMRF, 100 intervals
population_size_log = "../output/horses_GMRF_100_NEs.log"
interval_change_points_log = "../output/horses_GMRF_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", summary = "median", burnin = 0.1)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_GMRF_100.png", p)

# GMRF, MAP tree based, 10 intervals (MAP tree from constant analysis)
population_size_log = "../output/horses_GMRF_maptreebased_NEs.log"
interval_change_points_log = "../output/horses_GMRF_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_GMRF_maptreebased.png", p)

# GMRF, MAP tree based, 100 intervals (MAP tree from constant analysis)
population_size_log = "../output/horses_GMRF_maptreebased_100_NEs.log"
interval_change_points_log = "../output/horses_GMRF_maptreebased_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_GMRF_maptreebased_100.png", p)

# GMRF, tree based, 10 intervals (trees from constant analysis)
population_size_log = "../output/horses_GMRF_treebased_NEs.log"
interval_change_points_log = "../output/horses_GMRF_treebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_GMRF_treebased.png", p)

# HSMRF, 10 intervals
population_size_log = "../output/horses_HSMRF_NEs.log"
interval_change_points_log = "../output/horses_HSMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_HSMRF.png", p)

# HSMRF, 100 intervals
population_size_log = "../output/horses_HSMRF_100_NEs.log"
interval_change_points_log = "../output/horses_HSMRF_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_HSMRF_100.png", p)

# HSMRF, MAP tree based, 10 intervals (MAP tree from constant analysis)
population_size_log = "../output/horses_HSMRF_maptreebased_NEs.log"
interval_change_points_log = "../output/horses_HSMRF_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_HSMRF_maptreebased.png", p)

# HSMRF, MAP tree based, 100 intervals (MAP tree from constant analysis)
population_size_log = "../output/horses_HSMRF_maptreebased_100_NEs.log"
interval_change_points_log = "../output/horses_HSMRF_maptreebased_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_HSMRF_maptreebased_100.png", p)

# CPP
population_size_log = "../output/horses_CPP_NEs.log"
interval_change_points_log = "../output/horses_CPP_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "events", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_CPP.png", p)

# CPP, MAP tree based (MAP tree from constant analysis)
population_size_log = "../output/horses_CPP_maptreebased_NEs.log"
interval_change_points_log = "../output/horses_CPP_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "events", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("../figures/horses_CPP_maptreebased.png", p)
