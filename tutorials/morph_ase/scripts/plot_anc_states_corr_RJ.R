################################################################################
#
# Plot ancestral state estimates inferred using two correlated CTMC models of character evolution.
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(RevGadgets)
library(ggplot2)

CHARACTER_A <- "solitariness"
CHARACTER_B <- "terrestrially"

STATE_LABELS <- c("0" = "group - arboreal", "1" = "group - terrestrial", "2" = "solitary - arboreal", "3" = "solitary - terrestrial")

tree_file <- paste0("output/",CHARACTER_A,"_",CHARACTER_B,"_ase_corr_RJ.tree")

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

ggsave(paste0("Primates_",CHARACTER_A,"_",CHARACTER_B,"_ASE_corr_RJ_MAP.pdf"), p, width = 11, height = 9)




p <- plotAncStatesPie(t = ase,
                      tree_layout = "rect",
                      tip_labels_size = 1) +
     # modify legend location using ggplot2
     theme(legend.position = c(0.92,0.81))

ggsave(paste0("Primates_",CHARACTER_A,"_",CHARACTER_B,"_ASE_corr_RJ_Pie.pdf"), p, width = 11, height = 9)



library(plotrix)
library(phytools)

## Transparent colors
## Mark Gardener 2015
## www.dataanalytics.org.uk

t_col <- function(color, percent = 50, name = NULL) {
  #      color = color name
  #    percent = % transparency
  #       name = an optional name for the color

## Get RGB values for named color
rgb.val <- col2rgb(color)

## Make new color using input color as base and alpha set by transparency
t.col <- rgb(rgb.val[1], rgb.val[2], rgb.val[3],
             max = 255,
             alpha = (100 - percent) * 255 / 100,
             names = name)

## Save the color
invisible(t.col)
}
## END

character_file = paste0("output/",CHARACTER_A,"_",CHARACTER_B,"_corr_RJ_marginal_character.tree")

sim2 = read.simmap(file=character_file, format="phylip")

colors = vector()
for (i in 1:length( sim2$maps ) ) {
    colors = c(colors, names(sim2$maps[[i]]) )
}
colors = sort(as.numeric(unique(colors)))
col_idx = colors + 1
col_idx
cols = setNames( rainbow(length(colors), start=0.0, end=0.9), colors)

col_names <- names(cols)
base_cols <- c("#fa7850","#005ac8")
alpha_scale <- c(75,10)
cols <- c()
index <- 1
for (i in 1:2) {
    for ( bc in base_cols ) {
        cols[index] <- t_col(bc, percent = alpha_scale[i], name = paste0(i,"_",bc))
        index <- index + 1
    }
}
cols = cols[col_idx]
names(cols) <- col_names
colors <- cols

pdf( paste0("Primates_",CHARACTER_A,"_",CHARACTER_B,"_corr_RJ_simmap.pdf" ) )

plotSimmap(sim2, cols, fsize=0.5, lwd=1, split.vertical=TRUE, ftype="i")

# add legend
x = 0
y = 225

leg = STATE_LABELS
leg = leg[col_idx]
colors = cols
y = y - (0:(length(leg) - 1))*10
x = rep(x, length(y))
text(x + 0.005, y, leg, pos=4, cex=1.15)

mapply(draw.circle, x=x, y=y, col=colors, MoreArgs = list(nv=200, radius=1, border="white"))

dev.off()
