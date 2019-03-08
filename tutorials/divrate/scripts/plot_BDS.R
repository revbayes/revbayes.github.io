library(ggplot2)
library(ggtree)
library(colorRamps)

in_file = "output/MAP.tree"

tree = read.beast(in_file)
p = ggtree(tree, aes(color=true_rates))  +
    scale_color_gradientn(colours = blue2green(10), limits=c(0,3.5)) +
    theme(legend.position=c(0.05, 0.7), legend.text.align=0, legend.justification=c(0,0)) 

ggsave("net_div.pdf", width=15, height=15, units="cm")
