library(RevGadgets)
library(ggtree)
library(ggplot2)

setwd("your_directory")

file <- "data/primates_cytb_GTR_MAP.tre"
tree <- readTrees(paths = file)

# reroot the tree with Galeopterus variegatus 
# you can also specify multiple tips to reroot using a clade
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Galeopterus_variegatus")

# create the plot of the rooted tree
plot <- plotTree(tree = tree_rooted,
                 # label nodes the with posterior probabilities
                 node_labels = "posterior", 
                 # offset the node labels from the nodes
                 node_labels_offset = 0.005,
                 # make tree lines more narrow
                 line_width = 0.5,
                 # italicize tip labels 
                 tip_labels_italics = TRUE)

# add scale bar to the tree and plot with ggtree
plot + geom_treescale(x = -0.35, y = -1)

# FBD tree 

file <- "data/bears.mcc.tre"

# read in the tree 
tree <- readTrees(paths = file)

# plot the FBD tree
plotFBDTree(tree = tree, 
          timeline = T, 
          geo_units = "epochs",
          tip_labels_italics = T,
          tip_labels_remove_underscore = T,
          tip_labels_size = 3, 
          tip_age_bars = T,
          node_age_bars = T, 
          age_bars_colored_by = "posterior",
          label_sampled_ancs = TRUE) + 
    # use ggplot2 to move the legend and make 
    # the legend background transparent
    theme(legend.position=c(.05, .6),
          legend.background = element_rect(fill="transparent"))

# branch rates as branch colors

# read in the tree
file <- "data/relaxed_OU_MAP.tre"
tree <- readTrees(paths = file)

# plot the tree with rates
plotTree(tree = tree, 
         # italicize tip labels
         tip_labels_italics = FALSE,
         # specify variable to color branches
         color_branch_by = "branch_thetas", 
         # thicken the tree lines
         line_width = 1.7) + 
  # move the legend with ggplot2
  theme(legend.position=c(.1, .9))