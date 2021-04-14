{% subsection Exercise 1 %}
- Run an MCMC simulation to sample the posterior distribution of the BM rate (`sigma2`).
- Run an MCMC simulation to sample the _prior_ distribution of the BM rate (**Hint:** You can run an analysis under the prior using the script `scripts/mcmc_BM_prior.Rev`).
- Compare the posterior and the prior using `RevGadgets`:

First, we need to load the R package `RevGadgets`
```{R}
library(RevGadgets)
```

Next, read in the MCMC output from the posterior and the prior:
```{R}
simple_BM_posterior <- readTrace("output/simple_BM.log")[[1]]
simple_BM_prior     <- readTrace("output/simple_BM_prior.log")[[1]]
```

Next, add the samples of `sigma2` from the prior to the posterior (and rename them to `sigma2_prior`):
```{R}
simple_BM_posterior$sigma2_prior <- simple_BM_prior$sigma2
```

Finally, we plot the prior and posterior distributions:
```{R}
plotTrace(list(simple_BM_posterior), vars=c("sigma2", "sigma2_prior"))
```

{% figure fig_prior_posterior %}
<img src="figures/sigma_prior_posterior.png" height="75%" width="75%" />
{% figcaption %}
Estimates of the posterior (blue) and prior (red) distribution of the `sigma2` visualized in `RevGadgets`.
{% endfigcaption %}
{% endfigure %}

>You can also find all these commands in the file called **plot_BM.R** which you can run as a script in R.
{:.instruction}
