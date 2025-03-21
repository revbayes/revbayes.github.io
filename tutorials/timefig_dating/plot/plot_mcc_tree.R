library(RevGadgets)
library(ggplot2)

# arguments
cmd_str = "Rscript ./scripts/plot_mcc_tree.R ./output/out.mcc.tre"
args = commandArgs(trailingOnly = T)
if ( length(args) != 1 ) {
    stop_str = paste0("Invalid arguments. Correct usage:\n> ", cmd_str, "\n")
    stop(stop_str)
}

# filesystem
mcc_fn = args[1]   # example: "./output/out.mcc.tre"
base_fn = sub('\\..[^\\.]*$', '', mcc_fn)
out_fn = "./output/plot_mcc_tree.pdf"

# read in the tree 
mcc_tree <- readTrees(paths = mcc_fn)

# plot the MCC tree
mcc = plotTree(tree = mcc_tree, 
            timeline = T, 
            tip_labels_size = 2, 
            age_bars_width = 1.5,
            node_age_bars = T) + 
            theme(legend.position.inside = c(.05, .6),
                  legend.background = element_rect(fill="transparent"))

# write pdf file
pdf(out_fn, height=9, width=12)
print(mcc)
dev.off()
