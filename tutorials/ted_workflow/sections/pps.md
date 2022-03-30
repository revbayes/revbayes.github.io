{% section Assessing Model Adequacy with Posterior-Predictive Simulation | posterior_prediction %}

In addition to comparing the _relative fit_ of competing models using Bayes factors, we may wish to assess whether a given model (perhaps the best fit model) provides an adequate description of the true process that give rise to our data, sometimes called "model adequacy".
This may be particularly important for morphological data, since we may be especially skeptical that our models of morphological evolution can provide a realistic description of the process of morphological evolution.
We will use posterior-predictive simulation to assess model adequacy, as described in the [P^3 tutorial]({{site.baseurl}}{% link tutorials/model_testing_pps/pps_data.md %}).

The basic idea of posterior-predictive simulation is to ask: if we simulate data from our model, does that data resemble our observed data (in some quantifiable way)?
A model that is adequate will be able to simulate datasets that resemble our observed dataset, while an inadequate model will simulate datasets that do not resemble our observed data.
We capture the notion of "resemblance" by computing a statistic for a dataset, and looking at the distribution of that statistic computed over simulated datasets compared to the same statistic computed on our observed dataset.

To simulate a single dataset from our model, we take one sample from our posterior distribution, and forward simulate a character dataset given the parameters of that sample from the posterior.
We repeat this procedure many times (e.g., one per posterior sample) to generate a posterior-predictive distribution of simulated datasets, then compute our statistic for each simulated dataset.

We can compute compute a posterior-predictive _p_-value as the fraction of simulated statistics that are greater than the observed statistic:

$$
\begin{equation*}
P = \frac{1}{n} \sum_{i=1}^n T(X^\text{sim}_i) > T(X^\text{obs})
\end{equation*}
$$

where $n$ is the number of simulated datasets, $T(X)$ is our test statistic, $X^\text{\sim}_i$ is the $i^\text{th}$ simulated dataset, and $X^\text{obs}$ is the observed dataset.
Note that this is the same as subtracting the simulated and observed statistics, and then computing the fraction of these differences that is larger than zero:

$$
\begin{equation*}
P = \frac{1}{n} \sum_{i=1}^n \left[ T(X^\text{sim}_i) - T(X^\text{obs}) \right] > 0
\end{equation*}
$$

A _p_-value greater than $$1 - \alpha \div 2$$ or less than $$\alpha \div 2$$ indicates model inadequacy at the critical value of $$\alpha$$.
For example, a _p_ value greater than 0.975 or less than 0.025 indicates inadequacy at the $\alpha = 0.05$ level.

There are many statistics one could consider using, and which statistics are best at diagnosing inadequacy is discussion.
In this tutorial, we'll recreate the statistics we used in {% cite May2021 %}: the total parsimony score among discrete morphological characters (intended to characterize whether the model adequately describes overall rates of morphological evolution), and the variance in parsimony scores among characters (intended to characterize whether the model adequately describes how the process varies among characters).

{% subsection Simulating the Posterior-Predictive Datasets %}

Similar to the power-posterior analysis we'll create a new posterior-predictive analysis script (called `modules/analysis/PPS.Rev`) for simulating morphological character datasets from our posterior distribution.
Let's look at this analysis line-by-line.

The first step of the posterior-predictive analysis is a fairly standard MCMC run, as we implemented in `modules/analysis/MCMC.Rev`.
As usual, we first decide how many runs to do, how many generations to run the MCMC for, etc.
```R
# analysis settings
nruns    = 1
printgen = 10
nburnin  = 2000
ngen     = 20000
```

We then specify our model monitors; in this case, we're including an additional monitor, `mnStochasticVariable`, that keeps track of all the model parameters in one file to be used to generate the posterior simulations.
```R
# the monitors
monitors = VectorMonitors()
monitors.append( mnScreen(printgen = printgen) )
monitors.append( mnModel(filename = output_filename + "params.log", printgen = printgen, exclude = ["F"]) )
monitors.append( mnFile(filename  = output_filename + "tree.trees", printgen = printgen, timetree) )
monitors.append( mnFile(filename  = output_filename + "extant_tree.trees", printgen = printgen, extant_tree) )
monitors.append( mnStochasticVariable(filename = output_filename + "stoch.var", printgen = printgen) )
```

Next, we make our model and MCMC analysis, then run the chain and create a summary tree.
We'll hide this code behind a fold because we've already seen in before in our MCMC analyses.

{% aside Running the MCMC analysis %}

```R
# the model
mymodel = model(timetree)

# make the analysis
mymcmc = mcmc(mymodel, monitors, moves, nruns = nruns)

# run the burnin
if (nburnin > 0 ) {
  mymcmc.burnin(generations = nburnin, tuningInterval = 100)
  mymcmc.operatorSummary()
}

# run the analysis
mymcmc.run(generations = ngen)

# make the summary trees
if ( nruns == 1 ) {

  # just make summary trees for the one run
  full_trees = readTreeTrace(output_filename + "tree.trees", "clock")
  mccTree(full_trees, output_filename + "MCC_tree.tre")

  extant_trees = readTreeTrace(output_filename + "extant_tree.trees", "clock")
  mccTree(extant_trees, output_filename + "MCC_extant_tree.tre")

} else {

  # make a combined summary tree
  full_trees = readTreeTrace(output_filename + "tree.trees", "clock")
  mccTree(full_trees, output_filename + "MCC_tree.tre")

  extant_trees = readTreeTrace(output_filename + "extant_tree.trees", "clock")
  mccTree(extant_trees, output_filename + "MCC_extant_tree.tre")

  # and run-specific summary trees
  for(i in 1:nruns) {
    full_trees = readTreeTrace(output_filename + "tree_run_" + i + ".trees", "clock")
    mccTree(full_trees, output_filename + "MCC_tree_run_" + i + ".tre")

    extant_trees = readTreeTrace(output_filename + "extant_tree_run_" + i + ".trees", "clock")
    mccTree(extant_trees, output_filename + "MCC_extant_tree_run_" + i + ".tre")
  }

}
```

{% endaside %}

Now we read in the posterior samples and simulate our posterior-predictive datasets:
```R
# read in the posterior samples
trace = readStochasticVariableTrace(output_filename + "stoch.var")

# setup the PPS simulations
pps = posteriorPredictiveSimulation(mymodel, directory = output_filename + "/simulations", trace)

# run the PPS simulations
pps.run()
```
(Note that we're reading in the stochastic variable trace created by `mnStochasticVariable`.)
The `pps.run()` command will generate one simulated dataset per MCMC sample, and write them in the `/simulations` subdirectory.

We repeat this procedure for each model under consideration, though in principle we can do model adequacy with a single model!
We provide the analysis headers in `headers/PPS`---these are the same models we have used in our previous sections.

{% subsection Summarizing Posterior-Predictive Simulations %}

Now that we've simulated our datasets for each model, it's time to move to `R` to compute our statistics and compute posterior-predictive _p_-values.
(This code is provided in the script `posterior_summary/PPS.R`)
We begin by loading the required packages:
```R
library(RevGadgets)
source("posterior_summary/utils.R")
```

Next, we read in our observed morphological dataset.
```R
# read the observed data
data_file <- "data/morpho.nex"
data      <- readMorphoData(data_file)
```

Now, we specify the output directories for each of our posterior-predictive analyses.
```R
# specify the output directory for each model
output_strict_Mk   <- "output_PPS/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_PPS_run_01/"
output_UCLN_Mk     <- "output_PPS/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_PPS_run_01/"
outout_UCE_Mk      <- "output_PPS/div_constant_foss_constant_moleclock_UCE_moleQ_HKY_morphclock_linked_morphQ_Mk_PPS_run_01/"
output_UCLN_F81Mix <- "output_PPS/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_F81Mix_PPS_run_01/"
```

Next, we read in the simulated morphological datasets with `readMorphoPPS`:
```R
# read the output files
samples_strict_Mk   <- readMorphoPPS(output_strict_Mk)
samples_UCLN_Mk     <- readMorphoPPS(output_UCLN_Mk)
samples_UCE_Mk      <- readMorphoPPS(outout_UCE_Mk)
samples_UCLN_F81Mix <- readMorphoPPS(output_UCLN_F81Mix)
```

Now, we compute the posterior-predictive statistics with `processMorphoPPS`:
```R
# compute the statistics
stats_strict_Mk   <- processMorphoPPS(data, samples_strict_Mk)
stats_UCLN_Mk     <- processMorphoPPS(data, samples_UCLN_Mk)
stats_UCE_Mk      <- processMorphoPPS(data, samples_UCE_Mk)
stats_UCLN_F81Mix <- processMorphoPPS(data, samples_UCLN_F81Mix)
```

By default, this function will compute the parsimony-sum and parsimony-variance statistics, as described in {% citet May2021 %}.
You can also make your own user-defined statistics.
However, this may take a bit of work, which you may only want to do if you're a fairly advanced `R` user.

{% aside Advanced: User-Defined Test Statistics %}

There is a hidden `statistics` argument to the `processMorphoPPS` function.
This argument accepts a list with elements that are either names of default statistics (which can be `"Parsimony Sum"` or `"Parsimony Variance"`), or functions.
You can provide any user defined function which has arguments `tree`, `observed_data`, and `simulated_data`.
The `tree` argument should expect to receive the tree that was used to simulate a particular dataset; the `observed_data` object expects a matrix object with named rows for species, and numeric values for character stats in columns.

For example, we can look at the internal `parsimony_sum` statistic to see how the function should work.
This function translates the provided datasets to the `phangorn` format `phyDat`, then computes the parsimony scores using the `phangorn` function `parsimony`.
It then computes the statistic as the difference in parsimony scores between the simulated and observed datasets.
```R
parsimony_sum <- function(tree, observed_data, simulated_data) {

  # get the state space
  all_chars <- as.vector(observed_data)
  all_chars <- all_chars[all_chars %in% c("?","-") == FALSE]
  states    <- sort(unique(all_chars))

  # transform to phyDat for phangorn
  observed_phydat  <- phyDat(observed_data, type = "USER", levels = states)
  simulated_phydat <- phyDat(simulated_data, type = "USER", levels = states)

  # compute the parsimony scores for the observed and simulated data
  observed_statistic  <- sum(parsimony(tree, observed_phydat, site="site"))
  simulated_statistic <- sum(parsimony(tree, simulated_phydat, site="site"))

  # compute the statistic
  statistic <- simulated_statistic - observed_statistic
  return(statistic)

}
```

This function should serve as a template for any new statistics you choose to implement.

{% endaside %}

We've now computed all of our posterior-predictive statistics.
It's time to plot the posterior-predictive distributions and _p_-values!
There are several ways to do this, but one easy way is to plot the posterior-predictive distributions as boxplots and annotate them with _p_-values using `boxplotPostPredStats`:
```R
pdf("figures/pps.pdf", height = 10)
print(boxplotPostPredStats(combined_stats))
dev.off()
```
which produces {% ref posterior_predictive_figure %}.
For this example dataset and these models, all of the models appear to adequately describe the process of morphological evolution!
However, we should not expect this to be a general result: different datasets will behave differently, and the example dataset we are using is quite small and may not provide enough information to diagnose inadequacy.

{% figure posterior_predictive_figure %}
  <img src="files/figures/pps.png" width="50%" height="50%" />
  {% figcaption %}
  **Posterior-predictive distributions of parsimony-sum and parsimony-variance statistics under each model.**
  Since we've subtracted the observed statistic from the simulated statistic, the posterior-predictive _p_-value is the fraction of statistics that are greater than 0.
  In this case, all of the models appear to be adequate at the $\alpha = 0.05$ level: all of the distributions overlap with 0, and none of the _p_-values are less than 0.025 or greater than 0.975.
  {% endfigcaption %}
{% endfigure %}
