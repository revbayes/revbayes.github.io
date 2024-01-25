################################################################################
#
# RevBayes Example: Model adequacy testing using posterior prediction for morpholgical substitution models.
#
# authors:  Laura Mulvey
#
################################################################################
################################################################################

### helper variables 

model <- "MkVP+G"
dataset <- "Egi_etal_2005.nex"
analysis_name <- "pps_morpho_example"


simulation_reps_path <- paste0("output_", model, "/", analysis_name, "_post_sims" )
sim_reps <- list.files(simulation_reps_path)

Results <- matrix(nrow=2, ncol=7)
rownames(Results) <- c("Consistency Index", "Retention Index")
colnames(Results) <- c("Effect size","ES upper", "ES lower", "Lower-1-tailed", "Upper-1-tailed", "Two-tailed", "Midpoint")

## Calculate Consistency Index and Retention Index

TestStats <- matrix(nrow=length(sim_reps), ncol=2)
colnames(TestStats) <- c("Consistency Index", "Retention Index")


  
  
  # read in empirical data
  empdata <- ape::read.nexus.data(paste0("data/",dataset))
  phylev <- unique(unlist(unique( empdata)))
  Emp_MCC_tree <- ape::read.nexus( paste0("output_",model,"/MCC.tre" ))
  Emp_data_ph <-  phangorn::phyDat(empdata, type="USER", levels=phylev, return.index = TRUE)
  
  ## Empirical values
  empci <- phangorn::CI(Emp_MCC_tree, Emp_data_ph)
  empri <- phangorn::RI(Emp_MCC_tree,  Emp_data_ph)
  
  
  ## Simulated values
  nm <- names(empdata)
  for (i in 1:length(sim_reps)){
    simdata <- list()
    morpho_nexus <- list.files(paste0(simulation_reps_path,"/", sim_reps[i]))
    #morpho_nexus <- morpho_nexus[1:length(morpho_nexus)-1]
    for (r in 1:length(morpho_nexus)){
      m_nex <- ape::read.nexus.data(paste0(simulation_reps_path, "/",sim_reps[i], "/", morpho_nexus[r]))
     for (u in 1:length(nm)){
        temp <- m_nex[[nm[u]]]
        simdata[[nm[u]]] <- append(simdata[[nm[u]]] ,temp  )
      } 
      
    }
   # simdata <- ape::read.nexus.data(paste0(simulation_reps_path, "/",sim_reps[i], "/seq.nex"))
    phylev <- unique(unlist(unique(simdata)))
    sim_data_ph <-  phangorn::phyDat(simdata, type="USER", levels=phylev, return.index = TRUE)
    
   
      TestStats[i,"Consistency Index"] <- phangorn::CI(Emp_MCC_tree,  sim_data_ph)
    
 
      TestStats[i,"Retention Index"] <- phangorn::RI(Emp_MCC_tree,  sim_data_ph) 
    
    
    
  
  
}
pdf("Rb.pdf")
par(mfrow=c(2,2))
hist(TestStats[,"Consistency Index"], col = "gray74", border = "white", xlim = c(0,1), xlab = "Consistency Index", main="")
abline(v=empci, col ="forest green", lty=2, lwd =2)
abline(v=median(TestStats[,"Consistency Index"]), col ="deepskyblue3", lty=2, lwd =2)


hist(TestStats[,"Retention Index"],  col = "gray74", border = "white", xlim = c(0,1), xlab = "Retention Index", main ="")
abline(v=empri, col ="forest green", lty=2 ,lwd =2)
abline(v=median(TestStats[,"Retention Index"]), col ="deepskyblue3", lty=2, lwd =2)





##########################
#                        #
# Calculate effect sizes #
#                        #
##########################

for (n in 1:2){
  if (n == 1){
    
    Std <- sd(TestStats[,"Consistency Index"])
    
    Effect_Size <- c()
    for (j in 1:length(TestStats[,1])){
      
      ES <- (empci - TestStats[j,"Consistency Index"] ) / Std 
      Effect_Size <- rbind(Effect_Size, ES)
      
    } 
    x <- boxplot(Effect_Size, main ="Consistency Index")
    abline(h=0, lty = 2)
    
  } else if (n == 2) {
    
    Std <- sd(TestStats[,"Retention Index"])
    
    Effect_Size <- c()
    for (j in 1:length(TestStats[,1])){
      
      ES <- (empci - TestStats[j,"Retention Index"] ) / Std 
      Effect_Size <- rbind(Effect_Size, ES)
      
    } 
    y <- boxplot(Effect_Size, main = "Retention Index")
    abline(h=0, lty = 2)
    
  }
  
}

Results["Consistency Index", "Effect size"] <- x$stats[3,1]
Results["Consistency Index", "ES lower"] <- x$stats[1,1]
Results["Consistency Index", "ES upper"] <- x$stats[5,1]

Results["Retention Index", "Effect size"] <- y$stats[3,1]
Results["Retention Index", "ES lower"] <- y$stats[1,1]
Results["Retention Index", "ES upper"] <- y$stats[5,1]



######################
#                    #
# Calculate p-values #
#                    #
######################



pVal <- function(e,s){
  greaterThan <- 0
  lessThan <- 0
  Equal <- 0
  for (i in 1:length(s)){
    if (e < s[i]){
      greaterThan <- greaterThan + 1
    } else if (e > s[i]){
      lessThan <- lessThan + 1
    } else if (e == s[i]){
      Equal <- Equal + 1
    }
  }
  pvals <- cbind(greaterThan/length(s), lessThan/length(s), Equal/length(s))
  return(pvals)
  
}

pvalues <- pVal(empci, TestStats[,"Consistency Index"])
mid_p_values <- pvalues[2] + pvalues[3]*0.5
two_tailed_p_value <- 2*min(pvalues[2]+pvalues[3], pvalues[1]+pvalues[3])

Results["Consistency Index", "Lower-1-tailed"] <- pvalues[2]
Results["Consistency Index", "Upper-1-tailed"] <- pvalues[1]
Results["Consistency Index", "Two-tailed"] <- two_tailed_p_value
Results["Consistency Index", "Midpoint"] <- mid_p_values




pvalues <- pVal(empri, TestStats[,"Retention Index"])
mid_p_values <- pvalues[2] + pvalues[3]*0.5
two_tailed_p_value <- 2*min(pvalues[2]+pvalues[3], pvalues[1]+pvalues[3])

Results["Retention Index", "Lower-1-tailed"] <- pvalues[2]
Results["Retention Index", "Upper-1-tailed"] <- pvalues[1]
Results["Retention Index", "Two-tailed"] <- two_tailed_p_value
Results["Retention Index", "Midpoint"] <- mid_p_values

#write.csv(Results, "MorphoSim.csv")

dev.off()

