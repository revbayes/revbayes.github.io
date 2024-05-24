library(RevGadgets)
library(ggplot2)

tree_file = "../output/ase.tre"
log_file = "../output/model.log"
states_file = "../output/states.png"
posterior_file = "../output/posterior.png"

labels <- c("0" = "Aa","1" = "Ca","2" = "Pa","3" = "Cc","4" = "Ad","5" = "El","6" = "AaCa","7" = "AaPa","8" = "CaPa","9" = "AaCc","10" = "CaCc","11" = "PaCc","12" = "AaAd","13" = "CaAd","14" = "PaAd","15" = "CcAd","16" = "AaEl","17" = "CaEl","18" = "PaEl","19" = "CcEl","20" = "AdEl","21" = "AaCaPa","22" = "AaCaCc","23" = "AaPaCc","24" = "CaPaCc","25" = "AaCaAd","26" = "AaPaAd","27" = "CaPaAd","28" = "AaCcAd","29" = "CaCcAd","30" = "PaCcAd","31" = "AaCaEl","32" = "AaPaEl","33" = "CaPaEl","34" = "AaCcEl","35" = "CaCcEl","36" = "PaCcEl","37" = "AaAdEl","38" = "CaAdEl","39" = "PaAdEl","40" = "CcAdEl","41" = "AaCaPaCc","42" = "AaCaPaAd","43" = "AaCaCcAd","44" = "AaPaCcAd","45" = "CaPaCcAd","46" = "AaCaPaEl","47" = "AaCaCcEl","48" = "AaPaCcEl","49" = "CaPaCcEl","50" = "AaCaAdEl","51" = "AaPaAdEl","52" = "CaPaAdEl","53" = "AaCcAdEl","54" = "CaCcAdEl","55" = "PaCcAdEl","56" = "AaCaPaCcAd","57" = "AaCaPaCcEl","58" = "AaCaPaAdEl","59" = "AaCaCcAdEl","60" = "AaPaCcAdEl","61" = "CaPaCcAdEl","62" = "AaCaPaCcAdEl")
colors <- c("#FD3216", "#00FE35", "#6A76FC", "#FED4C4", "#FE00CE", "#0DF9FF", "#F6F926", "#FF9616", "#479B55", "#EEA6FB", "#DC587D", "#D626FF", "#6E899C", "#00B5F7", "#B68E00", "#C9FBE5", "#FF0092", "#22FFA7", "#E3EE9E", "#86CE00", "#BC7196", "#7E7DCD", "#FC6955", "#E48F72")

states <- processAncStates(tree_file, state_labels=labels)

plotAncStatesMAP(t=states,
                 tree_layout="circular",
                 node_size=1.5,
                 node_color_as="state",
                 node_color=colors,
                 node_size_as=NULL) +
                 ggplot2::theme(legend.position="bottom",
                                legend.title=element_blank())

ggsave(states_file, width = 9, height = 9)

trace <- readTrace(path=log_file)
plotTrace(trace, vars=c("phi_d[1]"))

ggsave(posterior_file, width = 9, height = 9)