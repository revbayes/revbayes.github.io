source("scripts/plot_anc_range.util.R")

library(plotrix)
library(phytools)

# file names
fp = "./" # edit to provide an absolute filepath
plot_fn = paste(fp, "primates_simple.range.pdf",sep="")
tree_fn = paste(fp, "output/primates_simple.ase.tre", sep="")
label_fn = paste(fp, "data/primates_state_labels.simple.n4.txt", sep="")
color_fn = paste(fp, "data/primates_range_colors.n4.txt", sep="")

# get state labels and state colors
states = make_states(label_fn, color_fn, fp=fp)
state_labels = states$state_labels
state_colors = states$state_colors

# process the ancestral states
ase <- processAncStates(tree_fn,
                        # Specify state labels.
                        # These numbers correspond to
                        # your input data file.
                        state_labels = state_labels)

# plot the ancestral states
pp  <- plotAncStatesPie(t = ase,
                        tree_layout = "rect",
                        tip_labels_size = 1) +
  # Move the legend
  theme(legend.position = c(0.1, 0.75))


# get plot dimensions
x_phy = max(pp$data$x)       # get height of tree
x_label = 3.5                # choose space for tip labels
x_start = x_phy + 2          # choose starting age (greater than x_phy)
x0 = -(x_start - x_phy)      # determine starting pos for xlim
x1 = x_phy + x_label         # determine ending pos for xlim

# add axis
pp = pp + theme_tree2()
pp = pp + labs(x="Age (Ma)")

# change x coordinates
pp = pp + coord_cartesian(xlim=c(x0,x1), expand=TRUE)

# set up the legend
#pp = pp + guides(colour = guide_legend(override.aes = list(size=5), ncol=2))
pp = pp + theme(legend.position="left")

# save
ggsave(file=plot_fn, plot=pp, device="pdf", height=7, width=10, useDingbats=F)




# produce the plot object, showing MAP states at nodes.
# color corresponds to state, size to the state's posterior probability
p <- plotAncStatesMAP(t = ase,
                      tree_layout = "rect",
                      tip_labels_size = 1) +
     # modify legend location using ggplot2
     theme(legend.position = c(0.92,0.81))

ggsave("Primates_simple_MAP.pdf", p, width = 11, height = 9)









character_file = "output/primates_simple.char.map.tre"

sim2 = read.simmap(file=character_file, format="phylip")

colors = vector()
for (i in 1:length( sim2$maps ) ) {
    colors = c(colors, names(sim2$maps[[i]]) )
}
colors = sort(as.numeric(unique(colors)))
col_idx = colors
col_idx
cols = setNames( rainbow(length(colors), start=0.0, end=0.9), colors)

#col_names <- names(cols)
#base_cols <- c("#fa7850","#005ac8")
#alpha_scale <- c(75,10)
#cols <- c()
#index <- 1
#for (i in 1:2) {
#    for ( bc in base_cols ) {
#        cols[index] <- t_col(bc, percent = alpha_scale[i], name = paste0(i,"_",bc))
#        index <- index + 1
#    }
#}
#cols = cols[col_idx]
#names(cols) <- col_names
#colors <- cols

pdf( "Primates_simple_simmap.pdf" )

plotSimmap(sim2, cols, fsize=0.5, lwd=1, split.vertical=TRUE, ftype="i")

# add legend
x = 0
y = 225

leg = state_labels
leg = leg[col_idx]
#cols = cols[col_idx]
colors = cols
y = y - (0:(length(leg) - 1))*10
x = rep(x, length(y))
text(x + 0.005, y, leg, pos=4, cex=1.15)

mapply(draw.circle, x=x, y=y, col=colors, MoreArgs = list(nv=200, radius=1, border="white"))

dev.off()
