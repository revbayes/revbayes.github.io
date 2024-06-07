################################################################################
#
# Check for convergence for the unrooted tree analysis.
#
#
# author: Sebastian Hoehna
#
################################################################################

library(convenience)

# Analysis settings
N_REPS       = 2
LOCUS        = "COI"

treefile_names = paste0("output/photinus_",LOCUS,"_run_",1:N_REPS,".trees")
logfile_names  = paste0("output/photinus_",LOCUS,"_run_",1:N_REPS,".log")
format         = "revbayes"

conv.control = makeControl( tracer = NULL,
                            burnin = 0.2,
                            precision = NULL,
                            namesToExclude = NULL
                           )

check_conv <- checkConvergence( list_files = c(logfile_names, treefile_names ),
                                control = conv.control,
                                format=format )

pdf( paste0("convergence_unrooted_",LOCUS,".pdf"), height=8, width=8 )
  par(mfrow=c(2,2))
  plotEssContinuous(check_conv)
  plotKS(check_conv)
  plotEssSplits(check_conv)
  plotDiffSplits(check_conv)
dev.off()

save(check_conv, file = paste0("convergence_unrooted_",LOCUS,".Rdata") )
