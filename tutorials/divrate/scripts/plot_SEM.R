# Install RevGadget if you haven't done so already
#library(devtools)
#install_github("revbayes/RevGadgets")

library(RevGadgets)
library(coda)
library(mcmcse)


rev.assess.mcmc.precision = function(filename, threshold = 1E-3, burnin = 0.1, relative=TRUE) {


    # read in the MCMC output
    tmp <- read.table(filename,header=TRUE, check.names=FALSE)
    
    # now convert the MCMC output into an MCMC object
    mcmc_samples <- as.mcmc(tmp)
    
    # get the variable names for this analysis and remove the boiler plate ones
    var_names <- varnames(mcmc_samples)
    if ( "Replicate_ID" %in% var_names )   var_names <- var_names[-which(var_names == "Replicate_ID")]
    if ( "Iteration" %in% var_names )      var_names <- var_names[-which(var_names == "Iteration")]
    if ( "Posterior" %in% var_names )      var_names <- var_names[-which(var_names == "Posterior")]
    if ( "Likelihood" %in% var_names )     var_names <- var_names[-which(var_names == "Likelihood")]
    if ( "Prior" %in% var_names )          var_names <- var_names[-which(var_names == "Prior")]

    # set up the vectors for the standard error of the mean
    sem         <- c()
    sem_rel     <- c()
    sem_025     <- c()
    sem_025_rel <- c()
    sem_975     <- c()
    sem_975_rel <- c()
    
    # calculate the starting sample after removing the burnin
    start_iter <- ceiling(length(mcmc_samples[,1])*burnin)
    end_iter <- length(mcmc_samples[,1])
    
    # now compute the standard error for each variable
    for ( i in seq_len(length(var_names)) ) {
    
        # get the name for this variable
        name <- var_names[i]
        
        # get the MCMC samples for this variable
        this_par_samples <- mcmc_samples[start_iter:end_iter,name]
        
        # calculate the standard error of the mean
        this_ESS <- effectiveSize(this_par_samples)
        this_ESS <- ess(this_par_samples)
        sem[i] <- sd(this_par_samples)/sqrt(this_ESS)
        sem[i] <- mcse(this_par_samples)$se
        sem_025[i] <- mcse.q(this_par_samples,0.025)$se
        sem_975[i] <- mcse.q(this_par_samples,0.975)$se
        if ( relative == TRUE ) {
            sem_rel[i]     <- sem[i] / mean(this_par_samples)
            sem_025_rel[i] <- sem_025[i] / mcse.q(this_par_samples,0.025)$est
            sem_975_rel[i] <- sem_975[i] / mcse.q(this_par_samples,0.975)$est
        } else {
            sem_rel[i]     <- sem[i]
            sem_025_rel[i] <- sem_025[i]
            sem_975_rel[i] <- sem_975[i] 
        }

    }

    # build the filename for output plotting
    tmp_filename <- basename(filename)
    output_file <- tools::file_path_sans_ext(tmp_filename)

    # plot the results
    y_range      <- c(0, 1.2*max(threshold,sem_rel))
    y_range_025  <- c(0, 1.2*max(threshold,sem_025_rel))
    y_range_975  <- c(0, 1.2*max(threshold,sem_975_rel))


    pdf(paste0(output_file,"_SEM.pdf"),height=5,width=12.0)
    par(mfrow=c(1,3))
    par(mar=c(8,4,2,1))
    par(oma=c(0,1,2,0))

    plot(sem_rel,ylim=y_range,pch=19,xaxt="n",ylab="",xlab="")
    #las=1, xaxt="n", bty="n", xaxt="n", yaxt="n"
    abline(h=threshold)

    axis(1, at=seq_len(length(var_names)),labels=var_names, col.axis="black", las=2)

    mtext("Precision", side=2, line=2.5,cex=1.4)
    mtext("Mean", side=3, line=1.5,cex=1.4)
    
    
    

    plot(sem_025_rel,ylim=y_range_025,pch=19,xaxt="n",ylab="",xlab="")
    #las=1, xaxt="n", bty="n", xaxt="n", yaxt="n"
    abline(h=threshold)

    axis(1, at=seq_len(length(var_names)),labels=var_names, col.axis="black", las=2)

#    mtext("Precision", side=2, line=2.5,cex=1.4)
    mtext("0.025 Quantile", side=3, line=1.5,cex=1.4)
    
    
    

    plot(sem_975_rel,ylim=y_range_975,pch=19,xaxt="n",ylab="",xlab="")
    #las=1, xaxt="n", bty="n", xaxt="n", yaxt="n"
    abline(h=threshold)

    axis(1, at=seq_len(length(var_names)),labels=var_names, col.axis="black", las=2)

#    mtext("Precision", side=2, line=2.5,cex=1.4)
    mtext("0.975 Quantile", side=3, line=1.5,cex=1.4)

    dev.off()

}



rev.assess.mcmc.precision("output/primates_BD.log")