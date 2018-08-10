################################################################################
#
# Plot ancestral placental types inferred using two CTMC models of character evolution.
#
#
# authors: Sebastian Hoehna, Will Freyman
#
################################################################################

# if you do not have RevGadgets installed, then follow these instructions
#install.packages("devtools")
#library(devtools)
#install_github("GuangchuangYu/ggtree")
#install_github("revbayes/RevGadgets")

library(RevGadgets)
library(ggplot2)

tree_file = "output/ase_mk.tree"
g <- plot_ancestral_states(tree_file, summary_statistic="MAP",
                      tip_label_size=1,
                      xlim_visible=NULL,
                      node_label_size=0,
                      show_posterior_legend=TRUE,
                      node_size_range=c(1, 3),
                      alpha=0.75)

ggsave("Mammals_ASE_MK.pdf", g, width = 11, height = 9)

tree_file = "output/ase_freeK.tree"
g <- plot_ancestral_states(tree_file, summary_statistic="MAP",
                      tip_label_size=1,
                      xlim_visible=NULL,
                      node_label_size=0,
                      show_posterior_legend=TRUE,
                      node_size_range=c(1, 3),
                      alpha=0.75)

ggsave("Mammals_ASE_FreeK.pdf", g, width = 11, height = 9)

tree_file = "output/ase_freeK_RJ.tree"
g <- plot_ancestral_states(tree_file, summary_statistic="MAP",
                      tip_label_size=1,
                      xlim_visible=NULL,
                      node_label_size=0,
                      show_posterior_legend=TRUE,
                      node_size_range=c(1, 3),
                      alpha=0.75)

ggsave("Mammals_ASE_FreeK_RJ.pdf", g, width = 11, height = 9)
