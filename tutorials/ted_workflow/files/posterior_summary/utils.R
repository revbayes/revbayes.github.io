library(ggplot2)
library(ape)
library(phytools)
library(phangorn)
library(smacof)
library(gtools)
library(gridExtra)

readMorphoData <- function(filename) {
  do.call(rbind, ape::read.nexus.data(filename))
}

readMorphoPPS <- function(directory, treename = "timetree", morphname = "morph") {
  
  # read the stochastic variable trace
  pps_file <- list.files(directory, pattern = ".var", full.names = TRUE)
  pps_output <- read.table(pps_file, header = TRUE)
  
  # get the trees
  tree_strings <- pps_output[,treename]
  trees <- read.tree(text = tree_strings)
  
  # make sure the trees are bifurcating (put sampled ancestors on a zero-length branch)
  trees <- lapply(trees, make_tree_bifurcating)
  
  # read all the simulated morphology files
  morph_files <- mixedsort(list.files(directory, recursive = TRUE, pattern = morphname, full.names = TRUE))
  morph_data  <- lapply(morph_files, readMorphoData)
  
  # return trees and alignments
  res <- list(trees = trees, data = morph_data)
  return(res)
  
}

parsimony_sum <- function(tree, observed_data, simulated_data) {
  
  # get the state space
  all_chars <- as.vector(observed_data)
  all_chars <- all_chars[all_chars %in% c("?","-") == FALSE]
  states    <- sort(unique(all_chars))
  
  # transform to phyDat for phangorn
  observed_phydat  <- phyDat(observed_data, type = "USER", levels = states)
  simulated_phydat <- phyDat(simulated_data, type = "USER", levels = states)
  
  # compute the parsimony scores for the observed and simulated data
  observed_statistic  <- sum(parsimony(tree, observed_phydat, site="site"))
  simulated_statistic <- sum(parsimony(tree, simulated_phydat, site="site"))
  
  # compute the statistic
  statistic <- simulated_statistic - observed_statistic
  return(statistic)
  
}

parsimony_variance <- function(tree, observed_data, simulated_data) {
  
  # get the state space
  all_chars <- as.vector(observed_data)
  all_chars <- all_chars[all_chars %in% c("?","-") == FALSE]
  states    <- sort(unique(all_chars))
  
  # transform to phyDat for phangorn
  observed_phydat  <- phyDat(observed_data, type = "USER", levels = states)
  simulated_phydat <- phyDat(simulated_data, type = "USER", levels = states)
  
  # compute the parsimony scores for the observed and simulated data
  observed_statistic  <- var(parsimony(tree, observed_phydat, site="site"))
  simulated_statistic <- var(parsimony(tree, simulated_phydat, site="site"))
  
  # compute the statistic
  statistic <- simulated_statistic - observed_statistic
  return(statistic)
  
}

getMorphPPSStatistic <- function(statistic) {
  
  # get the statistic
  if ( class(statistic) == "character" ) {
    if ( statistic == "Parsimony Sum" ) {
      func <- parsimony_sum
    } else if ( statistic == "Parsimony Variance" ) {
      func <- parsimony_variance
    } else {
      stop("Valid statistics are parsimony_sum and parsimony_variance, or a user-provided function.")
    }
  } else if ( class(statistic) == "function" ) {
    if ( all(sort(formalArgs(statistic)) == c("observed_data", "simulated_data", "tree")) ) {
      func <- statistic
    } else {
      stop("User-provided function must have 3 arguments: tree, observed_data, and pps_data.")        
    }
  } else {
    stop("statistic must be parsimony_sum, parsimony_variance, or a user-provided function.")
  }
  
  return(func)
  
}

processMorphoPPS <- function(observed_data,
                             pps_data,
                             statistics = list("Parsimony Sum", "Parsimony Variance"),
                             verbose = TRUE) {
  
  # get the statistics as functions
  num_statistics  <- length(statistics)
  statistic_names <- character(num_statistics)
  for(i in 1:num_statistics) {
    if ( class(statistics[[i]]) == "character" ) {
      statistic_names[i] <- statistics[[i]]
    } else if ( class(statistics[[i]]) == "function" ) {
      statistic_names[i] <- deparse(quote(statistics[[i]]))
    }
  }
  statistics <- lapply(statistics, getMorphPPSStatistic)
  names(statistics) <- statistic_names
  
  # get the trees and simulated data
  posterior_trees <- pps_data$trees
  simulated_data  <- pps_data$data
  
  # alphabetize the data
  taxa <- sort(rownames(observed_data))
  observed_data  <- observed_data[taxa,]
  simulated_data <- lapply(simulated_data, function(x) x[taxa,] )
  
  # apply missing data to all the simulated data
  missing_data <- observed_data == "?" | observed_data == "-"
  simulated_data <- lapply(simulated_data, function(x) {
    x[missing_data] <- "?"
    return(x)
  })
  
  # replace - with ?
  observed_data  <- gsub("-", "?", observed_data)
  simulated_data <- lapply(simulated_data, gsub, pattern = "-", replacement = "?")
  
  # drop missing taxa from the trees
  posterior_trees <- lapply(posterior_trees, function(x) {
    drop.tip(x, x$tip.label[x$tip.label %in% taxa == FALSE])
  })
  
  # compute the statistic for each dataset
  num_samples <- length(posterior_trees)
  stats <- vector("list", num_statistics)
  for(i in 1:num_statistics) {
    these_stats <- numeric(num_samples)
    if (verbose) bar <- txtProgressBar(style = 3, width = 40)
    for(j in 1:num_samples) {
      these_stats[j] <- statistics[[i]](tree = posterior_trees[[j]], observed_data = observed_data, simulated_data = simulated_data[[j]])
      if (verbose) setTxtProgressBar(bar, j / num_samples)
    }
    stats[[i]] <- these_stats
  }

  # reformat
  stats <- data.frame(stats)
  colnames(stats) <- statistic_names
    
  observed_stats <- rep(0, num_statistics)
  names(observed_stats) <- statistic_names
  observed_stats <- as.data.frame(t(observed_stats))
  rownames(observed_stats) <- 1
  
  res <- list(simulated = stats, observed = observed_stats)
  
  # return the distribution of statistics
  return(res)
  
}

boxplotPostPredStats <- function(stats,
                                 col) {
  
  # get the colors
  if ( missing(col) ) {
    col <- RevGadgets::colFun( length(stats) )
  } else {
    if ( length(col) != length(stats) ) {
      stop("Number of colors must be equal to the number of named groups.")
    }
  }
  
  # merge the stats
  stat_names <- colnames(stats[[1]]$simulated)
  run_names  <- names(stats)
  combined_stats <- vector("list", length(stats))
  for(i in 1:length(stats)) {
    these_stats <- unlist(stats[[i]]$simulated)
    these_stat_names <- rep(colnames(stats[[i]]$simulated), each = nrow(stats[[i]]$simulated))
    these_stat_df <- data.frame(name = run_names[i], value = these_stats, stat = these_stat_names)
    rownames(these_stat_df) <- NULL
    combined_stats[[i]] <- these_stat_df
  }
  combined_stats <- do.call(rbind, combined_stats)
  
  # get the true values
  true_stats <- vector("list", length(stats))
  for(i in 1:length(stats)) {
    these_stats <- unlist(stats[[i]]$observed)
    these_stat_df <- data.frame(name = run_names[i], value = these_stats, stat = names(these_stats))
    rownames(these_stat_df) <- NULL
    true_stats[[i]] <- these_stat_df
  }
  true_stats <- do.call(rbind, true_stats)
  
  # create the p-values
  ps <- vector("list", length(stat_names)*length(run_names))
  k <- 0
  for(i in 1:length(stat_names)) {
    for(j in 1:length(run_names)) {
      this_stat <- stat_names[i]
      this_run  <- run_names[j]
      these_sim_stats <- combined_stats[combined_stats$name == this_run & combined_stats$stat == this_stat,]$value
      this_true_value <- stats[[this_run]]$observed[[this_stat]]
      this_p_value <- mean(these_sim_stats > this_true_value)
      # yval <- max(these_sim_stats)
      yval <- quantile(these_sim_stats, 0.75)
      k <- k + 1
      ps[[k]] <- data.frame(name = this_run, stat = this_stat, y = yval, value = paste0("p = ", sprintf("%.3f", this_p_value)))
    }
  }
  ps <- do.call(rbind, ps)
  
  # create the facet plot
  p <- ggplot(combined_stats, aes(x = name, y = value, fill = name)) + 
    geom_hline(data = true_stats, aes(yintercept = value), linetype = "dashed") +
    geom_boxplot() + 
    # geom_text(data = ps, aes(x = name, y = y, label = value), vjust = -1, hjust = -0.1) +
    geom_label(data = ps, aes(x = name, y = y, label = value), fill = "white", label.r = unit(0, "lines"), vjust = -0.2, hjust = -0.1) +
    facet_grid(rows = vars(stat), scales = "free") +
    theme_bw() + scale_x_discrete()
    
  return(p)
  
}

processMDS <- function(trees, type = "KF", n = 100) {
  
  # thin the tree samples
  trees <- lapply(trees, function(x) {
    if ( length(x) > n ) {
      x <- x[floor(seq(1, length(x), length.out = n))]
    }
    return(x)
  })
    
  if ( is.null(names(trees)) ) {
    tree_names <- rep(1:length(trees), times = lengths(trees))
  } else {
    tree_names <- rep(names(trees), times = lengths(trees))
  }
  
  # extract the tree objects and make sure they are bifurcating
  trees <- lapply(trees, function(x) lapply(x, function(y) make_tree_bifurcating(y@phylo)) )
  
  # make a list
  trees_list        <- do.call(c, trees)
  names(trees_list) <- NULL
  class(trees_list)  <- "multiPhylo"
  
  # compute the distance matrix
  if ( type == "KF" ) {
    dist <- as.matrix(phangorn::KF.dist(trees_list))  
  } else if ( type == "RF" ) {
    dist <- as.matrix(phangorn::RF.dist(trees_list))
  } else {
    stop("Type must either be KF or RF")
  }
  
  # do MDS
  mds <- cmdscale(dist)
  mds <- smacofSym(dist, itmax=500, init = mds)$conf
  
  res <- data.frame(x = mds[,1], y = mds[,2], name = tree_names)
  return(res)
  
}

processLTT <- function(trees,
                       CI       = 0.95,
                       num_bins = 101,
                       verbose  = TRUE) {
  
  # get the individual data frames
  LTTs <- lapply(trees, getLTT, CI, num_bins, verbose)
  
  # name the LTTs
  if ( is.null(names(trees)) ) {
    names(LTTs) <- 1:length(LTTs)
  } else {
    names(LTTs) <- names(trees)
  }
  
  # merge the LTTs
  for(i in 1:length(LTTs)) {
    LTTs[[i]]$name <- names(LTTs)[i]
  }
  LTTs <- do.call(rbind, LTTs)
  rownames(LTTs) <- NULL
  
  return(LTTs)
  
}

getLTT <- function(trees, CI, num_bins, verbose) {
  
  # compute the lineage-through-time curves for each tree
  trees     = lapply(trees, function(x) x@phylo)
  num_trees = length(trees)
  
  # compute the node heights
  node_heights = do.call(rbind, lapply(trees, function(x) {
    
    # remove sampled ancestors
    x = collapse.singles(x)
    
    # compute the heights
    heights = nodeHeights(x)
    heights = abs(heights - max(heights))
    heights = round(heights, digits=5)
    
    # node and tip indexes
    tip_idx  = 1:length(x$tip.label)
    node_idx = 1:x$Nnode + length(x$tip.label)
    
    # compute the branching times
    branching_times = sort(unique(heights[,1]), decreasing=FALSE)
    
    # compute the tip ages
    tip_ages = sort(unique(heights[x$edge[,2] %in% tip_idx,2]), decreasing=FALSE)
    
    return(data.frame(na = I(list(branching_times)), ta = I(list(tip_ages))))
    
  }))
  
  # get the points to compute times at
  max_time = max(unlist(node_heights))
  times = seq(0, max_time, length.out=num_bins)
  
  # for each tree, compute the number of lineages at each time
  num_lineages = vector("list", length(trees))
  if(verbose) bar = txtProgressBar(style=3, width=40)
  for(i in 1:num_trees) {
    
    num_extinct = length(node_heights$ta[[i]]) - 1
    num_extant  = length(trees[[i]]$tip.label) - num_extinct
    
    node_heights$na[[i]]
    
    total_intervals = findInterval(times, node_heights$na[[i]]) + 1
    total_num_per_intervals = ((num_extinct + num_extant + 1):1)[total_intervals]
    
    extinct_intervals = findInterval(times, node_heights$ta[[i]])
    extinct_num_per_intervals = (num_extinct:0)[extinct_intervals]
    num_lineages[[i]] = total_num_per_intervals - extinct_num_per_intervals - 1
    
    if(verbose) setTxtProgressBar(bar, i / num_trees)
    
  }
  num_lineages = do.call(rbind, num_lineages)
  
  # compute the mean and confidence interval
  mean      = colMeans(num_lineages, na.rm = TRUE)
  median    = apply(num_lineages, 2, median, na.rm = TRUE)
  alpha     = (1 - CI) / 2
  probs     = c(alpha, 1 - alpha)
  quantiles = apply(num_lineages, 2, quantile, prob = probs, na.rm = TRUE)
  
  # package results
  res <- data.frame(time    = times,
                    mean    = mean,
                    median  = median,
                    lowerCI = quantiles[1,],
                    upperCI = quantiles[2,])
  
  return(res)
  
}

plotMDS <- function(dist, 
                    col,
                    ...) {
  
  # get the colors if not provided
  if ( missing(col) ) {
    col <- RevGadgets::colFun( length(unique(dist$name)) )
  } else {
    if ( length(col) != length(unique(dist$name)) ) {
      stop("Number of colors must be equal to the number of named groups.")
    }
  }
  
  p <- ggplot(dist, aes(x = x, y = y, color = name)) +
    geom_point() +
    theme_bw() +
    scale_color_manual(values = col)
  
  return(p)
  
}

plotLTT <- function(LTTs,
                    type   = "mean",
                    xlab   = "Age (Ma)",
                    plotCI = TRUE,
                    col,
                    ...) {
  
  # get the colors if not provided
  if ( missing(col) ) {
    col <- RevGadgets::colFun( length(unique(LTTs$name)) )
  } else {
    if ( length(col) != length(unique(LTTs$name)) ) {
      stop("Number of colors must be equal to the number of LTT curves.")
    }
  }
  
  # plot the lines
  if (type == "mean") {
    p <- ggplot(LTTs, aes(x = time, y = mean, color = name))
  } else if (type == "median") {
    p <- ggplot(LTTs, aes(x = time, y = median, color = name))
  } else {
    stop("Valid options for type are mean or median.")
  }
  
  if ( plotCI == TRUE ) {
    
    # make the data frame for polygons
    lowerCI <- LTTs[,c("time","lowerCI","name")]
    upperCI <- LTTs[,c("time","upperCI","name")]
    upperCI <- upperCI[nrow(upperCI):1,]
    colnames(lowerCI) <- colnames(upperCI) <- c("time","CI","name")
    CIs <- rbind(lowerCI, upperCI)
    
    # add the CIs
    p <- p + geom_polygon(data = CIs, aes(x = time, y = CI, fill = name), color = NA, alpha = 0.2) +
      scale_fill_manual(values = col)
      
  }
  
  # now for style
  p <- p + geom_line() +
    scale_x_reverse() +
    coord_trans(y = "log") +
    xlab(xlab) +
    ylab("Number of Lineages") +
    theme_bw() +
    scale_color_manual(values = col)
    
  
  return(p)  
  
}












make_tree_bifurcating = function(tree) {
  
  # check if there are sampled ancestors
  if ( is.binary(tree) == TRUE ) {
    return(tree)
  }
  
  # find the sampled ancestors
  sampled_ancestors = tree$node.label[tree$node.label != ""]
  num_sampled_ancestors = length(sampled_ancestors)
  
  # add any sampled ancestors as zero-length branches
  tmp_tree = tree
  for(i in 1:num_sampled_ancestors) {
    
    # get this sampled ancestor
    this_sampled_ancestor = sampled_ancestors[i]
    
    # find the node to attach it to
    attachment_point = which(tmp_tree$node.label == this_sampled_ancestor) + length(tmp_tree$tip.label)
    # attachment_point = tmp_tree$Nnode + which(tmp_tree$node.label == this_sampled_ancestor) - 1
    
    # attach the tip
    tmp_tree = bind.tip(tmp_tree, this_sampled_ancestor, edge.length=0.0, where=attachment_point)
    
  }
  
  #  return the tree
  return(collapse.singles(tmp_tree))
  
}

