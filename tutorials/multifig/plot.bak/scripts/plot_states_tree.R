library(RevGadgets)
library(ggplot2)
# install.packages("RColorBrewer", quiet=T)
# install.packages("Polychrome", quiet=T, repos="http://cran.us.r-project.org")
null = tryCatch( {install.packages('Polychrome', repos='http://cran.us.r-project.org', quiet=T)}, warning=function(w){} )
#library(RColorBrewer)
library(Polychrome)

# arguments
cmd_str = "Rscript ./scripts/plot_states_tree.R ./output/out.states.tre ./output/out.mcc.tre ./example_input/kadua_data/kadua_range_label.csv GNKOMHZ"
args = commandArgs(trailingOnly = T)
if ( length(args) != 4 ) {
    stop_str = paste0("Invalid arguments. Correct usage:\n> ", cmd_str, "\n")
    stop(stop_str)
}

# filesystem
state_fn          = args[1]                             # ex: "./output/out.states.tre"
mcc_fn            = args[2]                             # ex: "./output/out.mcc.tre"
labels_fn         = args[3]                             # ex: "./example_input/kadua_data/kadua_range_label.csv"
region_names      = args[4]                             # ex: "GNKOMHZ"

plot_anc_pie_fn   = paste0("./output/plot_states_prob.pdf")
plot_anc_map_fn   = paste0("./output/plot_states_map.pdf")


# Create the labels vector
regions = unlist(strsplit(region_names, "")[[1]])
df_states = read.csv(labels_fn, colClasses=c("range"="character"))
labs = rep(NA, nrow(df_states))
for (i in 1:nrow(df_states)) {
    # get range strings
    x = df_states$range[i]
    # convert into range bit-vectors
    s = as.numeric(strsplit(x=x,split="")[[1]])
    # convert into region-set strings
    y = paste0(regions[which(s==1)], collapse="")
    labs[i] = y
}
names(labs) = as.character( 0:(nrow(df_states)-1))

# pass the labels vector and file name to the processing script
anc_tree <- processAncStates(state_fn, state_labels = labs)

# clean up root state start probs? not sure why this occurs now
tmp = anc_tree@data
root_idx = nrow(tmp)
tmp = tmp[ tmp$index == root_idx, ]
start_idx = c()
end_idx = c()
for (i in 1:3) {
    start_idx = c(start_idx, paste0("start_state_", i), paste0("start_state_",i,"_pp"))
    end_idx = c(end_idx, paste0("end_state_", i), paste0("end_state_",i,"_pp"))
}
start_idx = c(start_idx, "start_state_other_pp")
end_idx = c(end_idx, "start_state_other_pp")
tmp[,start_idx] = tmp[,end_idx]
anc_tree@data[ anc_tree@data$index == root_idx, ] = tmp
anc_tree@phylo$root.edge = 2

# read in the tree 
mcc_tree <- readTrees(paths = mcc_fn)

# Uncomment to see states needing color assignments
#print(anc_tree@state_labels)

# Randomly assign colors to all states
set.seed(1)
colors = createPalette(length(labs), c("#00FF00", "#FF0000", "#AA00AA",  "#0000FF", "#00AAAA", "#AAAA00", "#FFFF00", "#FF00FF", "#00FFFF"), range=c(30,90))
names(colors) = labs
# set.seed(1); colors = sample(colors)

# Plot the results with MAP estimates at nodes
map <- plotAncStatesMAP(t = anc_tree,
                        # Include cladogenetic events
                        cladogenetic = T,
                        # Pass in the same color vector
                        node_color = colors,
                        # Print tip label states
                        tip_labels_states = TRUE,
                        # Offset those text labels slightly
                        tip_labels_states_offset = .2,
                        # adjust tip labels
                        tip_labels_offset = 0.8,
                        # increase tip states symbol size
                        tip_states_size = 3,
                        shoulder_states_size = 3,
                        # opaque colors
                        state_transparency = 1.0,
                        timeline = TRUE) +
  # adjust legend position and remove color guide
  theme(legend.position.inside = c(0.95, 0.36) )

pdf(plot_anc_map_fn, height=9, width=12)
print(map)
dev.off()



# Plot the results with pies at nodes
pie <- plotAncStatesPie(t = anc_tree,
                        # Include cladogenetic events
                        cladogenetic = TRUE, 
                        # Add text labels to the tip pie symbols
                        tip_labels_states = TRUE,
                        # Offset those text labels slightly
                        tip_labels_states_offset = .4,
                        # Pass in your named and ordered color vector
                        pie_colors = colors, 
                        # Offset the tip labels to make room for tip pies
                        tip_labels_offset = .7, 
                        # Move tip pies right slightly 
                        tip_pie_nudge_x = .1,
                        # Change the size of node and tip pies  
                        tip_pie_size = 0.8,
                        node_pie_size = 1.2,
                        shoulder_pie_size = 0.7,
                        # opaque colors
                        state_transparency = 1.0,
                        timeline = TRUE) +
  # Move the legend 
  theme(legend.position.inside = c(0.95, 0.7) )

pdf(plot_anc_pie_fn, height=9, width=12)
print(pie)
dev.off()

