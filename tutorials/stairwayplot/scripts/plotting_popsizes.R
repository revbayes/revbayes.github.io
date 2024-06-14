library(RevGadgets)
# library(ggplot2)

burnin = 0.1
probs = c(0.025, 0.975)
summary = "median"

num_grid_points = 500

max_age_iso = 5e5
max_age_het = 1.2e6

min_age = 0
spacing = "equal"

####################
# isochronous data #
####################

# BSP
population_size_log = "output/horses_iso_BSP_NEs.log"
interval_change_points_log = "output/horses_iso_BSP_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_BSP.png", p)

# Constant
population_size_log = "output/horses_iso_Constant_NE.log"
df <- processPopSizes(population_size_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_Constant.png", p)

# EBSP
population_size_log = "output/horses_iso_EBSP_NEs.log"
interval_change_points_log = "output/horses_iso_EBSP_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_EBSP.png", p)

# GMRF, 10 intervals
population_size_log = "output/horses_iso_GMRF_NEs.log"
interval_change_points_log = "output/horses_iso_GMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_GMRF.png", p)

# GMRF, 100 intervals
population_size_log = "output/horses_iso_GMRF_100_NEs.log"
interval_change_points_log = "output/horses_iso_GMRF_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_GMRF_100.png", p)

# GMRF, MAP tree based, 10 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_iso_GMRF_maptreebased_NEs.log"
interval_change_points_log = "output/horses_iso_GMRF_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_GMRF_maptreebased.png", p)

# GMRF, MAP tree based, 100 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_iso_GMRF_maptreebased_100_NEs.log"
interval_change_points_log = "output/horses_iso_GMRF_maptreebased_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_GMRF_maptreebased_100.png", p)

# GMRF, tree based, 10 intervals (trees from constant analysis)
population_size_log = "output/horses_iso_GMRF_treebased_NEs.log"
interval_change_points_log = "output/horses_iso_GMRF_treebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_GMRF_treebased.png", p)

# HSMRF, 10 intervals
population_size_log = "output/horses_iso_HSMRF_NEs.log"
interval_change_points_log = "output/horses_iso_HSMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_HSMRF.png", p)

# HSMRF, 100 intervals
population_size_log = "output/horses_iso_HSMRF_100_NEs.log"
interval_change_points_log = "output/horses_iso_HSMRF_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_HSMRF_100.png", p)

# HSMRF, MAP tree based, 10 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_iso_HSMRF_maptreebased_NEs.log"
interval_change_points_log = "output/horses_iso_HSMRF_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_HSMRF_maptreebased.png", p)

# HSMRF, MAP tree based, 100 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_iso_HSMRF_maptreebased_100_NEs.log"
interval_change_points_log = "output/horses_iso_HSMRF_maptreebased_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_HSMRF_maptreebased_100.png", p)

# SkyfishAC
population_size_log = "output/horses_iso_SkyfishAC_NEs.log"
interval_change_points_log = "output/horses_iso_SkyfishAC_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_SkyfishAC.png", p)

# SkyfishAC, MAP tree based (MAP tree from constant analysis)
population_size_log = "output/horses_iso_SkyfishAC_maptreebased_NEs.log"
interval_change_points_log = "output/horses_iso_SkyfishAC_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_SkyfishAC_maptreebased.png", p)

# Skygrid
population_size_log = "output/horses_iso_Skygrid_NEs.log"
interval_change_points_log = "output/horses_iso_Skygrid_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_Skygrid.png", p)

# Skyline
population_size_log = "output/horses_iso_Skyline_NEs.log"
interval_change_points_log = "output/horses_iso_Skyline_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_Skyline.png", p)

# Skyline, MAP tree based (MAP tree from constant analysis)
population_size_log = "output/horses_iso_Skyline_maptreebased_NEs.log"
interval_change_points_log = "output/horses_iso_Skyline_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_Skyline_maptreebased.png", p)

# Skyride
population_size_log = "output/horses_iso_Skyride_NEs.log"
interval_change_points_log = "output/horses_iso_Skyride_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_iso_Skyride.png", p)



# piecewise, 3 constant
population_size_log_skyline = "output/horses_iso_Skyline_NEs.log"
interval_change_points_log_skyline = "output/horses_iso_Skyline_times.log"
df_skyline <- processPopSizes(population_size_log_skyline, interval_change_points_log_skyline, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p_skyline <- plotPopSizes(df_skyline) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))

population_size_log = "output/horses_iso_piecewise_3const_NEs.log"
interval_change_points_log = "output/horses_iso_piecewise_3const_times.log"
pop_sizes <- readTrace(population_size_log, burnin = burnin)[[1]]
interval_times <- readTrace(interval_change_points_log, burnin = burnin)[[1]]

pop_size_medians = apply(pop_sizes[,grep("size", names(pop_sizes))], 2, median)
pop_size_quantiles = apply(pop_sizes[,grep("size", names(pop_sizes))], 2, quantile, probs = probs)
time_medians =apply(interval_times[,grep("change_points", names(interval_times))], 2, median)

df <- tibble::tibble(.rows = length(pop_size_medians))

df$value = pop_size_medians
df$lower = pop_size_quantiles[1,]
df$upper = pop_size_quantiles[2,]
df$time = c(0, time_medians)
df$time_end = c(time_medians, Inf)

p <- p_skyline + ggplot2::geom_segment(data = df, ggplot2::aes(x = time, xend = time_end, y = value, yend = value), linewidth = 0.9, color = "blue") +
  ggplot2::geom_rect(data = df, ggplot2::aes(xmin = time, xmax = time_end, ymin = lower, ymax = upper), fill = "blue", alpha = 0.2)
ggplot2::ggsave("figures/horses_iso_piecewise_3const.png", p)

# piecewise, 6 different
population_size_log_skyline = "output/horses_iso_Skyline_NEs.log"
interval_change_points_log_skyline = "output/horses_iso_Skyline_times.log"
df_skyline <- processPopSizes(population_size_log_skyline, interval_change_points_log_skyline, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p_skyline <- plotPopSizes(df_skyline) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))

population_size_log = "output/horses_iso_piecewise_6diff_NEs.log"
interval_change_points_log = "output/horses_iso_piecewise_6diff_times.log"
pop_sizes <- readTrace(population_size_log, burnin = burnin)[[1]]
interval_times <- readTrace(interval_change_points_log, burnin = burnin)[[1]]

pop_size_medians = apply(pop_sizes[,grep("size", names(pop_sizes))], 2, median)
pop_size_quantiles = apply(pop_sizes[,grep("size", names(pop_sizes))], 2, quantile, probs = probs)
time_medians = apply(interval_times[,grep("change_points", names(interval_times))], 2, median)

exponential_dem <- function(t, N0, N1, t0, t1){
  alpha = log( N1/N0 ) / (t0 - t1)
  return (N0 * exp( (t0-t) * alpha))
}

linear_dem <- function(t, N0, N1, t0, t1){
  alpha = ( N1-N0 ) / (t1 - t0)
  return (N0 + (t-t0) * alpha)
}

all_combined <- function(t){
  if (t < time_medians[1]){
    
    return(exponential_dem(t, N0 = pop_size_medians[1], N1 = pop_size_medians[2], t0 = 0, t1 = time_medians[1]))
    
  } else if (t < time_medians[2]){
    
    return(exponential_dem(t, N0 = pop_size_medians[2], N1 = pop_size_medians[3], t0 = time_medians[1], t1 = time_medians[2]))
    
  } else if (t < time_medians[3]){
    
    return(linear_dem(t, N0 = pop_size_medians[3], N1 = pop_size_medians[4], t0 = time_medians[2], t1 = time_medians[3]))
    
  } else if (t < time_medians[4]){
    
    return(pop_size_medians[4])
    
  } else if (t < time_medians[5]){
    
    return(linear_dem(t, N0 = pop_size_medians[4], N1 = pop_size_medians[5], t0 = time_medians[4], t1 = time_medians[5]))
    
  } else {
    
    return(pop_size_medians[5])
    
  }
}

all_lower <- function(t){
  if (t < time_medians[1]){
    
    return(exponential_dem(t, N0 = pop_size_quantiles[1,1], N1 = pop_size_quantiles[1,2], t0 = 0, t1 = time_medians[1]))
    
  } else if (t < time_medians[2]){
    
    return(exponential_dem(t, N0 = pop_size_quantiles[1,2], N1 = pop_size_quantiles[1,3], t0 = time_medians[1], t1 = time_medians[2]))
    
  } else if (t < time_medians[3]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[1,3], N1 = pop_size_quantiles[1,4], t0 = time_medians[2], t1 = time_medians[3]))
    
  } else if (t < time_medians[4]){
    
    return(pop_size_quantiles[1,4])
    
  } else if (t < time_medians[5]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[1,4], N1 = pop_size_quantiles[1,5], t0 = time_medians[4], t1 = time_medians[5]))
    
  } else {
    
    return(pop_size_quantiles[1,5])
    
  }
}

all_upper <- function(t){
  if (t < time_medians[1]){
    
    return(exponential_dem(t, N0 = pop_size_quantiles[2,1], N1 = pop_size_quantiles[2,2], t0 = 0, t1 = time_medians[1]))
    
  } else if (t < time_medians[2]){
    
    return(exponential_dem(t, N0 = pop_size_quantiles[2,2], N1 = pop_size_quantiles[2,3], t0 = time_medians[1], t1 = time_medians[2]))
    
  } else if (t < time_medians[3]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[2,3], N1 = pop_size_quantiles[2,4], t0 = time_medians[2], t1 = time_medians[3]))
    
  } else if (t < time_medians[4]){
    
    return(pop_size_quantiles[2,4])
    
  } else if (t < time_medians[5]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[2,4], N1 = pop_size_quantiles[2,5], t0 = time_medians[4], t1 = time_medians[5]))
    
  } else {
    
    return(pop_size_quantiles[2,5])
    
  }
}

grid = seq(0, max_age_iso, length.out = 500)
pop_size_median <- sapply(grid, all_combined)
pop_size_lower <- sapply(grid, all_lower)
pop_size_upper <- sapply(grid, all_upper)

df <-tibble::tibble(.rows = length(grid))
df$value <- pop_size_median
df$lower <- pop_size_lower
df$upper <- pop_size_upper
df$time <- grid

p <- p_skyline +
  ggplot2::geom_line(data = df, ggplot2::aes(x = time, y = value), linewidth = 0.9, color = "blue") +
  ggplot2::geom_ribbon(data = df, ggplot2::aes(x = time, ymin = lower, ymax = upper), fill = "blue", alpha = 0.2)
ggplot2::ggsave("figures/horses_iso_piecewise_6diff.png", p)


# piecewise, 3 linear

population_size_log_skyline = "output/horses_iso_Skyline_NEs.log"
interval_change_points_log_skyline = "output/horses_iso_Skyline_times.log"
df_skyline <- processPopSizes(population_size_log_skyline, interval_change_points_log_skyline, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_iso, min_age = min_age, spacing = spacing)
p_skyline <- plotPopSizes(df_skyline) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))

population_size_log = "output/horses_iso_piecewise_3lin_NEs.log"
interval_change_points_log = "output/horses_iso_piecewise_3lin_times.log"
pop_sizes <- readTrace(population_size_log, burnin = burnin)[[1]]
interval_times <- readTrace(interval_change_points_log, burnin = burnin)[[1]]

pop_size_medians = apply(pop_sizes[,grep("size", names(pop_sizes))], 2, median)
pop_size_quantiles = apply(pop_sizes[,grep("size", names(pop_sizes))], 2, quantile, probs = probs)
time_medians = apply(interval_times[,grep("change_points", names(interval_times))], 2, median)

linear_dem <- function(t, N0, N1, t0, t1){
  alpha = ( N1-N0 ) / (t1 - t0)
  return (N0 + (t-t0) * alpha)
}

all_combined <- function(t){
  if (t < time_medians[1]){
    
    return(linear_dem(t, N0 = pop_size_medians[1], N1 = pop_size_medians[2], t0 = 0, t1 = time_medians[1]))
    
  } else if (t < time_medians[2]){
    
    return(linear_dem(t, N0 = pop_size_medians[2], N1 = pop_size_medians[3], t0 = time_medians[1], t1 = time_medians[2]))
    
  } else if (t < time_medians[3]){
    
    return(linear_dem(t, N0 = pop_size_medians[3], N1 = pop_size_medians[4], t0 = time_medians[2], t1 = time_medians[3]))
    
  } else {
    
    return(pop_size_medians[4])
    
  }
}

all_lower <- function(t){
  if (t < time_medians[1]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[1,1], N1 = pop_size_quantiles[1,2], t0 = 0, t1 = time_medians[1]))
    
  } else if (t < time_medians[2]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[1,2], N1 = pop_size_quantiles[1,3], t0 = time_medians[1], t1 = time_medians[2]))
    
  } else if (t < time_medians[3]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[1,3], N1 = pop_size_quantiles[1,4], t0 = time_medians[2], t1 = time_medians[3]))
    
  } else {
    
    return(pop_size_quantiles[1,4])
    
  }
}

all_upper <- function(t){
  if (t < time_medians[1]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[2,1], N1 = pop_size_quantiles[2,2], t0 = 0, t1 = time_medians[1]))
    
  } else if (t < time_medians[2]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[2,2], N1 = pop_size_quantiles[2,3], t0 = time_medians[1], t1 = time_medians[2]))
    
  } else if (t < time_medians[3]){
    
    return(linear_dem(t, N0 = pop_size_quantiles[2,3], N1 = pop_size_quantiles[2,4], t0 = time_medians[2], t1 = time_medians[3]))
    
  } else {
    
    return(pop_size_quantiles[2,4])
    
  }
}

grid = seq(0, max_age_iso, length.out = 500)
pop_size_median <- sapply(grid, all_combined)
pop_size_lower <- sapply(grid, all_lower)
pop_size_upper <- sapply(grid, all_upper)

df <-tibble::tibble(.rows = length(grid))
df$value <- pop_size_median
df$lower <- pop_size_lower
df$upper <- pop_size_upper
df$time <- grid

p <- p_skyline +
  ggplot2::geom_line(data = df, ggplot2::aes(x = time, y = value), linewidth = 0.9, color = "blue") +
  ggplot2::geom_ribbon(data = df, ggplot2::aes(x = time, ymin = lower, ymax = upper), fill = "blue", alpha = 0.2)
ggplot2::ggsave("figures/horses_iso_piecewise_3lin.png", p)

#######################
# heterochronous data #
#######################

# BSP
population_size_log = "output/horses_het_BSP_NEs.log"
interval_change_points_log = "output/horses_het_BSP_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_BSP.png", p)

# Constant
population_size_log = "output/horses_het_Constant_NE.log"
df <- processPopSizes(population_size_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_Constant.png", p)

# EBSP
population_size_log = "output/horses_het_EBSP_NEs.log"
interval_change_points_log = "output/horses_het_EBSP_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_EBSP.png", p)

# GMRF, 10 intervals
population_size_log = "output/horses_het_GMRF_NEs.log"
interval_change_points_log = "output/horses_het_GMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_GMRF.png", p)

# GMRF, 100 intervals
population_size_log = "output/horses_het_GMRF_100_NEs.log"
interval_change_points_log = "output/horses_het_GMRF_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_GMRF_100.png", p)

# GMRF, MAP tree based, 10 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_het_GMRF_maptreebased_NEs.log"
interval_change_points_log = "output/horses_het_GMRF_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_GMRF_maptreebased.png", p)

# GMRF, MAP tree based, 100 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_het_GMRF_maptreebased_100_NEs.log"
interval_change_points_log = "output/horses_het_GMRF_maptreebased_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_GMRF_maptreebased_100.png", p)

# GMRF, tree based, 10 intervals (trees from constant analysis)
population_size_log = "output/horses_het_GMRF_treebased_NEs.log"
interval_change_points_log = "output/horses_het_GMRF_treebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_GMRF_treebased.png", p)

# HSMRF, 10 intervals
population_size_log = "output/horses_het_HSMRF_NEs.log"
interval_change_points_log = "output/horses_het_HSMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_HSMRF.png", p)

# HSMRF, 100 intervals
population_size_log = "output/horses_het_HSMRF_100_NEs.log"
interval_change_points_log = "output/horses_het_HSMRF_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_HSMRF_100.png", p)

# HSMRF, MAP tree based, 10 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_het_HSMRF_maptreebased_NEs.log"
interval_change_points_log = "output/horses_het_HSMRF_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_HSMRF_maptreebased.png", p)

# HSMRF, MAP tree based, 100 intervals (MAP tree from constant analysis)
population_size_log = "output/horses_het_HSMRF_maptreebased_100_NEs.log"
interval_change_points_log = "output/horses_het_HSMRF_maptreebased_100_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_HSMRF_maptreebased_100.png", p)

# SkyfishAC
population_size_log = "output/horses_het_SkyfishAC_NEs.log"
interval_change_points_log = "output/horses_het_SkyfishAC_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_SkyfishAC.png", p)

# SkyfishAC, MAP tree based (MAP tree from constant analysis)
population_size_log = "output/horses_het_SkyfishAC_maptreebased_NEs.log"
interval_change_points_log = "output/horses_het_SkyfishAC_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_SkyfishAC_maptreebased.png", p)

# Skygrid
population_size_log = "output/horses_het_Skygrid_NEs.log"
interval_change_points_log = "output/horses_het_Skygrid_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_Skygrid.png", p)

# Skyline
population_size_log = "output/horses_het_Skyline_NEs.log"
interval_change_points_log = "output/horses_het_Skyline_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_Skyline.png", p)

# Skyline, MAP tree based (MAP tree from constant analysis)
population_size_log = "output/horses_het_Skyline_maptreebased_NEs.log"
interval_change_points_log = "output/horses_het_Skyline_maptreebased_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_Skyline_maptreebased.png", p)

# Skyride
population_size_log = "output/horses_het_Skyride_NEs.log"
interval_change_points_log = "output/horses_het_Skyride_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, burnin = burnin, probs = probs, summary = summary, num_grid_points = num_grid_points, max_age = max_age_het, min_age = min_age, spacing = spacing)
p <- plotPopSizes(df) + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("figures/horses_het_Skyride.png", p)
