library(RevGadgets)

# read the tree file
tree <- readTrees("output/relaxed_multivariate_BM_MAP.tre")

# make the plot
pdf("relaxed_mvBM.pdf")
plotTree(tree, color_branch_by="branch_rates")
dev.off()
