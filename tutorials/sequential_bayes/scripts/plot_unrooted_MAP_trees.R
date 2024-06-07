################################################################################
#
# R-script: Plotting the MAP trees from the unrooted analyses
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(ggtree)
library(RevGadgets)

LOCUS        = "COI"


tree  <- readTrees(paths = paste0("output/photinus_",LOCUS,"_MAP.tre"))
plot <- plotTree(tree = tree ,
                 timeline = F,
                 node_labels = "posterior",
                 node_labels_offset = 0.005,
                 tip_labels_italics = T,
                 tip_labels_remove_underscore = T,
                 node_pp = !T)

ggsave(plot, file=paste0("unrooted_",LOCUS,".pdf"))
