library(RevGadgets)
source("posterior_summary/utils.R")

# read the observed data
data_file <- "data/morpho.nex"
data      <- readMorphoData(data_file)

# specify the output directory for each model
output_strict_Mk   <- "output_PPS/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_PPS/"
output_UCLN_Mk     <- "output_PPS/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_PPS/"
outout_UCE_Mk      <- "output_PPS/div_constant_foss_constant_moleclock_UCE_moleQ_HKY_morphclock_linked_morphQ_Mk_PPS/"
output_UCLN_F81Mix <- "output_PPS/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_F81Mix_PPS/"

# read the output files
samples_strict_Mk   <- readMorphoPPS(output_strict_Mk)
samples_UCLN_Mk     <- readMorphoPPS(output_UCLN_Mk)
samples_UCE_Mk      <- readMorphoPPS(outout_UCE_Mk)
samples_UCLN_F81Mix <- readMorphoPPS(output_UCLN_F81Mix)

# compute the statistics
stats_strict_Mk   <- processMorphoPPS(data, samples_strict_Mk)
stats_UCLN_Mk     <- processMorphoPPS(data, samples_UCLN_Mk)
stats_UCE_Mk      <- processMorphoPPS(data, samples_UCE_Mk)
stats_UCLN_F81Mix <- processMorphoPPS(data, samples_UCLN_F81Mix)

# create the plots
p_strict_Mk   <- plotPostPredStats(stats_strict_Mk)
p_UCLN_Mk     <- plotPostPredStats(stats_UCLN_Mk)
p_UCE_Mk      <- plotPostPredStats(stats_UCE_Mk)
p_UCLN_F81Mix <- plotPostPredStats(stats_UCLN_F81Mix)

# plot things together
combined_stats <- list(
  strict_Mk   = stats_strict_Mk,
  UCLN_Mk     = stats_UCLN_Mk,
  UCE_Mk      = stats_UCE_Mk,
  UCLN_F81Mix = stats_UCLN_F81Mix
)

pdf("figures/pps.pdf", height = 10)
print(boxplotPostPredStats(combined_stats))
dev.off()
