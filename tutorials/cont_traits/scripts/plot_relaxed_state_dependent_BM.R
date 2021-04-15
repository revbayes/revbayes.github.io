library(RevGadgets)
library(gridExtra)

# read the annotated tree
tree <- readTrees("output/relaxed_state_dependent_BM_MAP.tre")

# create the ggplot objects
state_rates      <- plotTree(tree, color_branch_by="state_branch_rate", tip_labels_size = 2, legend_x=0.2)
background_rates <- plotTree(tree, color_branch_by="background_rates",  tip_labels_size = 2, legend_x=0.2)
overall_rates    <- plotTree(tree, color_branch_by="branch_rates",      tip_labels_size = 2, legend_x=0.2)

# plot the objects
pdf("relaxed_state_dependent_BM.pdf", height=7, width=21)
grid.arrange(state_rates, background_rates, overall_rates, nrow=1)
dev.off()
