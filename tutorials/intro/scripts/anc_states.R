library(RevGadgets)
library(ggplot2)
library(gridExtra)
# ancestral state estimation
setwd("your_directory")


file <- "data/ase_freeK.tree"

# process the ancestral states
freeK <- processAncStates(file,
                          # Specify state labels. 
                          # These numbers correspond to 
                          # your input data file.
                          state_labels = c("1" = "Epitheliochorial", 
                                           "2" = "Endotheliochorial", 
                                           "3" = "Hemochorial"))

# produce the plot object
plotAncStatesMAP(t = freeK, 
                 tree_layout = "circular") + 
    # modify legend location using ggplot2
    theme(legend.position = c(0.57,0.41))






#### cladogenetic 

file <- "data/simple.ase.tre"

# Create the labels vector.
# This is a named vector where names correspond 
# to the computer-readable numbers generated 
# in the biogeographic analysis and the values 
# are character strings of whatever you'd like 
# as labels on the figure. The state.labels.txt
# file produced in the analysis links the 
# computer-readable numbers with presence/ absence
# data for individual ranges.

labs <- c("1" = "K", "2" = "O", 
          "3" = "M",  "4" = "H", 
          "5" = "KO", "6" = "KM", 
          "7" = "OM", "8" = "KH", 
          "9" = "OH", "10" = "MH", 
          "11" = "KOM", "12" = "KOH", 
          "13" = "KMH", "14" = "OMH", 
          "15" = "KOMH")
# pass the labels vector and file name to the processing script
dec_example <- processAncStates(file, state_labels = labs)

# plot as-is:
# plotAncStatesPie(dec_example, 
#                  cladogenetic = T, 
#                  tip_labels_offset = 0.2)


# Generate a custom color palette. Here we get the number of 
# states in our data from dec_example@state_labels (this may
# be different from the length of the labs vector if not all
# states are included in the annotated tree).
ncol <- length(dec_example@state_labels)

# We use colorRampPalette() to generate a function that will
# expand the RevGadgets color palette (colFun) to the necessary
# number of colors, but you can use any colors you like as long 
# as each state_label has a color. 
colors <- colorRampPalette(colFun(12))(ncol)

# Name the color vector with your state labels and then order 
# it in the order you'd like the ranges to appear in your legend.
# Otherwise, they will appear alphabetically. 
names(colors) <- dec_example@state_labels
colors <- colors[c(6,1,4,3,
                   9,5,2,7,
                   10,13,12,
                   14,11,8)]

# Plot the results with pies at nodes
pie <- plotAncStatesPie(t = dec_example,
                        # Include cladogenetic events
                        cladogenetic = TRUE, 
                        # Add text labels to the tip pie symbols
                        tip_labels_states = TRUE,
                        # Offset those text labels slightly
                        tip_labels_states_offset = .05,
                        # Pass in your named and ordered color vector
                        pie_colors = colors, 
                        # Offset the tip labels to make room for tip pies
                        tip_labels_offset = .2, 
                        # Move tip pies right slightly 
                        tip_pie_nudge_x = .07,
                        # Change the size of node and tip pies  
                        tip_pie_size = 0.8,
                        node_pie_size = 1.5) +
  # Move the legend 
  theme(legend.position = c(0.1, 0.75))

map <- plotAncStatesMAP(t = dec_example, 
                        # Include cladogenetic events
                        cladogenetic = T,
                        # Pass in the same color vector
                        node_color = colors,
                        # adjust tip labels 
                        tip_labels_offset = 0.1,
                        # increase tip states symbol size
                        tip_states_size = 3) +
  # adjust legend position and remove color guide
  theme(legend.position = c(0.2, 0.87)) + 
  guides(color = FALSE)

# compare plots side by side using the gridExtra package
grid.arrange(pie,map, ncol = 2) 