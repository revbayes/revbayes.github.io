library(RevGadgets)

# specify a tree file
treefile <- "output_MCMC/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC_run_01/MCC_tree.tre"

# read the tree
tree <- readTrees(treefile)

# plot the tree
p <- plotFBDTree(tree = tree, timeline = TRUE, tip_labels_italics = FALSE,
            tip_labels_remove_underscore = TRUE,
            geo_units = "periods",
            node_age_bars = TRUE, age_bars_colored_by = "posterior",
            label_sampled_ancs = TRUE,
            age_bars_color = rev(colFun(2))) +
  ggplot2::theme(legend.position=c(0.75, 0.4))

pdf("figures/tree.pdf", width = 10, height = 8)
print(p)
dev.off()
