library(RevGadgets)

dataset <- 1
my_tree <- read.nexus("data/trees.nex")[[dataset]]
my_output_file <- "output/relaxed_OU.log"

tree_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                            output_file    = my_output_file,
                                            parameter_name = "branch_thetas")

ggsave("relaxed_OU.pdf", width=15, height=15, units="cm")
