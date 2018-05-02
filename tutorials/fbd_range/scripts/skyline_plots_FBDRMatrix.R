library(coda)
library(ggplot2)

# read mcmc output

# model 1
mcmc = read.table("../output/old/model1.log", header = TRUE)

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
   
  


