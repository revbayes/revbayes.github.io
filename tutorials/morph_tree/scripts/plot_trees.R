library(RevGadgets)
library(ggtree)
library(ggplot2)

file <- "output/mk.map.tre"
tree <- readTrees(paths = file)

# reroot the tree with Galeopterus variegatus
# you can also specify multiple tips to reroot using a clade
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Zaragocyon_daamsi")

# create the plot of the rooted tree
plot_mk <- plotTree(tree = tree_rooted,
                   # label nodes the with posterior probabilities
                   node_labels = "posterior",
                   # offset the node labels from the nodes
                   node_labels_offset = 0.005,
                   # make tree lines more narrow
                   line_width = 0.5,
                   # remove tip labels
                   tip_labels_size = 0)

# add scale bar to the tree and plot with ggtree
plot_mk <- plot_mk + geom_treescale(x = -0.35, y = -1) +
           geom_tiplab(align=TRUE, linetype='dashed', linesize=.3)




#


file <- "output/mkv.map.tre"
tree <- readTrees(paths = file)

# reroot the tree with Galeopterus variegatus
# you can also specify multiple tips to reroot using a clade
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Zaragocyon_daamsi")

# create the plot of the rooted tree
plot_mkv <- plotTree(tree = tree_rooted,
                     # label nodes the with posterior probabilities
                     node_labels = "posterior",
                     # offset the node labels from the nodes
                     node_labels_offset = 0.005,
                     # make tree lines more narrow
                     line_width = 0.5,
                     # remove tip labels
                     tip_labels_size = 0)

# add scale bar to the tree and plot with ggtree
plot_mkv <- plot_mkv + geom_treescale(x = -0.35, y = -1) +
            geom_tiplab(align=TRUE, linetype='dashed', linesize=.3)





file <- "output/mkv_discretized.map.tre"
tree <- readTrees(paths = file)

# reroot the tree with Galeopterus variegatus
# you can also specify multiple tips to reroot using a clade
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Zaragocyon_daamsi")

# create the plot of the rooted tree
plot_mkv_discretized <- plotTree(tree = tree_rooted,
                                 # label nodes the with posterior probabilities
                                 node_labels = "posterior",
                                 # offset the node labels from the nodes
                                 node_labels_offset = 0.005,
                                 # make tree lines more narrow
                                 line_width = 0.5,
                                 # remove tip labels
                                 tip_labels_size = 0)

# add scale bar to the tree and plot with ggtree
plot_mkv_discretized <- plot_mkv_discretized + geom_treescale(x = -0.35, y = -1) +
                        geom_tiplab(align=TRUE, linetype='dashed', linesize=.3)

#facet_grid(cols = vars(cyl))

plot <- plot_mk + plot_mkv + plot_mkv_discretized

ggsave( "mk_trees.png", plot, width=16.0, height=4.0 )
