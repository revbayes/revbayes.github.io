# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)

tree <- read.nexus("data/primates_tree.nex")

rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_PEP_speciation_times.log",
                                 speciation_rates_file = "output/primates_EBD_PEP_speciation_rates.log",
                                 extinction_times_file = "output/primates_EBD_PEP_extinction_times.log",
                                 extinction_rates_file = "output/primates_EBD_PEP_extinction_rates.log",
                                 tree=tree,
                                 burnin=0.25,numIntervals=1000)

pdf("EBD_PEP.pdf")
    par(mfrow=c(2,2))
    rev.plot.div.rates(rev_out,use.geoscale=FALSE)
dev.off()

for (i in 1:4) {

    rev_out <- rev.process.div.rates(speciation_times_file = paste0("output/primates_EBD_PEP_speciation_times_run_",i,".log"),
                                     speciation_rates_file = paste0("output/primates_EBD_PEP_speciation_rates_run_",i,".log"),
                                     extinction_times_file = paste0("output/primates_EBD_PEP_extinction_times_run_",i,".log"),
                                     extinction_rates_file = paste0("output/primates_EBD_PEP_extinction_rates_run_",i,".log"),
                                     tree=tree,
                                     burnin=0.25,numIntervals=1000)

    pdf(paste0("EBD_PEP_run_",i,".pdf"))
        par(mfrow=c(2,2))
        rev.plot.div.rates(rev_out,use.geoscale=FALSE)
    dev.off()

}
