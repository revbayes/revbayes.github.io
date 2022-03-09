library(RevGadgets)
library(gridExtra)
library(ggplot2)

# read the annotated tree
tree <- readTrees("output/state_dependent_BM_MAP_primates.tre")

# create the ggplot objects
overall_rates    <- plotTree(tree, color_branch_by="branch_rates",      tip_labels_size = 2, legend_x=0.2) + theme(legend.position = c(0.15,0.90))

# plot the objects
pdf("state_dependent_BM_primates.pdf", height=7, width=7)
grid.arrange(overall_rates, nrow=1)
dev.off()
