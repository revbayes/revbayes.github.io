{% subsection Exercise 1 %}
- Run an MCMC simulation to estimate the posterior distribution of the OU optimum (`theta`).
- Load the generated output file into `Tracer`: What is the mean posterior estimate of `theta` and what is the estimated HPD?
- Use `Tracer` to compare the joint posterior distributions of `alpha` and `sigma2`. Are these parameters correlated or uncorrelated?
- Compare the prior mean with the posterior mean. (**Hint:** Use the optional argument `underPrior=TRUE` in the function `mymcmc.run()`) Are they different (*e.g.,* {% ref fig_prior_posterior %})? Is the posterior mean outside the prior 95% probability interval?
