library(RevGadgets)
library(gridExtra)
library(ggplot2)

# read the annotated tree
tree <- readTrees("output/state_dependent_BM_MAP_primates.tre")

# create the ggplot objects
state_rates      <- plotTree(tree, color_branch_by="state_branch_rate", tip_labels_size = 2, legend_x=0.2) + theme(legend.position = c(0.15,0.90))
background_rates <- plotTree(tree, color_branch_by="background_rates",  tip_labels_size = 2, legend_x=0.2) + theme(legend.position = c(0.15,0.90))
overall_rates    <- plotTree(tree, color_branch_by="branch_rates",      tip_labels_size = 2, legend_x=0.2) + theme(legend.position = c(0.15,0.90))

# plot the objects
pdf("relaxed_state_dependent_BM_primates.pdf", height=7, width=21)
grid.arrange(state_rates, background_rates, overall_rates, nrow=1)
dev.off()
