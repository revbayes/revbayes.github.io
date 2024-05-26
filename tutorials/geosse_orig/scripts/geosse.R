library(RevGadgets)
library(ggplot2)

tree_file = "../output/ase.tre"
output_file = "../output/states.png"

states <- processAncStates(tree_file, state_labels=c("0"="Andean", "1"="Non-Andean", "2"="Both"))

plotAncStatesMAP(t=states,
                 tree_layout="circular",
                 node_size=1.5,
                 node_size_as=NULL) +
                 ggplot2::theme(legend.position="bottom",
                                legend.title=element_blank())

ggsave(output_file, width = 9, height = 9)