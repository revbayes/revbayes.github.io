library(RevGadgets)

rev_out <- rev.process.div.rates(speciation_times_file ="output/model1_speciation_times.log", 
                                 speciation_rates_file="output/model1_speciation_rates.log", 
                                 extinction_times_file="output/model1_extinction_times.log",
                                 extinction_rates_file="output/model1_extinction_rates.log",
                                 fossilization_times_file="output/model1_sampling_times.log",
                                 fossilization_rates_file="output/model1_sampling_rates.log", 
                                 maxAge = 252-66, burnin=0.1,numIntervals=100)

rev_out$intervals = rev_out$intervals - 66

pdf("uniform.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out,fig.types=c("speciation rate", "extinction rate", "net-diversification rate","relative-extinction rate","fossilization rate"),use.geoscale=FALSE)
dev.off()






# read mcmc output

# model 1
mcmc = read.table("../output/model1.log", header = TRUE)

# define interval boundaries
tol = 0.01
timeline = c(66, 100-tol, 100, 145-tol, 145, 201-tol, 201, 252)

#timeline = c(66, 100, 145, 201)

# set this automatically
num_int = 4

# parse rates
lambda = data.frame(mean = numeric(), minHPD = numeric(), maxHPD = numeric())
mu = data.frame(mean = numeric(), minHPD = numeric(), maxHPD = numeric())
psi = data.frame(mean = numeric(), minHPD = numeric(), maxHPD = numeric())

for(i in num_int:1){
  
  tmp = mcmc[[paste0("lambda.",i,".")]]
  lambda = rbind(lambda, data.frame(mean = rep(mean(tmp),2), minHPD = HPDinterval(as.mcmc(tmp))[1], maxHPD = HPDinterval(as.mcmc(tmp))[2]))

  tmp = mcmc[[paste0("mu.",i,".")]]
  mu = rbind(mu, data.frame(mean = mean(tmp), minHPD = HPDinterval(as.mcmc(tmp))[1], maxHPD = HPDinterval(as.mcmc(tmp))[2]))
  
  tmp = mcmc[[paste0("psi.",i,".")]]
  psi = rbind(psi, data.frame(mean = mean(tmp), minHPD = HPDinterval(as.mcmc(tmp))[1], maxHPD = HPDinterval(as.mcmc(tmp))[2]))
  
}

lambda$x = -timeline
mu$x = -timeline
psi$x = -timeline


ggplot(lambda, aes(x)) + geom_line(aes(y = lambda$mean, x = lambda$x)) + 
  geom_ribbon(aes(ymin = lambda$minHPD, ymax = lambda$maxHPD), alpha = 0.3)


+
  geom_ribbon(aes(ymin = lambda$minHPD, ymax = lambda$maxHPD), alpha = 0.3)

ggplot(lambda, aes(x)) + geom_step(aes(y = lambda$mean, x = lambda$x)) +
  geom_smooth(aes(y = lambda$mean, ymin = lambda$minHPD, ymax = lambda$maxHPD), col = "red", stat="identity")
  
  
  geom_step(aes(y = lambda$minHPD, x = lambda$x), col = "red") +
  geom_step(aes(y = lambda$maxHPD, x = lambda$x), col = "red")
  
  


ggplot(aes(y = c(1,1,2,2), x = c(0.1,0.1,0.2,0.2))) + # + geom_point(aes(y = lambda$mean, x = lambda$x), colour = "blue") +
  geom_line()
   
  


