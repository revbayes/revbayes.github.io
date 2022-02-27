################################################################################
#
# Plot ancestral placental types inferred using all models of character evolution.
#
#
# authors: Sebastian Hoehna
#
################################################################################

# if you do not have RevGadgets installed, then follow these instructions
#install.packages("devtools")
#library(devtools)
#install_github("GuangchuangYu/ggtree")
#install_github("revbayes/RevGadgets")

library(RevGadgets)
library(ggplot2)

MODELS = c("mk", "freeK", "freeK_RJ")
#MODELS = c("mk")

CHARACTERS <- c("diet", "mating_system", "terrestrially", "solitariness", "males", "habitat", "activity_period")
NUM_STATES <- c(6, 4, 2, 2, 3, 2, 2)

STATE_LABELS <- list()
STATE_LABELS[[1]] <- c("0" = "frugivore", "1" = "insectivore", "2" = "folivore", "3" = "gummnivore", "4" = "omnivore", "5" = "gramnivore")
STATE_LABELS[[2]] <- c("0" = "Mon", "1" = "PG", "2" = "PGA", "3" = "PA")
STATE_LABELS[[3]] <- c("0" = "arb", "1" = "terres")
STATE_LABELS[[4]] <- c("0" = "no", "1" = "yes")
STATE_LABELS[[5]] <- c("0" = "SM", "1" = "SMM", "2" = "MM")
STATE_LABELS[[6]] <- c("0" = "forest", "1" = "savanna")
STATE_LABELS[[7]] <- c("0" = "Diurnal", "1" = "Nocturnal")


for (i in seq_along( CHARACTERS )) {

  char <- CHARACTERS[i]
  n_states <- NUM_STATES[i]

  sl <- STATE_LABELS[[i]]

  for ( m in MODELS ) {

    file_mk <- paste0("output/",char,"_ase_",m,".tree")

  #Mon = 0, PG = 1, PGA = 2, PA = 3
    # process the ancestral states
    ase <- processAncStates(file_mk,
                           # Specify state labels.
                           # These numbers correspond to
                           # your input data file.
                             state_labels = sl)

    # produce the plot object, showing MAP states at nodes.
    # color corresponds to state, size to the state's posterior probability
    p <- plotAncStatesMAP(t = ase,
                          tree_layout = "rect",
                          tip_labels_size = 1) +
         # modify legend location using ggplot2
         theme(legend.position = c(0.92,0.81))

    ggsave(paste0("Primates_",char,"_ASE_",m,"_MAP.pdf"), p, width = 11, height = 9)

    p <- plotAncStatesPie(t = ase,
                          tree_layout = "rect",
                          tip_labels_size = 1) +
         # modify legend location using ggplot2
         theme(legend.position = c(0.92,0.81))

    ggsave(paste0("Primates_",char,"_ASE_",m,"_Pie.pdf"), p, width = 11, height = 9)

  }

  # produce the plot object, showing MAP states at nodes.
  # color corresponds to state, size to the state's posterior probability
  p_tips <- plotAncStatesMAP(t = ase,
                             tree_layout = "rect",
                             tip_labels_size = 1,
                             node_size = c(0,0),
                             tip_states_size = c(2,2)) +
         # modify legend location using ggplot2
         theme(legend.position = c(1.97,1.81))


  ggsave(paste0("Primates_",char,".pdf"), p_tips, width = 11, height = 9)

}
