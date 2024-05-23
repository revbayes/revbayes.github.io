library(RevGadgets)
library(ggplot2)

tree_file = "../output/ase.tre"
states_file = "../figures/states.png"

labels <- c("0" = "R","1" = "K","2" = "O","3" = "M","4" = "H","5" = "Z","6" = "RK","7" = "RO","8" = "KO","9" = "RM","10" = "KM","11" = "OM","12" = "RH","13" = "KH","14" = "OH","15" = "MH","16" = "RZ","17" = "KZ","18" = "OZ","19" = "MZ","20" = "HZ","21" = "RKO","22" = "RKM","23" = "ROM","24" = "KOM","25" = "RKH","26" = "ROH","27" = "KOH","28" = "RMH","29" = "KMH","30" = "OMH","31" = "RKZ","32" = "ROZ","33" = "KOZ","34" = "RMZ","35" = "KMZ","36" = "OMZ","37" = "RHZ","38" = "KHZ","39" = "OHZ","40" = "MHZ","41" = "RKOM","42" = "RKOH","43" = "RKMH","44" = "ROMH","45" = "KOMH","46" = "RKOZ","47" = "RKMZ","48" = "ROMZ","49" = "KOMZ","50" = "RKHZ","51" = "ROHZ","52" = "KOHZ","53" = "RMHZ","54" = "KMHZ","55" = "OMHZ","56" = "RKOMH","57" = "RKOMZ","58" = "RKOHZ","59" = "RKMHZ","60" = "ROMHZ","61" = "KOMHZ","62" = "RKOMHZ")

states <- processAncStates(tree_file, state_labels=labels)

plotAncStatesMAP(t=states,
                 timeline=T,
                 geo=F,
                 time_bars=F,
                 node_size=2,
                 node_color_as="state",
                 node_size_as=NULL,
                 tip_labels_offset=0.1) +
                 ggplot2::theme(legend.position="bottom",
                                legend.title=element_blank())

ggsave(states_file, width = 9, height = 9)
