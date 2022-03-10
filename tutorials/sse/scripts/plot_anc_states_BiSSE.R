################################################################################
#
# Plotting the ancestral states under a BiSSE model
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

DATASET <- "activity_period"

# read in and process the ancestral states
bisse_file <- paste0("output/primates_BiSSE_",DATASET,"_anc_states_results.tree")
p_anc <- processAncStates(bisse_file)

# plot the ancestral states
plot <- plotAncStatesMAP(p_anc,
        tree_layout = "rect",
        tip_labels_size = 1) +
        # modify legend location using ggplot2
        theme(legend.position = c(0.1,0.8),
              legend.key.size = unit(0.3, 'cm'), #change legend key size
              legend.title = element_text(size=6), #change legend title font size
              legend.text = element_text(size=4))

ggsave(paste0("BiSSE_anc_states_",DATASET,".png"),plot, width=5, height=5)
