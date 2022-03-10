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

character_file = "output/solitariness_hrm_marginal_character.tree"
#character_file = "output/terrestrially_hrm_marginal_character.tree"

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

pdf( "Primates_solitariness_HRM_simmap.pdf" )
#pdf( "Primates_terrestrially_HRM_simmap.pdf" )

plotSimmap(sim2, cols, fsize=0.5, lwd=1, split.vertical=TRUE, ftype="i")

# add legend
x = 0
y = 225

leg = c("no - slow", "yes - slow", "no - fast", "yes - fast")
leg = leg[col_idx]
colors = cols
y = y - (0:(length(leg) - 1))*10
x = rep(x, length(y))
text(x + 0.005, y, leg, pos=4, cex=1.15)

mapply(draw.circle, x=x, y=y, col=colors, MoreArgs = list(nv=200, radius=1, border="white"))

dev.off()
