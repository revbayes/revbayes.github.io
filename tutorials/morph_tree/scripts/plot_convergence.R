library(convenience)

N_REPS = 2

treefile_names = paste0("output/mk_run_",1:N_REPS,".trees")
logfile_names  = paste0("output/mk_run_",1:N_REPS,".log")

conv.control = makeControl( tracer = NULL,
                            burnin = 0.1,
                            precision = NULL,
                            namesToExclude = NULL
                           )


check_conv <- checkConvergence( list_files = c(logfile_names, treefile_names ),
                                control = conv.control,
                                format="revbayes" )


pdf("convergence_mk_full.pdf", height=8, width=8 )
  par(mfrow=c(2,2))

  plotEssContinuous(check_conv)
  plotKS(check_conv)
  plotEssSplits(check_conv)
  plotDiffSplits(check_conv)
dev.off()

pdf( "convergence_mk_split_difference.pdf", height=4, width=4 )
  plotDiffSplits(check_conv)
dev.off()
