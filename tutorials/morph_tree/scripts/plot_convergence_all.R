library(convenience)

N_REPS = 2

conv.control = makeControl( tracer = NULL,
                            burnin = 0.1,
                            precision = NULL,
                            namesToExclude = NULL
                           )


treefile_mk = paste0("output/mk_run_",1:N_REPS,".trees")
logfile_mk  = paste0("output/mk_run_",1:N_REPS,".log")

check_conv_mk <- checkConvergence( list_files = c(logfile_mk, treefile_mk ),
                                   control = conv.control,
                                   format="revbayes" )


treefile_mkv = paste0("output/mkv_run_",1:N_REPS,".trees")
logfile_mkv  = paste0("output/mkv_run_",1:N_REPS,".log")

check_conv_mkv <- checkConvergence( list_files = c(logfile_mkv, treefile_mkv ),
                                    control = conv.control,
                                    format="revbayes" )


treefile_mkv_discretized = paste0("output/mkv_discretized_run_",1:N_REPS,".trees")
logfile_mkv_discretized  = paste0("output/mkv_discretized_run_",1:N_REPS,".log")

check_conv_mkv_discretized <- checkConvergence( list_files = c(logfile_mkv_discretized, treefile_mkv_discretized ),
                                                control = conv.control,
                                                format="revbayes" )

pdf("convergence.pdf", height=4, width=12 )
  par(mfrow=c(1,3))

  plotDiffSplits(check_conv_mk, title="Mk")
  plotDiffSplits(check_conv_mkv, title="Mkv")
  plotDiffSplits(check_conv_mkv_discretized, title="Mkv discretized")
dev.off()
