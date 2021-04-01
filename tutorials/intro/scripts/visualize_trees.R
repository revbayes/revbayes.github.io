# basic tree plot

file <- "sub_models/primates_cytb_GTR_MAP.tre"
tree <- readTrees(paths = file)

tree_rooted <- rerootPhylo(tree = tree, outgroup = "Galeopterus_variegatus")

plot <- <- plotTree(tree = tree_rooted, node_labels = "posterior", 
					node_labels_offset = 0.005, node_labels_size = 3, 
					line_width = 0.5, tip_labels_italics = T)

plot + ggtree::geom_treescale(x = -0.35, y = -1)

# FBD tree 

file <- "bears.mcc.tre"
tree <- readTrees(paths = file)
plot <- plotFBDTree(tree = tree, 
      				timeline = T, 
      				geo_units = "epochs",
      				tip_labels_italics = T,
      				tip_labels_remove_underscore = T,
      				tip_labels_size = 3, 
      				tip_age_bars = T,
      				node_age_bars = T, 
      				age_bars_colored_by = "posterior",
      				label_sampled_ancs = TRUE) + 
      		theme(legend.position=c(.05, .6))

# branch rates as branch colors

file <- "relaxed_OU_MAP.tre"
tree <- readTrees(paths = file)
plotTree(tree = tree, 
         tip_labels_italics = FALSE,
         color_branch_by = "branch_thetas", 
         line_width = 1.7) + 
 theme(legend.position=c(.1, .9))