library(RevGadgets)

my_tree <- read.nexus("data/haemulidae.nex")
my_output_file <- "output/relaxed_univariate_BM.log"

tree_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                            output_file    = my_output_file,
                                            parameter_name = "branch_rates")

ggsave("relaxed_uvBM.pdf", width=15, height=15, units="cm")
