################################################################################
#
# Plot estimates of the relaxed rate Brownian motion model
#
# authors: Michael R. May and Sebastian Höhna
#
################################################################################


library(RevGadgets)
library(ggplot2)

# read the tree file
tree <- readTrees("output/relaxed_BM_MAP.tre")

# make the plot
pdf("relaxed_BM.pdf",height=8,width=6)
plotTree(tree,
         color_branch_by="branch_rates",
         tip_labels_size = 1) +
     # modify legend location using ggplot2
     theme(legend.position = c(0.12,0.85))
dev.off()
