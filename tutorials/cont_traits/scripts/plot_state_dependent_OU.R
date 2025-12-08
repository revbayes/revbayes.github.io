library(ape)
library(cowplot)
library(phytools)
library(RevGadgets)
source("scripts/plot_state_dependent_OU_helper.R")

# 1. post-processing
# tree <- read.nexus("data/artiodactyla.tree")
# simmap_to_ancStates("output/character_histories.trees", "output/character_histories.log", tree)

# 2. go to RevBayes for more post-processing

# 3. plot histories
tree <- readTrees("data/artiodactyle.tree")

ase <- processAncStates("output/anc_states.tre",
                        state_labels=c("0"="Browsers", "1"="Mixed feeders", "2"="Grazers"))

p1 <- plotAncStatesMAP(t = ase,
                       tip_labels = FALSE,
                       node_color_as = "state",
                       node_color = c("Browsers"="#2c6e49", "Mixed feeders"="#adc178", "Grazers"="#7f4f24"),
                       node_size = c(1, 3),
                       tip_states = TRUE,
                       tip_states_size = 2,
                       state_transparency = 0.7,
) +
  theme(legend.position.inside = c(0.6,0.8))

p2 <- plotAncStatesPie(t = ase,
                       pie_colors = c("Browsers"="#2c6e49", "Mixed feeders"="#adc178", "Grazers"="#7f4f24"),   
                       node_pie_size = 3,
                       tip_pies = TRUE,
                       tip_pie_size = 2
                       state_transparency = 0.7,
                       tip_labels = FALSE,         
) +
  theme(legend.position.inside = c(0.6,0.8))

char_hist <- read.table("output/sdou_joint/charhist.log", header = TRUE)
simmaps <- read.simmap(text=char_hist$char_hist, format = "phylip")
processed_simmaps <- processStochMaps(tree=tree, simmap = simmaps, states = c("0", "1", "2"))

colnames(processed_MAP)[6] = "Browsers"
colnames(processed_MAP)[7] = "Mixed feeders"
colnames(processed_MAP)[8] = "Grazers"

p3 <- plotStochMaps(tree=tree, maps = processed_MAP, color_by = "MAP",
                    colors = c("Browsers"="#2c6e49", "Mixed feeders"="#adc178", "Grazers"="#7f4f24"),
                    tip_labels = FALSE,
                    line_width=0.5
)

history_plots <- plot_grid(p1, p2, p3, ncol=3)

# 4. plot OU parameters
trace <- readTrace("output/trace.log", burnin = 0.1)
color_diet <- c("#2c6e49", "#adc178", "#7f4f24")

# plot alpha
names(color_diet) <- c("alpha[1]", "alpha[2]", "alpha[3]")
p4 <- plotTrace(trace, vars = c("alpha[1]", "alpha[2]", "alpha[3]"), color = color_diet)[[1]] +
  ggtitle("Rate of attraction $alpha$") +
  theme(legend.position = "none") +
  xlab("inverse time") +
  ylab("Posterior probability density")

# plot theta
names(color_diet) <- c("theta[1]", "theta[2]", "theta[3]")
p5 <- plotTrace(trace, vars = c("theta[1]", "theta[2]", "theta[3]"), color = color_diet)[[1]] +
  ggtitle("Optimum $theta$") +
  theme(legend.position = "none",
        axis.title.y = element_blank()) +
  xlab("hypsodonty index")
# plot sigma^2

names(color_diet) <- c("sigma2[1]", "sigma2[2]", "sigma2[3]")
p6 <- plotTrace(trace, vars = c("sigma2[1]", "sigma2[2]", "sigma2[3]"), color = color_diet)[[1]] +
  ggtitle("Diffusion variance") +
  theme(axis.title.y = element_blank()) +
  xlab("hypsodonty index-squared per unit time") +
  theme(legend.position = "none",
        axis.title.y = element_blank())

# plot legend
legend <- get_legend2(p6 + theme(legend.position = "left",
                                 legend.box.margin = margin(0, 0, 0, 12))
                      + guides(color = guide_legend(title='Diet'),
                               fill=guide_legend(title='Diet'))
                      + scale_fill_discrete(name = "Diet")
                      + scale_color_manual(values=c("#2c6e49", "#adc178", "#7f4f24"), 
                                           name="Diet",
                                           labels=c("Browsers", "Mixed feeders", "Grazers")))

ou_plots <- plot_grid(p4, p5, p6, legend, ncol=4)