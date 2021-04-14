library(RevGadgets)
library(gridExtra)

# read the samples
samples <- readTrace("output/simple_OU.log")

# create the plots
alpha_plot <- plotTrace(samples, vars="alpha")[[1]]
theta_plot <- plotTrace(samples, vars="theta")[[1]]
sigma_plot <- plotTrace(samples, vars="sigma2")[[1]]

# plot the posterior distributions
pdf("ou_posterior.pdf", width=12, height=4)
grid.arrange(alpha_plot, theta_plot, sigma_plot, nrow=1)
dev.off()

# plot the joint distribution of theta and sigma2
library(ggplot2)

pdf("ou_joint_posterior.pdf", height=4, width=4)
ggplot(samples[[1]], aes(x=alpha, y=sigma2)) + geom_point()
dev.off()
