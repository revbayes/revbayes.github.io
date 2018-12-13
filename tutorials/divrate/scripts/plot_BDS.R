library(ggplot2)
library(ggtree)

in_file = "output_prior/45_MAP.tree"

tree = read.beast(in_file)
p = ggtree(tree, aes(color=true_rates))  +
    scale_color_continuous("true diversification rates", low="blue", high="orange", limits=c(0,4.5)) +
    theme(legend.position=c(0.05, 0.7), legend.text.align=0, legend.justification=c(0,0)) 

ggsave("../figures/sim_true_net_div.pdf", width=15, height=15, units="cm")

p = ggtree(tree, aes(color=est_rates))  +
    scale_color_continuous("estimated diversification rates", low="blue", high="orange", limits=c(0,4.5)) +
    theme(legend.position=c(0.05, 0.7), legend.text.align=0, legend.justification=c(0,0)) 

ggsave("../figures/sim_est_net_div.pdf", width=15, height=15, units="cm")

p = ggtree(tree, aes(color=relative_error))  +
    scale_color_gradient2("relative error", low="red", mid="blue", high="orange") +
    theme(legend.position=c(0.05, 0.7), legend.text.align=0, legend.justification=c(0,0)) 

ggsave("../figures/sim_relative_error.pdf", width=15, height=15, units="cm")
