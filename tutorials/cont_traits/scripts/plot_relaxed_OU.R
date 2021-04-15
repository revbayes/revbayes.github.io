library(RevGadgets)

# read the annotated tree
tree <- readTrees("output/relaxed_OU_MAP.tre")

# plot the objects
pdf("relaxed_OU.pdf")
plotTree(tree, color_branch_by="branch_thetas")
dev.off()
