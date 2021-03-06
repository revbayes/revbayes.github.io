library(RevGadgets)

my_tree <- read.nexus("data/haemulidae.nex")
my_output_file <- "output/relaxed_state_dependent_BM.log"

background_plot <- plot_relaxed_branch_rates_tree(tree        = my_tree,
                                                  output_file    = my_output_file,
                                                  parameter_name = "background_rates")

state_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                             output_file    = my_output_file,
                                             parameter_name = "state_branch_rate")

overall_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                               output_file    = my_output_file,
                                               parameter_name = "branch_rates")

pdf("relaxed_state_dependent_BM.pdf", height=5, width=12)
grid.arrange(state_plot, background_plot, overall_plot, nrow=1)
dev.off()
