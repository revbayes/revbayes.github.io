# SSE
bisse_file <- "primates_BiSSE_activity_period.log"
pdata <- processSSE(bisse_file)
plotMuSSE(pdata)

bisse_anc_states_file <- "anc_states_primates_BiSSE_activity_period_results.tree"
p_anc <- processAncStates(path = bisse_anc_states_file)
plotAncStatesMAP(p_anc, tree_layout = "circular") +
  scale_color_manual(values=colFun(2), breaks = c("A", "B"), name = "State") +
  scale_size_continuous(name = "State posterior")

# lineage-specific

branch_specific_file <- "primates_BDS_rates.log"
branch_specific_tree_file <- "primates_tree.nex"

rates <- readTrace(branch_specific_file)
tree <- readTrees(branch_specific_tree_file)
combined <- processBranchData(tree = tree, dat = rates, net_div = T)

plotTree(combined, color_branch_by = "net_div", tip_labels_size = 2, tree_layout = "circular")


# episodic birth-death
speciation_time_file <- "primates_EBD_speciation_times.log", 
speciation_rate_file <- "primates_EBD_speciation_rates.log", 
extinction_time_file <- "primates_EBD_extinction_times.log",  
extinction_rate_file <- "primates_EBD_extinction_rates.log",

rates <- processDivRates(speciation_time_log = speciation_time_file,
                         speciation_rate_log = speciation_rate_file, 
                         extinction_time_log = extinction_time_file, 
                         extinction_rate_log = extinction_rate_file, 
                         burnin = 0.25)

plotDivRates(rates = rates) + 
        xlab("Millions of years ago") +
        ylab("Rate per million years")