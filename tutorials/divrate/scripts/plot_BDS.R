library(RevGadgets)

my_tree_file = "data/primates_tree.nex"
my_branch_rates_file = "output/primates_BDS_rates.log"
tree_plot = plot_branch_rates_tree( tree_file=my_tree_file,
                                    branch_rates_file=my_branch_rates_file)

ggsave("BDS.pdf", width=15, height=15, units="cm")
