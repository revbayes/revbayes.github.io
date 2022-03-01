################################################################################
#
# Plot ancestral state estimates inferred using the hidden rates models of character evolution.
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

CHARACTER <- "habitat"
NUM_STATES <- 2

STATE_LABELS <- c("0" = "no - slow", "1" = "yes - slow", "2" = "no - fast", "3" = "yes - fast")

tree_file <- paste0("output/",CHARACTER,"_ase_hrm.tree")

# process the ancestral states
ase <- processAncStates(tree_file,
                        # Specify state labels.
                        # These numbers correspond to
                        # your input data file.
                        state_labels = STATE_LABELS)

# produce the plot object, showing MAP states at nodes.
# color corresponds to state, size to the state's posterior probability
p <- plotAncStatesMAP(t = ase,
                      tree_layout = "rect",
                      tip_labels_size = 1) +
     # modify legend location using ggplot2
     theme(legend.position = c(0.92,0.81))

ggsave(paste0("Primates_",CHARACTER,"_ASE_HRM_MAP.pdf"), p, width = 11, height = 9)




p <- plotAncStatesPie(t = ase,
                      tree_layout = "rect",
                      tip_labels_size = 1) +
     # modify legend location using ggplot2
     theme(legend.position = c(0.92,0.81))

ggsave(paste0("Primates_",CHARACTER,"_ASE_HRM_Pie.pdf"), p, width = 11, height = 9)
