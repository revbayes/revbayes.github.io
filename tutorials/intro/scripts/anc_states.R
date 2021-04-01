# ancestral state estimation

file <- "ase_freeK.tree"
freeK <- 
  processAncStates(file, 
      			   state_labels = c("1" = "Epitheliochorial", 
      			        			"2" = "Endotheliochorial", 
      			        			"3" = "Hemochorial"))
plot <- plotAncStatesMAP(t = freeK, 
              tree_layout = "circular") + 
  theme(legend.position = c(0.57,0.41))

# biogeographic estimation (pies and cladogenetic change)
file <- simple.ase.tre"
labs <- c("1" = "K", "2" = "O", 
          "3" = "M",  "4" = "H", 
          "5" = "KO", "6" = "KM", 
          "7" = "OM", "8" = "KH", 
          "9" = "OH", "10" = "MH", 
          "11" = "KOM", "12" = "KOH", 
          "13" = "KMH", "14" = "OMH", 
          "15" = "KOMH")
dec_example <- processAncStatesDiscrete(file, 
                  						state_labels = labs)
ncol <- length(dec_example@state_labels)
colors <- colorRampPalette(colFun(12))(ncol)
names(colors) <- dec_example@state_labels
ordered_labels <- names(colors)[c(6,1,4,3,
                  				  9,5,2,7,
                  				  10,13,12,
                  				  14,11,8,15)]
plotAncStatesPie(t = dec_example,
          		 cladogenetic = TRUE, 
          		 tip_labels_states = TRUE,
          		 pie_colors = colors, 
          		 tip_labels_offset = .2, 
          		 tip_pie_nudge_x = -.15, 
          		 node_pie_size = 1.2, 
          		 tip_pie_size = 0.12, 
          		 tip_labels_states_offset = .05) +
      theme(legend.position = c(0.1, 0.75)) +
      scale_color_manual(values = c(colors, "grey"), 
                         breaks = ordered_labels)