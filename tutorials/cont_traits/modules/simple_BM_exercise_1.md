{% subsection Exercise 1 %}
- Run an MCMC simulation to estimate the posterior distribution of the BM rate (`sigma`).
- Load the generated output file into `Tracer`: What is the mean posterior estimate of `sigma` and what is the estimated HPD?
- Compare the prior mean with the posterior mean. (**Hint:** Use the optional argument `underPrior=TRUE` in the function `mymcmc.run()`) Are they different (*e.g.,* {% ref fig_prior_posterior %})? Is the posterior mean outside the prior 95% probability interval?
- Repeat the analysis with a loguniform prior ranging from $1e-10$ to $1e10$.

{% figure fig_prior_posterior %}
<img src="figures/sigma_prior_posterior.png" height="50%" width="50%" />
{% figcaption %}
Estimates of the posterior and prior distribution of the `sigma` visualized in
`Tracer`. The prior (green curve) shows the loguniform
distribution that we chose as the prior distribution.
{% endfigcaption %}
{% endfigure %}
