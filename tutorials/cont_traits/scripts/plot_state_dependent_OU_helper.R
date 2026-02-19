library(ape)
library(phytools)
library(tidyverse)

processStochMaps <- function(tree,
                             paths = NULL,
                             simmap = NULL,
                             states,
                             num_intervals = 1000,
                             verbose = TRUE,
                             ...) {
  
  # pull tree from list object if necessary
  if (inherits(tree,"list")) {
    if (length(tree) == 1){
      tree <- tree[[1]]
    } else {stop("tree should contain only one tree object")}
  }
  
  if (inherits(tree,"list")) {
    if (length(tree) == 1){
      tree <- tree[[1]]
    } else {stop("tree should contain only one tree object")}
  } 
  
  # compute the number of states
  nstates <- length(states)
  
  # create the index map
  map <- matchNodes(tree@phylo)
  
  # either paths or simmap must be provided
  if ( !is.null(paths) ) { # samples in files
    
    # read traces
    samples <- readTrace(paths, verbose = verbose, ...)
    
    # combine multiple samples together
    if ( length(samples) > 1 ) {
      samples <- combineTraces(samples)
      samples <- samples[[1]]
    } else {
      samples <- samples[[1]]
    }
    
    # compute the number of samples
    nsamples <- nrow(samples)
    
  } else if ( !is.null(simmap) ) { # samples in phytools format
    
    message("Reformatting simmap objects")
    
    # make the samples
    samples <- as.data.frame(do.call(rbind, lapply(simmap, function(simmap) {
      sapply(simmap$maps, function(edge) {
        edge <- rev(edge)
        return(paste0("{", paste0(paste0(names(edge),",", edge), collapse = ":"),"}"))
      })
    })))
    
    # add a root edge
    root_edge_samples <- sapply(simmap, function(map) {
      return(paste0("{", tail(names(map$maps[[1]]), n = 1), ",0}"))
    })
    samples <- cbind(samples, root_edge_samples)
    
    # get the nodes
    nodes <- c(tree@phylo$edge[,2], ape::Ntip(tree@phylo) + 1)
    colnames(samples) <- map$Rev[nodes]
    
    # compute the number of samples
    nsamples <- length(simmap)
    
  } else {
    stop("Please provide either a paths or simmap argument.")
  }
  
  message("Processing stochastic maps")
  
  # get the number of branches
  # including the root branch
  num_branches <- length(tree@phylo$edge.length) + 1
  root_index   <- ape::Ntip(tree@phylo) + 1
  
  # get the dt
  root_age <- max(ape::branching.times(tree@phylo))
  if (!is.null(tree@phylo$root.edge)) {
    root_age <- root_age + tree@phylo$root.edge
  } else {
    tree@phylo$root.edge <- 0
  }
  dt <- root_age / num_intervals
  
  # loop over branches
  dfs <- vector("list", num_branches)
  
  if (verbose) { pb <- txtProgressBar(min = 0, max = num_branches, initial = 0) }
  
  for(i in 1:num_branches) {
    
    # get the branch indexes
    R_index   <- map$R[i]
    Rev_index <- as.character(map[R_index,2])
    
    # get the time points
    if ( R_index == root_index ) {
      this_edge_length <- tree@phylo$root.edge
    } else {
      this_edge_length <- tree@phylo$edge.length[tree@phylo$edge[,2] == R_index]
    }
    these_pts <- seq(0, this_edge_length, by = dt)
    
    # get the samples
    branch_samples <- samples[,Rev_index]
    branch_samples <- gsub("{", "", branch_samples, fixed = TRUE)
    branch_samples <- gsub("}", "", branch_samples, fixed = TRUE)
    
    # split the per event
    branch_samples <- strsplit(branch_samples, ":")
    
    # get the times per state
    branch_samples <- lapply(branch_samples, function(sample) {
      sample <- do.call(rbind, strsplit(sample, ","))
      sample_states <- sample[,1]
      sample_times  <- as.numeric(sample[,2])
      names(sample_times) <- sample_states
      # sample_times <- rev(sample_times) # turn this on for plotting the output from (old) tensorphylo runs
      return(cumsum(sample_times))
    })
    
    # get the state per interval
    if ( this_edge_length == 0 ) {
      branch_states_per_interval <- t(t(match(names(unlist(branch_samples)), states)))
    } else {
      branch_states_per_interval <- do.call(rbind, lapply(branch_samples, function(sample) {
        match(names(sample)[findInterval(these_pts, sample) + 1], states)
      }))
    }
    
    # compute probability of each state per interval
    branch_prob_per_state <- apply(branch_states_per_interval, 2, tabulate, nbins = nstates) / nsamples
    rownames(branch_prob_per_state) <- states
    
    # now do the vertical segments
    vert_prob_per_state <- t(branch_prob_per_state[,ncol(branch_prob_per_state), drop = FALSE])
    
    # make the df
    this_df <- data.frame(index = Rev_index, bl = this_edge_length, x0 = these_pts, x1 = c(these_pts[-1], this_edge_length), vert = FALSE)
    this_df <- cbind(this_df, t(branch_prob_per_state))
    vert_df <- cbind(data.frame(index = Rev_index, bl = this_edge_length, x0 = this_edge_length, x1 = this_edge_length, vert = TRUE), vert_prob_per_state)
    this_df <- rbind(this_df, vert_df)        
    
    # store
    dfs[[i]] <- this_df
    
    if (verbose) { setTxtProgressBar(pb,i) }
    
  }
  if (verbose) { close(pb) }
  
  # combine the branches
  dfs <- do.call(rbind, dfs)
  
  # get node instead of index 
  # node is R's standard numbering for nodes
  # index is RevBayes specific 
  colnames(map) <- c("node", "index")
  map$index  <- as.character(map$index)
  dfs <- dplyr::full_join(map,dfs, by = "index")
  dfs$index <- NULL
  
  return(dfs)
  
}

plotStochMaps <- function(tree,
                          maps,
                          colors = "default",
                          color_by = "prob",
                          tree_layout = "rectangular",
                          line_width = 1,
                          tip_labels = TRUE,
                          tip_labels_italics = FALSE,
                          tip_labels_formatted = FALSE,
                          tip_labels_remove_underscore = TRUE,
                          tip_labels_color = "black",
                          tip_labels_size = 3,
                          tip_labels_offset = 0,
                          timeline = FALSE,
                          geo_units = list("epochs", "periods"),
                          geo = timeline,
                          time_bars = timeline,
                          label_sampled_ancs = FALSE,
                          ...) {
  
  # pull tree from list object if necessary
  if (inherits(tree,"list")) {
    if (length(tree) == 1){
      tree <- tree[[1]]
    } else {stop("tree should contain only one tree object")}
  }
  
  if (inherits(tree,"list")) {
    if (length(tree) == 1){
      tree <- tree[[1]]
    } else {stop("tree should contain only one tree object")}
  } 
  
  p <-  plotTreeFull(
    tree = list(list(tree)),
    tree_layout = tree_layout,
    line_width = line_width,
    
    tip_labels = tip_labels,
    tip_labels_italics = tip_labels_italics,
    tip_labels_formatted = tip_labels_formatted,
    tip_labels_remove_underscore = tip_labels_remove_underscore,
    tip_labels_color = tip_labels_color,
    tip_labels_size = tip_labels_size,
    tip_labels_offset = tip_labels_offset,
    
    timeline = timeline,
    geo_units = geo_units,
    geo = timeline,
    time_bars = timeline,
    
    label_sampled_ancs = label_sampled_ancs,
    
    node_age_bars = FALSE,
    age_bars_color = "blue",
    age_bars_colored_by = NULL,
    
    node_labels = NULL,
    node_labels_color = "black",
    node_labels_size = 3,
    node_labels_offset = 0,
    
    node_pp = FALSE,
    node_pp_shape = 16,
    node_pp_color = "black",
    node_pp_size = "variable",
    
    branch_color = "black",
    color_branch_by = NULL,
    
    tip_age_bars = FALSE,
    lineend = "square",
    ...
  )
  
  if (colors[1] != "default") {
    # error checking
    if (is.null(names(colors))) 
    {stop("colors must be a NAMED vector of colors where names correspond to the character states")}
    states <- names(colors)
  } else {
    states <- colnames(maps)[-c(1:5)]
    colors <- colFun(length(states))
    names(colors) <- states
  }
  
  dat <- dplyr::left_join(maps, p$data, by = "node")
  
  #set up colors 
  if (color_by == "MAP") {
    max <- apply(dat[, states], MARGIN = 1, which.max)
    seg_col <- colors[unlist(max)]
    dat$seg_col <- seg_col
    names(seg_col) <- seg_col
  } else if (color_by == "prob") {
    rgbcols <- col2rgb(colors)
    rgb_values_per_seg <- t(rgbcols %*% t(dat[,states]))
    seg_col <- tolower(grDevices::rgb(red   = rgb_values_per_seg[ ,1],
                                      green = rgb_values_per_seg[ ,2],
                                      blue  = rgb_values_per_seg[ ,3],
                                      maxColorValue = 255))
    dat$seg_col <- seg_col
    names(seg_col) <- seg_col
  }
  
  # horizontal segments
  dat_horiz <- dat[dat$vert == FALSE,]
  
  seg_horiz <- data.frame(
    x    = dat_horiz$x - dat_horiz$x0,
    xend = dat_horiz$x - dat_horiz$x1,
    y    = dat_horiz$y,
    yend = dat_horiz$y,
    col  = dat_horiz$seg_col
  )
  
  #vertical segments
  dat_vert <- dat[dat$vert == TRUE,]
  
  m <- match(x = dat_vert$parent, dat_vert$node)
  dat_vert$y_parent <- dat_vert[m, "y"]
  dat_vert$x_parent <- dat_vert[m, "x"]
  
  seg_vert <- data.frame(
    x = dat_vert$x_parent,
    xend = dat_vert$x_parent,
    y = dat_vert$y,
    yend = dat_vert$y_parent,
    col = dat_vert$seg_col
  )
  
  # plot! 
  
  p + ggplot2::geom_segment(
    data = seg_horiz,
    ggplot2::aes(
      x = x,
      y = y,
      xend = xend,
      yend = yend,
      color = col
    ),
    lineend = "square",
    size = line_width,
  ) +
    ggplot2::geom_segment(
      data = seg_vert,
      ggplot2::aes(
        x = x,
        y = y,
        xend = xend,
        yend = yend,
        color = col
      ),
      lineend = "square",
      size = line_width, 
      
    ) +
    ggplot2::scale_color_manual(values = seg_col, 
                                breaks = colors,
                                name = "State",
                                labels = names(colors))
  
}

plotTreeFull <- function(tree,
                         
                         timeline,
                         geo,
                         geo_units,
                         time_bars,
                         
                         node_age_bars,
                         tip_age_bars,
                         age_bars_color,
                         age_bars_colored_by,
                         
                         node_labels,
                         node_labels_color,
                         node_labels_size,
                         node_labels_offset,
                         
                         tip_labels,
                         tip_labels_italics,
                         tip_labels_formatted,
                         tip_labels_remove_underscore,
                         tip_labels_color,
                         tip_labels_size,
                         tip_labels_offset,
                         
                         label_sampled_ancs,
                         
                         node_pp,
                         node_pp_shape,
                         node_pp_color,
                         node_pp_size,
                         
                         branch_color,
                         color_branch_by,
                         line_width,
                         
                         tree_layout,
                         ...) {
  # enforce argument matching
  if (!is.list(tree))
    stop("tree should be a list of lists of treedata objects")
  if (!methods::is(tree[[1]][[1]], "treedata"))
    stop("tree should be a list of lists of treedata objects")
  vars <- colnames(tree[[1]][[1]]@data)
  if (is.logical(timeline) == FALSE)
    stop("timeline should be TRUE or FALSE")
  if (is.logical(node_age_bars) == FALSE)
    stop("node_age_bars should be TRUE or FALSE")
  if (any(.isColor(age_bars_color) == FALSE))
    stop("age_bars_color should be valid color(s)")
  if (is.null(age_bars_colored_by) == FALSE &
      any(vars %in% age_bars_colored_by) == FALSE)
    stop("age_bars_colored_by should be a column in your tidytree object")
  if (is.null(node_labels) == FALSE &
      any(vars %in% node_labels) == FALSE)
    stop("node_labels should be NULL or a column in your tidytree object")
  if (is.null(node_labels_color) == FALSE &
      .isColor(node_labels_color) == FALSE)
    stop("node_labels_color should be NULL or a recognized color")
  if (is.logical(tip_labels) == FALSE)
    stop("tip_labels should be TRUE or FALSE")
  if (is.logical(tip_labels_italics) == FALSE)
    stop("tip_labels_italics should be TRUE or FALSE")
  if (is.logical(tip_labels_formatted) == FALSE)
    stop("tip_labels_formatted should be TRUE or FALSE")
  if (tip_labels_italics == TRUE & tip_labels_formatted == TRUE) 
    stop("tip_labels_italics and tip_labels_formatted may not both be TRUE")
  if (.isColor(tip_labels_color) == FALSE)
    stop("tip_labels_color should be a recognized color")
  if (!methods::is(node_pp,"logical"))
    stop("node_pp should be TRUE or FALSE")
  if (node_pp) {
    if (length(node_pp_color) > 2)
      stop("node_pp_color should be of length 1 or 2")
    if (.isColor(node_pp_color) == FALSE)
      stop("node_pp_color should be a recognized color")
    if (node_pp_shape %in% 0:25 == FALSE)
      stop("node_pp_shape should be a recognized shape
           (value between 0 and 25)")
    if (is.numeric(node_pp_size) == FALSE &
        node_pp_size != "variable")
      stop("node_pp_size should be numeric or 'variable'")
  }
  if (is.logical(tip_age_bars) == FALSE)
    stop("tip_age_bars should be TRUE or FALSE")
  if (length(branch_color) == 1 &
      !.isColor(branch_color))
    stop("branch_color should be a recognized color")
  if (length(branch_color) == 2) {
    if (.isColor(branch_color[1] == FALSE) &
        .isColor(branch_color[2]) == FALSE)
      stop("Neither values of branch_color are a recognized color")
    if (.isColor(branch_color[1] == FALSE) &
        .isColor(branch_color[2]))
      stop("branch_color[1] is not a recognized color")
    if (.isColor(branch_color[1]) &
        .isColor(branch_color[2]) == FALSE)
      stop("branch_color[2] is not a recognized color")
  } else if (length(branch_color) > 2)
    stop("only 2 colors may be specified in branch_color")
  if (is.null(color_branch_by) == FALSE &
      any(vars %in% color_branch_by) == FALSE)
    stop("color_branch_by should be NULL or a column in your tidytree object")
  if (is.numeric(line_width) == FALSE)
    stop ("line_width should be numeric")
  if (is.logical(label_sampled_ancs) == FALSE)
    stop("label_sampled_ancs should be TRUE or FALSE")
  if (is.list(geo_units)) {
    if (length(geo_units) != 2)
      stop(
        "geo_units should be 'periods', 'epochs', 'stages', 'eons', 
         'eras', or a list of two of those units, such as:
        list('epochs','periods')"
      )
    if (geo_units[[1]] %in% 
        c('periods', 'epochs', 'stages', 'eons', 'eras')  == FALSE)
      stop(
        "geo_units should be 'periods', 'epochs', 'stages', 'eons', 
         'eras', or a list of two of those units, such as:
        list('epochs','periods')"
      )
    if (geo_units[[2]] %in% 
        c('periods', 'epochs', 'stages', 'eons', 'eras')  == FALSE)
      stop(
        "geo_units should be 'periods', 'epochs', 'stages', 'eons', 
         'eras', or a list of two of those units, such as:
        list('epochs','periods')"
      )
  } else {
    if (geo_units %in% 
        c('periods', 'epochs', 'stages', 'eons', 'eras') == FALSE)
      stop(
        "geo_units should be 'periods', 'epochs', 'stages', 'eons', 
         'eras', or a list of two of those units, such as:
        list('epochs','periods')"
      )
  }
  if (is.numeric(tip_labels_offset) == FALSE)
    stop ("tip_labels_offset should be a number")
  if (is.numeric(node_labels_offset) == FALSE)
    stop ("node_labels_offset should be a number")
  tree_layout <-
    match.arg(
      tree_layout,
      choices = c(
        'rectangular',
        'slanted',
        'ellipse',
        'cladogram',
        'roundrect',
        'fan',
        'circular',
        'inward_circular',
        'radial',
        'equal_angle',
        'daylight',
        'ape'
      )
    )
  if (tree_layout != "rectangular") {
    if (timeline == TRUE) {
      stop("timeline is only compatible with
                                 tree_layout = 'rectangular'")
    }
  }
  # grab single tree from input
  phy <- tree[[1]][[1]]
  
  ### fix for trees with sampled ancestors ###
  phylo    <- phy@phylo
  node_map <- .matchNodesTreeData(phy, phylo)
  if ("sampled_ancestor" %in% colnames(phy@data)) {
    phy@data$node <-
      as.character(node_map[match(as.numeric(phy@data$index),
                                  node_map$Rev), ]$R)
  }
  
  ### set up tree layout ###
  
  if (tree_layout == "cladogram") {
    tree_layout <- "rectangular"
    BL <- "none"
  } else {
    BL <- "branch.length"
  }
  
  # initiate plot
  if (is.null(color_branch_by)) {
    pp <- ggtree::ggtree(
      phy,
      right = FALSE,
      size = line_width,
      color = branch_color,
      branch.length = BL,
      layout = tree_layout,
      ...
    )
  } else if (!is.null(color_branch_by)) {
    pp <- ggtree::ggtree(
      phy,
      right = FALSE,
      size = line_width,
      branch.length = BL,
      layout = tree_layout,
      ...
    )
  }
  
  #### parameter compatibility checks ###
  if (length(node_pp_color) == 2 &
      length(branch_color) == 2)
    stop(
      "You may only include variable colors for either node_pp_label or
      branch_color, not for both"
    )
  
  #check that if user wants node_age_bars, there are dated intervals in  file
  if (node_age_bars == TRUE) {
    if (!"age_0.95_HPD" %in% colnames(phy@data))
      stop(
        "You specified node_age_bars, but there is no age_0.95_HPD column
        in the treedata object."
      )
  }
  
  # get dimensions
  n_node <- treeio::Nnode(phy)
  tree_height <- max(phytools::nodeHeights(phy@phylo))
  ntips <- sum(pp$data$isTip)
  
  # reformat labels if necessary
  if (tip_labels_remove_underscore) {
    pp$data$label <- gsub("_", " ", pp$data$label)
  }
  
  # check that if user wants to label sampled ancs,
  # there are sampled ancs in the files
  if (label_sampled_ancs == TRUE &
      "sampled_ancestor" %in% colnames(pp$data)) {
    sampled_ancs <-
      pp$data[!pp$data$isTip & !is.na(pp$data$sampled_ancestor),]
    if (nrow(sampled_ancs) < 1) {
      label_sampled_acs <- FALSE
    }
  }
  
  # add timeline
  if (timeline == TRUE) {
    warning("Plotting with default axis label (Age (Ma))")
    if (node_age_bars == FALSE) {
      minmax <- phytools::nodeHeights(phy@phylo)
      max_age <- tree_height
    } else {
      pp$data$age_0.95_HPD <- lapply(pp$data$age_0.95_HPD, function(z) {
        if (any(is.null(z)) ||
            any(is.na(z))) {
          return(c(NA, NA))
        } else {
          return(as.numeric(z))
        }
      })
      minmax <- t(matrix(unlist(pp$data$age_0.95_HPD), nrow = 2))
      max_age <- max(minmax, na.rm = TRUE)
    }
    
    interval <- max_age / 5
    dx <- max_age %% interval
    
    # add geo
    tick_height <- ntips / 100
    if (geo == TRUE) {
      #determine whether to include quaternary
      if (tree_height > 50) {
        skipit <- c("Quaternary", "Holocene", "Late Pleistocene")
      } else {
        skipit <- c("Holocene", "Late Pleistocene")
      }
      # add deep timescale
      if (length(geo_units) == 1) {
        pp <- pp + deeptime::coord_geo(
          dat  = geo_units,
          pos  = lapply(seq_len(length(geo_units)), function(x)
            "bottom"),
          size = lapply(seq_len(length(geo_units)), function(x)
            tip_labels_size),
          xlim = c(-max(minmax, na.rm = TRUE), tree_height /
                     2),
          ylim = c(-tick_height * 5, ntips *
                     1.1),
          height = grid::unit(4, "line"),
          skip = skipit,
          abbrv = FALSE,
          rot = 90,
          center_end_labels = TRUE,
          bord = c("right", "top", "bottom"),
          neg  = TRUE
        )
      } else if (length(geo_units) == 2) {
        pp <- pp + deeptime::coord_geo(
          dat  = geo_units,
          pos  = lapply(seq_len(length(geo_units)), function(x)
            "bottom"),
          size = lapply(seq_len(length(geo_units)), function(x)
            tip_labels_size),
          xlim = c(-max(minmax, na.rm = TRUE), tree_height /
                     2),
          ylim = c(-tick_height * 5, ntips *
                     1.1),
          skip = skipit,
          center_end_labels = TRUE,
          bord = c("right", "top", "bottom"),
          neg  = TRUE
        )
      }
    }
    #add axis title
    pp <- pp + ggplot2::scale_x_continuous(
      name = "Age (Ma)",
      expand = c(0, 0),
      limits = c(-max_age, tree_height /
                   2),
      breaks = -rev(seq(0, max_age +
                          dx, interval)),
      labels = rev(seq(0, max_age +
                         dx, interval))
    )
    pp <- ggtree::revts(pp)
    
    # add ma ticks and labels
    xline <- pretty(c(0, max_age))[pretty(c(0, max_age)) < max_age]
    df <-
      data.frame(
        x = -xline,
        y = rep(-tick_height * 5, length(xline)),
        vx = -xline,
        vy = rep(-tick_height * 5 + tick_height, length(xline))
      )
    
    pp <-
      pp + ggplot2::geom_segment(ggplot2::aes(
        x = 0,
        y = -tick_height * 5,
        xend = -max_age,
        yend = -tick_height * 5
      )) +
      ggplot2::geom_segment(data = df, ggplot2::aes(
        x = x,
        y = y,
        xend = vx,
        yend = vy
      )) +
      ggplot2::annotate(
        "text",
        x = -rev(xline),
        y = -tick_height * 5 + tick_height * 2,
        label = rev(xline),
        size = tip_labels_size
      )
    
    # add vertical gray bars
    if (time_bars) {
      if (geo) {
        if ("epochs" %in% geo_units) {
          x_pos <- -rev(c(0, deeptime::getScaleData("epochs")$max_age))
        } else {
          x_pos <-  -rev(c(0, deeptime::getScaleData("periods")$max_age))
        }
      } else if (!geo) {
        x_pos <- -rev(xline)
      }
      for (k in 2:(length(x_pos))) {
        box_col <- "gray92"
        if (k %% 2 == 1)
          box_col <- "white"
        box <-
          ggplot2::geom_rect(
            xmin = x_pos[k - 1],
            xmax = x_pos[k],
            ymin = -tick_height * 5,
            ymax = ntips,
            fill = box_col
          )
        pp <- gginnards::append_layers(pp, box, position = "bottom")
      }
    }
    if (tip_labels) {
      # recenter legend
      tot <- max_age + tree_height / 2
      pp <-
        pp +
        ggplot2::theme(axis.title.x =
                         ggplot2::element_text(hjust = max_age / (2 * tot)))
    }
  }
  
  # processing for node_age_bars and tip_age_bars
  if (node_age_bars == TRUE) {
    # Encountered problems with using geom_range to plot age HPDs in ggtree. It
    # appears that geom_range incorrectly rotates the HPD relative to the height
    # of the node unnecessarily. My guess for this would be because older
    # version of ggtree primarily supported length measurements, and not
    # height measurements so the new capability to handle height might contain
    # a "reflection" bug.
    # For example, suppose a node has height 3 with HPD [2, 7]. You can think of
    # this offset as h + [2-h, 7-h]. ggtree seems to "rotate" this
    # causing the HPD to appear as [-1, 4]. Figtree displays this correctly.
    #
    # See this excellent trick by Tauana:
    # https://groups.google.com/forum/#!msg/bioc-ggtree/wuAlY9phL9Q/L7efezPgDAAJ
    # Adapted this code to also plot fossil tip uncertainty in red
    pp$data$age_0.95_HPD <-
      lapply(pp$data$age_0.95_HPD, function(z) {
        if (any(is.null(z)) ||
            any(is.na(z))) {
          return(c(NA, NA))
        } else {
          return(as.numeric(z))
        }
      })
    
    minmax <- t(matrix(unlist(pp$data$age_0.95_HPD), nrow = 2))
    bar_df <-
      data.frame(
        node_id = as.integer(pp$data$node),
        isTip = pp$data$isTip,
        as.data.frame(minmax)
      )
    names(bar_df) <- c("node_id", "isTip", "min", "max")
    if (tip_age_bars == TRUE) {
      tip_df <- dplyr::filter(bar_df, isTip == TRUE & !is.na(min))
      tip_df <-
        dplyr::left_join(tip_df, pp$data, by = c("node_id" = "node"))
      tip_df <- dplyr::select(tip_df, node_id, min, max, y)
    }
    if (is.null(age_bars_colored_by) == TRUE) {
      # plot age densities
      bar_df <-
        dplyr::left_join(bar_df, pp$data, by = c("node_id" = "node"))
      bar_df <- dplyr::select(bar_df,  node_id, min, max, y)
      pp <-
        pp + ggplot2::geom_segment(
          ggplot2::aes(
            x = -min,
            y = y,
            xend = -max,
            yend = y
          ),
          data = bar_df,
          color = age_bars_color,
          size = 1.5,
          alpha = 0.8
        )
    } else if (is.null(age_bars_colored_by) == FALSE) {
      if (length(age_bars_color) == 1) {
        age_bars_color <- colFun(2)[2:1]
      }
      
      if ("sampled_ancestor" %in% colnames(pp$data) == TRUE) {
        sampled_tip_probs <-
          1 - as.numeric(pp$data$sampled_ancestor[pp$data$isTip == TRUE])
        sampled_tip_probs[is.na(sampled_tip_probs)] <- 0
      } else {
        sampled_tip_probs <- rep(1, sum(pp$data$isTip))
      }
      
      pp$data$olena <-
        c(sampled_tip_probs,
          as.numeric(.convertAndRound(L =
                                        unlist(pp$data[pp$data$isTip == FALSE,
                                                       age_bars_colored_by]))))
      
      bar_df <-
        dplyr::left_join(bar_df, pp$data, by = c("node_id" = "node"))
      bar_df <-
        dplyr::select(bar_df,  node_id, min, max, y, olena, isTip = isTip.x)
      if (tip_age_bars == FALSE) {
        bar_df <- dplyr::filter(bar_df, isTip == FALSE)
      }
      pp <-
        pp + ggplot2::geom_segment(
          ggplot2::aes(
            x = -min,
            y = y,
            xend = -max,
            yend = y,
            color = olena
          ),
          data = bar_df,
          size = 1.5,
          alpha = 0.8
        ) +
        ggplot2::scale_color_gradient(
          low = age_bars_color[1],
          high = age_bars_color[2],
          name = .titleFormat(age_bars_colored_by),
          breaks = pretty(pp$data$olena)
        )
    }
  }
  
  # label sampled ancestors
  if (label_sampled_ancs == TRUE &
      "sampled_ancestor" %in% colnames(pp$data)) {
    sampled_ancs <-
      pp$data[!pp$data$isTip & !is.na(pp$data$sampled_ancestor),]
    space_labels <- ntips / 30
    if (tip_labels_italics == TRUE) {
      pp <-
        pp + ggplot2::annotate(
          "text",
          x = sampled_ancs$x,
          y = sampled_ancs$y,
          label = seq_len(nrow(sampled_ancs)),
          vjust = -.5,
          size = tip_labels_size,
          color = tip_labels_color
        ) +
        ggplot2::annotate(
          "text",
          x = rep(-max(
            unlist(pp$data$age_0.95_HPD), na.rm = TRUE
          ),
          times = nrow(sampled_ancs)),
          y = seq(
            from = ntips - space_labels,
            by = -space_labels,
            length.out = nrow(sampled_ancs)
          ),
          label = paste0(seq_len(nrow(sampled_ancs)),
                         ": italic(`",
                         sampled_ancs$label,
                         "`)"),
          size = tip_labels_size,
          color = tip_labels_color,
          hjust = 0,
          parse = TRUE
        )
    } else if (tip_labels_italics == TRUE) {
      pp <-
        pp + ggplot2::annotate(
          "text",
          x = sampled_ancs$x,
          y = sampled_ancs$y,
          label = seq_len(nrow(sampled_ancs)),
          vjust = -.5,
          size = tip_labels_size,
          color = tip_labels_color
        ) +
        ggplot2::annotate(
          "text",
          x = rep(-max(
            unlist(pp$data$age_0.95_HPD), na.rm = TRUE
          ),
          times = nrow(sampled_ancs)),
          y = seq(
            from = ntips - space_labels,
            by = -space_labels,
            length.out = nrow(sampled_ancs)
          ),
          label = paste0(seq_len(nrow(sampled_ancs)),
                         ": ",
                         sampled_ancs$label),
          size = tip_labels_size,
          color = tip_labels_color,
          hjust = 0,
          parse = TRUE
        )
    } else {
      pp <-
        pp + ggplot2::annotate(
          "text",
          x = sampled_ancs$x,
          y = sampled_ancs$y,
          label = seq_len(nrow(sampled_ancs)),
          vjust = -.5,
          size = tip_labels_size,
          color = tip_labels_color
        ) +
        ggplot2::annotate(
          "text",
          x = rep(-max(
            unlist(pp$data$age_0.95_HPD), na.rm = TRUE
          ),
          times = nrow(sampled_ancs)),
          y = seq(
            from = ntips - space_labels,
            by = -space_labels,
            length.out = nrow(sampled_ancs)
          ),
          label = paste0(seq_len(nrow(sampled_ancs)),
                         ": ",
                         sampled_ancs$label),
          size = tip_labels_size,
          color = tip_labels_color,
          hjust = 0
        )
    }
    
    t_height <- ntips / 200
    df <- data.frame(
      x = sampled_ancs$x,
      vx = sampled_ancs$x,
      y = sampled_ancs$y + t_height,
      vy = sampled_ancs$y - t_height
    )
    pp <-
      pp + ggplot2::geom_segment(data = df, ggplot2::aes(
        x = x,
        y = y,
        xend = vx,
        yend = vy
      ))
    
  }
  
  # add node labels (text)
  if (is.null(node_labels) == FALSE) {
    # catch some funkiness from importing an unrooted tree
    if (node_labels == "posterior") {
      pp$data[grep("]:", unlist(pp$data[, node_labels])), node_labels] <-
        NA
    }
    pp$data$kula <-
      c(rep(NA, times = ntips),
        .convertAndRound(L =
                           unlist(pp$data[pp$data$isTip == FALSE,
                                          node_labels])))
    
    # change any NAs that got converted to characters back to NA
    pp$data$kula[pp$data$kula == "NA"] <- NA
    pp <- pp + ggtree::geom_text(
      ggplot2::aes(label = kula),
      color = node_labels_color,
      nudge_x = node_labels_offset,
      hjust = 0,
      size = node_labels_size
    )
  }
  
  # add tip labels (text)
  if (tip_labels == TRUE) {
    if (tip_age_bars == TRUE) {
      pp$data$extant <- !pp$data$node %in% tip_df$node_id
    } else {
      pp$data$extant <- TRUE
    }
    if (tip_labels_italics == TRUE) {
      pp <- pp + ggtree::geom_tiplab(
        ggplot2::aes(
          subset = extant & isTip,
          label = paste0('italic(`', label, '`)')
        ),
        size = tip_labels_size,
        offset = tip_labels_offset,
        color = tip_labels_color,
        parse = TRUE
      )
      if (tip_age_bars == TRUE) {
        new_tip_df <-
          dplyr::left_join(tip_df,
                           pp$data[, c("label", "node")],
                           by = c("node_id" = "node"))
        pp <-
          pp + ggplot2::annotate(
            "text",
            x = -new_tip_df$min + tip_labels_offset,
            y = new_tip_df$y,
            label = paste0('italic(`', new_tip_df$label, '`)'),
            hjust = 0,
            color = tip_labels_color,
            size = tip_labels_size,
            parse = TRUE
          )
      }
    } else if (tip_labels_formatted == TRUE ) {
      pp <- pp + ggtree::geom_tiplab(
        ggplot2::aes(subset = extant & isTip,
                     label = label),
        size = tip_labels_size,
        offset = tip_labels_offset,
        color = tip_labels_color,
        parse = TRUE
      )
      if (tip_age_bars == TRUE) {
        new_tip_df <-
          dplyr::left_join(tip_df,
                           pp$data[, c("label", "node")],
                           by = c("node_id" = "node"))
        pp <-
          pp + ggplot2::annotate(
            "text",
            x = -new_tip_df$min + tip_labels_offset,
            y = new_tip_df$y,
            label = new_tip_df$label,
            hjust = 0,
            color = tip_labels_color,
            size = tip_labels_size,
            parse = TRUE 
          )
      }
    } else {
      pp <- pp + ggtree::geom_tiplab(
        ggplot2::aes(subset = extant & isTip,
                     label = label),
        size = tip_labels_size,
        offset = tip_labels_offset,
        color = tip_labels_color
      )
      if (tip_age_bars == TRUE) {
        new_tip_df <-
          dplyr::left_join(tip_df,
                           pp$data[, c("label", "node")],
                           by = c("node_id" = "node"))
        pp <-
          pp + ggplot2::annotate(
            "text",
            x = -new_tip_df$min + tip_labels_offset,
            y = new_tip_df$y,
            label = new_tip_df$label,
            hjust = 0,
            color = tip_labels_color,
            size = tip_labels_size
          )
      }
    }
  }
  
  # add node PP (symbols)
  if (node_pp == TRUE) {
    # reformat posterior
    pp$data$posterior <- as.numeric(pp$data$posterior)
    
    if (length(node_pp_color) == 1 & node_pp_size == "variable") {
      pp <- pp + ggtree::geom_nodepoint(color = node_pp_color,
                                        ggplot2::aes(size = posterior),
                                        shape = node_pp_shape) +
        ggplot2::scale_size_continuous(name = "Posterior")
    } else if (length(node_pp_color) == 2 &
               node_pp_size != "variable") {
      pp <- pp + ggtree::geom_nodepoint(size = node_pp_size,
                                        ggplot2::aes(color = posterior),
                                        shape = node_pp_shape) +
        ggplot2::scale_color_gradient(
          name = "Posterior",
          low = node_pp_color[1],
          high = node_pp_color[2],
          breaks = pretty(pp$data$posterior)
        )
    }
  }
  
  # add branch coloration by variable
  if (is.null(color_branch_by) == FALSE) {
    #set default colors if none provided
    if (length(branch_color) != 2) {
      branch_color <- c("#005ac8", "#fa7850")
    }
    col_num <- which(colnames(pp$data) == color_branch_by)
    pp$data[, col_num] <-
      as.numeric(as.data.frame(pp$data)[, col_num])
    name <- .titleFormat(color_branch_by)
    pp <- pp + 
      ggplot2::aes(color = as.data.frame(pp$data)[, col_num]) +
      ggplot2::scale_color_gradient(
        low = branch_color[1],
        high = branch_color[2],
        breaks = pretty(as.data.frame(pp$data)[, col_num]),
        name = name
      )
  }
  
  # readjust axis for non-timeline plots
  if (timeline == FALSE & BL != "none") {
    if (node_age_bars == FALSE) {
      xlim_min <- -tree_height
    } else {
      xlim_min <- -max(t(matrix(
        unlist(pp$data$age_0.95_HPD),
        nrow = 2
      )), na.rm = TRUE)
    }
    
    if (tip_labels == TRUE) {
      xlim_max <- tree_height / 2
    } else {
      xlim_max <- 0
    }
    
    pp <- pp + ggtree::xlim(xlim_min, xlim_max)
    pp <- ggtree::revts(pp)
    
  }
  
  # readjust axis for cladograms
  if (timeline == FALSE & BL == "none") {
    xlim_min <- range(pp$data$x)[1]
    
    if (tip_labels == TRUE) {
      xlim_max <- range(pp$data$x)[2] * 1.5
    } else {
      xlim_max <- range(pp$data$x)[2]
    }
    
    pp <- pp + ggtree::xlim(xlim_min, xlim_max)
    
  }
  
  return(pp)
}

.isColor <- function(var) {
  if (is.null(var)) {
    return(FALSE)
  } else {
    t <- try(col2rgb(var), silent = TRUE)
    if (length(t) == 1 && methods::is(t, "try-error")) {
      return(FALSE)
    }
    else
      return(TRUE)
  }
}

.matchNodesTreeData <- function(treedata, phy) {
  # get some useful info
  num_sampled_anc <- sum(phy$node.label != "")
  num_tips        <- length(phy$tip.label)
  num_nodes       <- phy$Nnode
  sampled_ancs    <- which(tabulate(phy$edge[, 1]) == 1)
  tip_indexes     <- 1:(num_tips + num_sampled_anc)
  node_indexes    <- (num_tips + num_sampled_anc) + num_nodes:1
  
  node_map     <-
    data.frame(R = 1:(num_tips + num_nodes),
               Rev = NA,
               visits = 0)
  current_node <- num_tips + 1
  k <- 1
  t <- 1
  
  while (TRUE) {
    # compute the number of descendants of this tip
    current_num_descendants <- sum(phy$edge[, 1] == current_node)
    
    if (current_node <= num_tips) {
      treedata_node <-
        which(as.character(treedata@data$node) == current_node)
      node_map$Rev[node_map$R == current_node] <-
        as.numeric(treedata@data[treedata_node, ]$index)
      current_node <- phy$edge[phy$edge[, 2] == current_node, 1]
      t <- t + 1
      
    } else if (current_node %in% sampled_ancs) {
      if (node_map$visits[node_map$R == current_node] == 0) {
        node_map$Rev[node_map$R == current_node] <- node_indexes[k]
        k <- k + 1
      }
      node_map$visits[node_map$R == current_node] <-
        node_map$visits[node_map$R == current_node] + 1
      
      if (node_map$visits[node_map$R == current_node] == 1) {
        # go left
        current_node <- phy$edge[phy$edge[, 1] == current_node, 2][1]
      } else if (node_map$visits[node_map$R == current_node] == 2) {
        # go down
        if (current_node == num_tips + 1) {
          break
        } else {
          current_node <- phy$edge[phy$edge[, 2] == current_node, 1]
        }
      }
      
    } else {
      if (node_map$visits[node_map$R == current_node] == 0) {
        node_map$Rev[node_map$R == current_node] <- node_indexes[k]
        k <- k + 1
      }
      node_map$visits[node_map$R == current_node] <-
        node_map$visits[node_map$R == current_node] + 1
      
      num_visits <- node_map$visits[node_map$R == current_node]
      
      if (num_visits <= current_num_descendants) {
        # go to next descendant
        current_node <-
          phy$edge[phy$edge[, 1] == current_node, 2][current_num_descendants -
                                                       num_visits + 1]
      } else if (num_visits > current_num_descendants) {
        # go down
        if (current_node == num_tips + 1) {
          break
        } else {
          current_node <- phy$edge[phy$edge[, 2] == current_node, 1]
        }
      }
      
    }
    
  }
  
  return(node_map[, 1:2])
  
}

get_legend2 <- function(plot, legend = NULL) {
  if (is.ggplot(plot)) {
    gt <- ggplotGrob(plot)
  } else {
    if (is.grob(plot)) {
      gt <- plot
    } else {
      stop("Plot object is neither a ggplot nor a grob.")
    }
  }
  pattern <- "guide-box"
  if (!is.null(legend)) {
    pattern <- paste0(pattern, "-", legend)
  }
  indices <- grep(pattern, gt$layout$name)
  not_empty <- !vapply(
    gt$grobs[indices], 
    inherits, what = "zeroGrob", 
    FUN.VALUE = logical(1)
  )
  indices <- indices[not_empty]
  if (length(indices) > 0) {
    return(gt$grobs[[indices[1]]])
  }
  return(NULL)
}

simmap_to_ancStates <- function(input_path, output_path, tree){
  index_to_rev <- RevGadgets::matchNodes(tree)
  
  char_hist <- read.table(input_path, header=TRUE)
  simmaps <- read.simmap(text=char_hist$char_hist, format="phylip")
  
  df_rev <- data.frame()
  
  for (row_num in 1:length(simmaps)){
    simmap <- simmaps[[row_num]]
    
    # Iteration column
    df_rev[row_num, 1] <- row_num-1
    
    for (i in 1:(length(simmap$maps))){
      ape_node <- which(index_to_rev[,2]==i)
      ape_edge <- which(simmap$edge[,2]==ape_node)
      map <- simmap$maps[[ape_edge]]
      df_rev[row_num, i+1] <- names(map[length(map)])
    }
    df_rev[row_num, length(simmap$maps)+2] <- names(map[1])
  }
  
  header <- paste0("end_", as.character(1:(length(simmap$maps)+1)))
  colnames(df_rev) <- c("Iteration", header)
  write_tsv(df_rev, output_path)
}