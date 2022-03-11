################################################################################
#
# Plotting the SIMMAP under a BiSSE model
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(plotrix)
library(phytools)
library(RevGadgets)
library(ggplot2)

DATASET <- "activity_period"

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


# read in and process the ancestral states
hisse_file <- paste0("output/primates_HiSSE_",DATASET,"_stoch_map_character.tree")


sim = read.simmap(file=hisse_file, format="phylip")

colors = vector()
for (i in 1:length( sim$maps ) ) {
    colors = c(colors, names(sim$maps[[i]]) )
}
colors = sort(as.numeric(unique(colors)))
col_idx = colors + 1
col_idx
cols = setNames( rainbow(length(colors), start=0.0, end=0.9), colors)
col_names <- names(cols)

col_names <- names(cols)
base_cols <- c("#fa7850","#005ac8")
alpha_scale <- c(75,50,25,10)
cols <- c()
index <- 1
for (i in 1:4) {
    for ( bc in base_cols ) {
        cols[index] <- t_col(bc, percent = alpha_scale[i], name = paste0(i,"_",bc))
        index <- index + 1
    }
}
cols = cols[col_idx]
names(cols) <- col_names
colors <- cols



pdf( paste0("HiSSE_simmap_",DATASET,".pdf"), width=8, height=12 )
plotSimmap(sim, cols, fsize=0.3, lwd=1, split.vertical=TRUE, ftype="i")

# add legend
x = 0
y = 225

leg = names(cols)
colors = cols
y = y - (0:(length(leg) - 1))*10
x = rep(x, length(y))
text(x + 0.1, y, leg, pos=4, cex=1.15)

mapply(draw.circle, x=x, y=y, col=colors, MoreArgs = list(nv=200, radius=1, border="white"))

dev.off()
