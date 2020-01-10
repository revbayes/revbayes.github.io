# Script for ancestral state reconstruction following analysis in RevBayes

library(ape)
library(tidyverse)
library(igraph)
library(data.table)

# Read trees ----
tree <- read.tree("Nymphalini.phy")
host_tree <- read.tree("angio_25tips_time.phy")
hosts <- host_tree$tip.label


# Character histories ----

# function to make posterior probability matrix
make_anc_node_graph = function(dat, nodes, state) { 
  
  dat <- filter(dat, node_index %in% nodes)
  iterations = sort(unique(dat$iteration))
  n_iter = length(iterations)
  
  # get dimensions
  n_host_tip = length( str_split( dat$start_state[1], "" )[[1]] )
  n_parasite_lineage = length(unique(dat$node_index))
  g = matrix(data = 0, nrow = n_parasite_lineage, ncol = n_host_tip)
  
  for (it in iterations) {
    dat_it = dat[ dat$iteration == it, ]
    ret = list()
    for (i in 1:length(nodes)) {
      dat2 = dat_it[ dat_it$node_index == nodes[i], ]
      if(nrow(dat2)==1){
        ret[[i]] = dat2
      } else{
        ret[[i]] = dat2[ which.min(dat2$transition_time), ]
      }
    }
    
    ret <- rbindlist(ret)
    
    for (r in 1:nrow(ret)) {
      s = as.numeric( str_split (ret$end_state[r], "")[[1]] )
      s_idx = s %in% state
      g[ r, s_idx ] = g[ r, s_idx ] + 1
    }
  }
  
  # convert to probability
  g = g * (1/n_iter)
  
  return(g)
}


# Repeat code below for each of the two outputs
name <- "out.2.bl1.history.txt"
#name <- "out.2.time.history.txt"

colclasses <- c(rep("numeric",7),"character","character","numeric","character",rep("numeric",3))
history_dat = read.table(name, sep="\t", header=T, colClasses = colclasses)

# Remove burnin (10ˆ5 gen) - and set upper limit if necessary
# Also, adjust node_index to match the internal nodes in the tree
history_dat <- filter(history_dat, iteration >= 100000 & iteration <= 500000) %>% 
  mutate(node_index = node_index + 1)


nodes <- 35:67 # select all internal nodes

# Calculate posterior probability for ancestral states - separately for states 1 and 2
pp_s1 <- make_anc_node_graph(history_dat, nodes, c(1))
row.names(pp_s1) <- paste0("Index_",nodes)
colnames(pp_s1) <- hosts
assign(paste0("pp_s1_",name), pp_s1)

pp_s2 <- make_anc_node_graph(history_dat, nodes, c(2))
row.names(pp_s2) <- paste0("Index_",nodes)
colnames(pp_s2) <- hosts
assign(paste0("pp_s2_",name), pp_s2)

# use igraph to transform matrices into edgelists
graph1 <- graph_from_incidence_matrix(pp_s1, weighted = TRUE)
el1 <- get.data.frame(graph1, what = "edges") %>% mutate(p1 = weight) %>% dplyr::select(-weight)
graph2 <- graph_from_incidence_matrix(pp_s2, weighted = TRUE)
el2 <- get.data.frame(graph2, what = "edges") %>% mutate(p2 = weight) %>% dplyr::select(-weight)

# Combine states 1 and 2 and calculate p3, the probability of being on fundamental host repertoire
p_el_full <- full_join(el1,el2, by = c("from","to")) %>% 
  complete(nesting(from,to), fill = list(p2 = 0)) %>%      # cleaner figure but can't see unsampled interactions
  mutate(to = factor(to, levels = hosts),
         from = factor(from, levels = paste0("Index_",nodes)),
         p3 = p1+p2)

ggplot() +
  geom_tile(aes(x = to, y = from, fill = p2), data = filter(p_el_full, p2 >= 0)) + # adjust probability threshold
  geom_point(aes(x = to, y = from, col = p3), data = filter(p_el_full, p3 >= 0), size = 2, shape = "square") +
  scale_x_discrete(drop = FALSE) +
  scale_y_discrete(drop = FALSE) +
  scale_fill_gradient(low = "white", high = "black") +
  scale_color_gradient(low = "white", high = "black") +
  labs(fill = "Posterior\nprobability") +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 270, hjust = 0, size = 8),
    axis.text.y = element_text(size = 8),
    axis.title.x = element_blank(),
    axis.title.y = element_blank())

