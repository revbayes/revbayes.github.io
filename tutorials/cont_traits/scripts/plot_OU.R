library(RevGadgets)
library(gridExtra)
library(ggplot2)

# read the samples
samples_OU        <- readTrace("output/simple_OU.log", burnin = 0.25)[[1]]
samples_OU_prior  <- readTrace("output/simple_OU_prior.log", burnin = 0.25)[[1]]

# combine the samples into one data frame
samples_OU$alpha_prior <- samples_OU_prior$alpha
samples_OU$theta_prior <- samples_OU_prior$theta
samples_OU$sigma2_prior <- samples_OU_prior$sigma2
samples_OU$t_half_prior <- samples_OU_prior$t_half
samples_OU$p_th_prior <- samples_OU_prior$p_th

samples = list(samples_OU)

# create the plots
alpha_plot <- plotTrace(samples, vars=c("alpha","alpha_prior"))[[1]] + theme(legend.position = c(0.25,0.81))
theta_plot <- plotTrace(samples, vars=c("theta","theta_prior"))[[1]] + theme(legend.position = c(0.25,0.81))
sigma_plot <- plotTrace(samples, vars=c("sigma2","sigma2_prior"))[[1]] + theme(legend.position = c(0.25,0.81))
t_half_plot <- plotTrace(samples, vars=c("t_half","t_half_prior"))[[1]] + theme(legend.position = c(0.25,0.81)) + scale_x_log10()
p_th_plot <- plotTrace(samples, vars=c("p_th","p_th_prior"))[[1]] + theme(legend.position = c(0.25,0.81))

# plot the posterior distributions
pdf("ou_posterior.pdf", width=20, height=4)
grid.arrange(alpha_plot, theta_plot, sigma_plot, p_th_plot, nrow=1)
dev.off()

# plot the joint distribution of theta and sigma2
library(ggplot2)

pdf("ou_joint_posterior.pdf", height=4, width=4)
ggplot(samples[[1]], aes(x=alpha, y=sigma2)) + geom_point()
dev.off()
