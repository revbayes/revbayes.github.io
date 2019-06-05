source("scripts/plot_anc_range.util.R")

# file names
fp = "./" # edit to provide an absolute filepath
plot_fn = paste(fp, "output/simple.range.pdf",sep="")
tree_fn = paste(fp, "output/simple.ase.tre", sep="")
label_fn = paste(fp, "data/n4/state_labels.simple.n4.txt", sep="")
color_fn = paste(fp, "data/n4/range_colors.n4.txt", sep="")

# get state labels and state colors
states = make_states(label_fn, color_fn, fp=fp)
state_labels = states$state_labels
state_colors = states$state_colors

# plot the ancestral states
pp=plot_ancestral_states(tree_file=tree_fn,
                         include_start_states=T,
                         summary_statistic="PieRange",
                         state_labels=state_labels,
                         state_colors=state_colors,
                         tip_label_size=2.5,
                         tip_label_offset=0.1,
                         node_label_size=0,
                         shoulder_label_size=0,
                         show_posterior_legend=T,
                         tip_pie_diameter=0.5,
                         node_pie_diameter=2.0,
                         pie_nudge_x=0.03,
                         pie_nudge_y=0.16,
                         alpha=1)


# get plot dimensions
x_phy = max(pp$data$x)       # get height of tree
x_label = 3.5                # choose space for tip labels
x_start = 7                  # choose starting age (greater than x_phy)
x0 = -(x_start - x_phy)      # determine starting pos for xlim
x1 = x_phy + x_label         # determine ending pos for xlim

# add axis
pp = pp + theme_tree2()
pp = pp + labs(x="Age (Ma)")

# change x coordinates
pp = pp + coord_cartesian(xlim=c(x0,x1), expand=TRUE)

# plot axis ticks
island_axis = sec_axis(~ ., breaks=x_phy-c(5.1, 2.95, 1.55, 0.5), labels=c("+K","+O","+M","+H") )
x_breaks = seq(0,x_start,1) + x0
x_labels = rev(seq(0,x_start,1))
pp = pp + scale_x_continuous(breaks=x_breaks, labels=x_labels, sec.axis=island_axis)

# plot island age intervals
pp = add_island_times(pp, x_phy)

# set up the legend
pp = pp + guides(colour = guide_legend(override.aes = list(size=5), ncol=2))
pp = pp + theme(legend.position="left")

# save 
ggsave(file=plot_fn, plot=pp, device="pdf", height=7, width=10, useDingbats=F)

