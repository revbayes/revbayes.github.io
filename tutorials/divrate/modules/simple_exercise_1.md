{% subsection Exercise 1 %}
-   Run an MCMC simulation to estimate the posterior distribution of the
    speciation rate (`birth_rate`).
-   Load the generated output file into `Tracer`: What is
    the mean posterior estimate of the `birth_rate` and what is the
    estimated HPD?
-   Compare the prior mean with the posterior mean. (**Hint:** Use the
    optional argument `underPrior=TRUE` in the function `mymcmc.run()`)
    Are they different (*e.g.,* {% ref fig_prior_posterior %})?
    Is the posterior mean outside the prior 95% probability interval?
-   Repeat the analysis and allow for two orders of magnitude of
    prior uncertainty.

{% figure fig_prior_posterior %}
<img src="figures/birth_rate_prior_posterior.png" height="50%" width="50%" /> 
{% figcaption %} 
Estimates of the
posterior and prior distribution of the `birth_rate` visualized in
`Tracer`. The prior (black curve) shows the lognormal
distribution that we chose as the prior distribution.
{% endfigcaption %}
{% endfigure %}
