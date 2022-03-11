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

# read in and process the ancestral states
bisse_file <- paste0("output/primates_BiSSE_",DATASET,"_stoch_map_character.tree")


sim = read.simmap(file=bisse_file, format="phylip")

colors = vector()
for (i in 1:length( sim$maps ) ) {
    colors = c(colors, names(sim$maps[[i]]) )
}
colors = sort(as.numeric(unique(colors)))
colors
cols = setNames( rainbow(length(colors), start=0.0, end=0.9), colors)
col_names <- names(cols)
cols <- c("#fa7850","#005ac8")
names(cols) <- col_names



pdf( paste0("BiSSE_simmap_",DATASET,".pdf"), width=8, height=12 )
plotSimmap(sim, cols, fsize=0.3, lwd=1, split.vertical=TRUE, ftype="i")

# add legend
x = 0
y = 225

leg = names(cols)
colors = cols
y = y - (0:(length(leg) - 1))*10
x = rep(x, length(y))
text(x + 0.15, y, leg, pos=4, cex=1.15)

mapply(draw.circle, x=x, y=y, col=colors, MoreArgs = list(nv=200, radius=1, border="white"))

dev.off()
