################################################################################
#
# R-script: Checking convergence
#
#
# authors: Sebastian Hoehna
#
################################################################################

library(convenience)

N_REPS = 4
OUTPUT_DIR = "output_4"
FIGS_DIR = "figures"

## Create figures directory
dir.create(FIGS_DIR, showWarnings=FALSE)

check_conv <- checkConvergence( list_files = c(paste0(OUTPUT_DIR,"/primates_cytb_JC_run_",1:N_REPS,".log"), paste0(OUTPUT_DIR,"/primates_cytb_JC_run_",1:N_REPS,".trees") ) )

pdf( paste0(FIGS_DIR,"/convergence.pdf"), height=8, width=8 )
    par(mfrow=c(2,2))

    plotEssContinuous(check_conv)
    plotKS(check_conv)
    plotEssSplits(check_conv)
    plotDiffSplits(check_conv)
dev.off()
