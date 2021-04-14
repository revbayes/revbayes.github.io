library(RevGadgets)
library(ggplot2)

setwd("your_directory")

# SSE

# read in and process the log file
bisse_file <- "data/primates_BiSSE_activity_period.log"
pdata <- processSSE(bisse_file)

# plot the rates
plotMuSSE(pdata)


# read in and process the ancestral states 
bisse_anc_states_file <- "data/anc_states_BiSSE.tree"
p_anc <- processAncStates(path = bisse_anc_states_file)

# plot the ancestral states
plotAncStatesMAP(p_anc, tree_layout = "circular")

# lineage-specific

branch_specific_file <- "data/primates_BDS_rates.log"
branch_specific_tree_file <- "data/primates_tree.nex"

rates <- readTrace(branch_specific_file)
tree <- readTrees(branch_specific_tree_file)
combined <- processBranchData(tree = tree, dat = rates, net_div = T)

plotTree(combined, color_branch_by = "net_div", tip_labels_size = 2, tree_layout = "circular")


# episodic birth-death

# read in and process rates
speciation_time_file <- "data/primates_EBD_speciation_times.log" 
speciation_rate_file <- "data/primates_EBD_speciation_rates.log" 
extinction_time_file <- "data/primates_EBD_extinction_times.log"  
extinction_rate_file <- "data/primates_EBD_extinction_rates.log"
rates <- processDivRates(speciation_time_log = speciation_time_file,
                         speciation_rate_log = speciation_rate_file, 
                         extinction_time_log = extinction_time_file, 
                         extinction_rate_log = extinction_rate_file, 
                         burnin = 0.25)

# plot rates through time 
plotDivRates(rates = rates) + 
        # change labels with ggplot2
        xlab("Millions of years ago") +
        ylab("Rate per million years")