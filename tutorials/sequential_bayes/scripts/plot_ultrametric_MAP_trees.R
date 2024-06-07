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


tree  <- readTrees(paths = paste0("output/photinus_ultrametric_",LOCUS,"_MAP.tre"))
plot <- plotTree(tree = tree ,
                 timeline = TRUE,
                 geo_units = "epochs",
                 node_labels = NULL,
                 node_labels_offset = 0.005,
                 node_age_bars = T,
                 line_width = 0.5,
                 tip_labels_size = 2.5,
                 age_bars_colored_by = "posterior",
                 node_pp = !T)

ggsave(plot, file=paste0("ultrametric_",LOCUS,".pdf"))
