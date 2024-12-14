{% subsection Exercise 1 %}
- Run an MCMC simulation to estimate the posterior distribution of the OU optimum (`theta`).
- Load the generated output file into `RevGadgets`: What is the mean posterior estimate of `theta` and what is the estimated HPD?
- Use `R` to compare the joint posterior distributions of `alpha` and `sigma2`. Are these parameters correlated or uncorrelated?
- Compare the prior mean with the posterior mean. (**Hint:** Call the `.ignoreAllData()` method on the model object to ignore data at clamped nodes.) Are prior and posterior different (*e.g.,* {% ref fig_prior_posterior %})? Is the posterior mean outside the prior 95% probability interval?
