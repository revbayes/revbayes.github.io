{% section Inferring the Posterior Distribution for One Model | MCMC %}

Now that we've specified a header file and a template file, we'll want to run an MCMC to estimate the posterior distribution for our total-evidence analysis.
We do this by calling the `analysis/MCMC.Rev` module.
Let's look at this script line-by-line.

The first thing we'll want to do is decide how many runs to do, and how many generations to run for.
We'll do a burnin analysis, so we'll also need to decide how many burnin generations to run for, and how often to adjust the tuning parameters for MCMC proposals:
```R
# analysis settings
nruns    = 1
printgen = 10
nburnin  = 2000
ngen     = 20000
```

We'll also want to keep track of our MCMC analysis using monitors.
We'll use a screen monitor to log the progress to our screen, as well as a model monitor to keep track of model parameters, and file monitors to keep track of the full tree and the extant tree.
```R
# the monitors
monitors = VectorMonitors()
monitors.append( mnScreen(printgen = printgen) )
monitors.append( mnModel(filename  = output_filename + "params.log", printgen = printgen, exclude = ["F"]) )
monitors.append( mnFile(filename   = output_filename + "tree.trees", printgen = printgen, timetree) )
monitors.append( mnFile(filename   = output_filename + "extant_tree.trees", printgen = printgen, extant_tree) )
```
Note that these monitors make use of the `output_filename` that was constructed in our header file.
This ensures that, if we use a different model, we don't risk accidentally overwriting or losing track of our output files.

Next, we create a model object by providing at least one of our parameters.
The timetree is a natural choice because it will always be in the model (regardless of what model components we are using).
```R
# the model
mymodel = model(timetree)
```

Now, we create our MCMC analysis, which depends on our model, monitors and moves, as well as some information about how many runs to do, and how to combine the output files when we do multiple runs:
```R
# make the analysis
mymcmc = mcmc(mymodel, monitors, moves, nruns = nruns, combine = "mixed")
```

If we specified a burnin (`nburnin > 0`), we now run that part of the analysis.
This analysis will adjust MCMC proposals every `tuningInterval` iterations to improve the acceptance rates (to a target value of 23-44%).
We also print out the MCMC proposal information with `operatorSummary`, which tells us how often each proposal was accepted during the burnin phase.
```R
# run the burnin
if (nburnin > 0 ) {
  mymcmc.burnin(generations = nburnin, tuningInterval = 100)
  mymcmc.operatorSummary()
}
```

Now we are ready to run our MCMC analysis for `ngen` generations.
```R
# run the analysis
mymcmc.run(generations = ngen)
```

After the analysis completes, you'll want to create summary trees.
If you did more than one run (`nruns > 1`), you'll create one summary tree for each run as well as the combined runs.
We'll make maximum-clade-credibilty (MCC) trees, but you could also modify or extend this code to produce maximum _a posteriori_ (MAP) trees.
```R
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


&#9888; _**For the purposes of this tutorial, we'll assume these MCMC worked!
However, for your own analyses, you'll definitely want to make sure that your analyses converge and sample adequately from the posterior distribution.
See the [MCMC Diagnosis tutorial]({{site.baseurl}}{% link tutorials/convergence/index.md %}) for more details.**_

{% subsection Plotting the inferred tree %}

Congratulations! You've inferred a total-evidence-dated phylogeny!
You can plot this tree in `FigTree`, or use `RevGadgets` {% cite Tribble2022 %} to create a publication-quality figure.

We've provided some `RevGadgets` code for plotting this tree.
Boot up Rstudio (or your preferred R console), and check out the script `posterior_summary/plot_trees.R`.
The first thing we do is load `RevGadgets`.
```R
library(RevGadgets)
```
Now we make a variable that stores where the summary tree is located.
```R
# specify a tree file
treefile <- "output_MCMC/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/MCC_tree.tre"
```
Then we read the tree.
```R
# read the tree
tree <- readTrees(treefile)
```
Finally, we plot the tree using `plotFBDTree`.
```R
# plot the tree
p <- plotFBDTree(tree = tree, timeline = TRUE, tip_labels_italics = FALSE,
            tip_labels_remove_underscore = TRUE,
            geo_units = "periods",
            node_age_bars = TRUE, age_bars_colored_by = "posterior",
            label_sampled_ancs = TRUE,
            age_bars_color = rev(colFun(2))) +
  ggplot2::theme(legend.position=c(0.75, 0.4))
```
Adjust this plot as you please, then export it as a pdf (or other type of image) like so:
```R
pdf("figures/tree.pdf", width = 10, height = 8)
print(p)
dev.off()
```
which produces {% ref tree %}.

{% figure tree %}
<img src="files/figures/tree.png" width="80%" height="80%" />
{% figcaption %}
**The MCC tree inferred for Marattiales under a constant-rate FBD model, a strict molecular/morphological clock model, an HKY substitution model, and an Mk morphological model.**
The bars represent 95% posterior credible intervals for node ages.
The color of each bar indicates the posterior probability of the clade (for internal nodes), of being a tip (for fossil tips), or for being a sampled ancestor (for sampled ancestor nodes).
{% endfigcaption %}
{% endfigure %}

{% subsection Exercise: Comparing phylogenies estimated under different total-evidence models %}

Now that we've run one header file start-to-finish, it's time to start using other models.
This is where the header/template/module structure really pays off.
To specify a new model, we simply create a header file and a module file for the new model.

Let's modify our first header file, `headers/MCMC/strict_Mk.Rev` to use an uncorrelated lognormal relaxed molecular clock.
Duplicate this file and rename it `UCLN_Mk.Rev`.
Then, change the value of `mole_clock_model` like so:
```R
mole_clock_model = "UCLN"
```

{% aside The Uncorrelated Lognormal Molecular Clock Model %}

The uncorrelated lognormal (UCLN) relaxed molecular clock allows the rates of molecular evolution to vary among branches.
Each branch draws its rate from an underlying lognormal distribution with some mean and variance.
Since we don't know what the mean and variance are, we treat them as free parameters, place a prior on them, and estimate them from the data.
In the parlance of hierarchical modeling, we would the mean and standard deviation "hyperparameters" of the branch-rate prior.

We'll use the same prior on the mean as we used on the strict clock rate:
```R
# the UCLN morphological clock model
# REQUIRED: morph_branch_rates (either one value, or one value per branch)

# draw the log of the mean from a uniform distribution
mole_clock_rate_mean_log ~ dnUniform(-10, 1)
moves.append( mvSlide(mole_clock_rate_mean_log) )
mole_clock_rate_mean_log.setValue(-7)

# exponentiate to get the true mean
mole_clock_rate_mean := exp(mole_clock_rate_mean_log)
```
We also need to estimate the standard deviation of this lognormal clock model.
We use an exponential distribution with a mean value of `H`, which means we expect molecular rates to vary over branches by about an order of magnitude.
Using an exponential prior here lets the standard deviation more easily shrink to zero, which corresponds to a strict molecular clock.
```R
# draw the standard deviation from an exponential
mole_clock_rate_sd ~ dnExponential(abs(1 / H))
moves.append( mvScale(mole_clock_rate_sd) )
```

Now that we have the mean and standard deviation, we'll draw each branch rate from the corresponding lognormal prior.
We draw these on the log scale, then exponentiate (just as we did with the mean):
```R
# the branch-specific rates
for(i in 1:nbranch) {

  # draw the log of the rate
  mole_branch_rates_log[i] ~ dnNormal(mole_clock_rate_mean_log - mole_clock_rate_sd * mole_clock_rate_sd * 0.5, mole_clock_rate_sd)
  moves.append( mvSlide(mole_branch_rates_log[i]) )
  mole_branch_rates_log[i].setValue(mole_clock_rate_mean_log - mole_clock_rate_sd * mole_clock_rate_sd * 0.5)

  # exponentiate to get the rate
  mole_branch_rates[i] := exp(mole_branch_rates_log[i])

}
```
We keep track of the mean rate among branches for use with the linked morphological clock model:
```R
# the mean of the branch rate
mole_branch_rate_mean := mean(mole_branch_rates)
```

Because we parameterized the log of the branch rates, we can use very nice proposals on the branch rates that simultaneously update the mean and variance of the lognormal distribution:
```R
# add a joint move on the branch rates and hyperparameters
moves.append( mvVectorSlideRecenter(mole_branch_rates_log, mole_clock_rate_mean_log) )
moves.append( mvShrinkExpand(mole_branch_rates_log, mole_clock_rate_sd) )
```

{% endaside %}

Note that the output filename will automatically be updated to reflect the change in model!
Also, since we're still using the linked morphological clock, this model allows morphological branch rates to vary among branches (in proportion to the molecular branch rates).

Now, prepare header files by duplicating and modifying the `strict_Mk.Rev` header file, and run the following analyses:
1. A strict clock/Mk model (the first analyses we ran).
2. The same as 1, but with an uncorrelated relaxed molecular clock (the modified header file we just made).
3. An uncorrelated exponential relaxed molecular clock.
4. An uncorrelated lognormal relaxed molecular clock, with an F81 mixture model among morphological characters.
5. A model with rates of diversification and fossilization that vary among epochs (but is otherwise the same as `strict_Mk.Rev`).

&#9888; These header files are already provided for you as `headers/MCMC`, but it's good practice to create your own header files to get a sense of how everything fits together.

To perform these analyses, you'll need to use the following module files:

{% aside The Uncorrelated Exponential Relaxed Molecular Clock %}

This relaxed clock model has a single parameter: the mean rate of evolution among branches.
The branch-rates then follow an exponential distribution with the specified mean.
The logic is otherwise similar to the UCLN model.
This model is defined in `modules/mole_clock_models/UCE.Rev`

```R
# the UCE clock model
# REQUIRED: mole_branch_rates (either one value, or one value per branch), mole_branch_rate_mean

# draw the log of the mean from a uniform distribution
mole_clock_rate_mean_log ~ dnUniform(-10, 1)
moves.append( mvSlide(mole_clock_rate_mean_log) )
mole_clock_rate_mean_log.setValue(-7)

# exponentiate to get the true mean
mole_clock_rate_mean := exp(mole_clock_rate_mean_log)

# the branch-specific rates
for(i in 1:nbranch) {

  # draw the log of the rate
  mole_branch_rates_log[i] ~ dnLogExponential(1 / mole_clock_rate_mean)
  moves.append( mvSlide(mole_branch_rates_log[i]) )

  # exponentiate to get the rate
  mole_branch_rates[i] := exp(mole_branch_rates_log[i])

}

# the mean of the branch rate
mole_branch_rate_mean := mean(mole_branch_rates)

# add a joint move on the branch rates and hyperparameters
moves.append( mvVectorSlideRecenter(mole_branch_rates_log, mole_clock_rate_mean_log) )
```

{% endaside %}

{% aside The F81 Mixture Model %}

The _Mk_ model assumes that relative transition rates are the same among all character states.
For binary characters, _F81_ assumes that each character state has a stationary frequency, $\pi$, that is estimated from the data.
This stationary frequency reflects the tendency for the character to evolve toward one state or the other.
While this model may be appropriate for a single character, it is difficult to justify for many characters because the state labels are arbitrary (0 and 1 don't have the same meaning for all characters), and the process of evolution is certainly very different among characters.

We therefore use a relaxed version of the F81 model, called an F81 mixture model, that allows the stationary frequency to vary among characters.
We draw a set of stationary frequencies from a discretized Beta distribution, and average the likelihood of each character over all possible stationary frequencies.
We define a shape parameter, $\alpha$, that describes how much variation there is among characters.
When $\alpha < 1$, that means that, on average, character evolution is ery biased; conversely, when $\alpha > 1$, character evolution tends to be balanced (0 -> 1 rates and 1 -> 0 rates are more similar.)
Please see the [morphological phylogenetics tutorial]({{site.baseurl}}{% link tutorials/morph_tree/index.md %}) for more details of this model.

Here's how we specify this model in RevBayes:
```R
# the F81 mixture model of morphological evolution
# REQUIRED: morph_Q (either one, or one per mixture category), morph_site_rates, site_matrices (TRUE or FALSE)

# process variation among characters
num_pi_cats_morph = 4

morph_pi_alpha ~ dnExponential(1)
moves.append( mvScale(morph_pi_alpha) )

morph_pis := fnDiscretizeBeta(morph_pi_alpha, morph_pi_alpha, num_pi_cats_morph)

for(i in 1:num_pi_cats_morph) {
  morph_pi[i] := simplex([ abs(morph_pis[i]), abs(1.0 - morph_pis[i])])
  morph_Q[i]  := fnF81(morph_pi[i])
}

# relative rates among characters
morph_site_rates <- [1.0]

# make sure we don't use site matrices
site_matrices = TRUE
```
Note that this model (as defined above) assumes that the _overall rate of evolution_ is the same among characters (`morph_site_rates <- [1.0]`).
We could relax this assumption, for example, by allowing rates to vary among characters according to a Gamma distribution (analogous to the ${+}\Gamma$ model of molecular evolution.
Check out the `modules/morph_models/MkG.Rev` model for an example of how to specify the discrete Gamma model.
Note that the discrete Gamma and F81 mixture model can be combined!
But to do that, you'd have to write a new module file, like `F81MixG.Rev`!
We'll leave that one to you :)

{% endaside %}

{% aside The Epochal FBD Model %}

The fossilized birth-death model can easily accommodate diversification (speciation and extinction) and/or fossilization-rate variation over time.
In our analyses, we'll assume (for convenience) that these rates are different among different geological epochs, though you could use any time intervals you like by modifying the `data/epoch_timescale.csv` file.

In this example, we'll let both diversification and fossilization rates to vary.
Let's look at the epoch-variable diversification model in `modules/diversification_models/epochal.Rev`.
Rather than letting each epoch have an independent rate, we'll simplify things by assuming there are three rate categories, and try to infer which rate category each epoch belongs to.
We begin by specifying the prior on the diversification rates per epoch.
As with the constant-rate model, we use an empirical approach to specify the mean.
```R
# the epochal diversification model
# REQUIRED: lambda, mu (both one per time interval)

# empirical prior on the diversification rate
diversification_prior_mean <- ln(total_taxa) / origin_time
diversification_prior_sd   <- H

# the diversitication rate
diversification_prior = dnLognormal( ln(diversification_prior_mean) - diversification_prior_sd * diversification_prior_sd * 0.5, diversification_prior_sd)
```
Note that we create a prior distribution object (`diversification_prior`) rather than a parameter here!

We do the same thing for the relative-extinction rate:
```R
# empirical prior on the relative-extinction rate
relext_prior_mean <- 1.0
relext_prior_sd   <- H

# the relative extinction rate
relext_prior = dnLognormal( ln(relext_prior_mean) - relext_prior_sd * relext_prior_sd * 0.5, relext_prior_sd)
```
We let this distribution have a prior mean of 1, because it's possible that the extinction rate is higher or lower than the speciation rate for some epochs.

Now we specify how many categories to use.
We'll keep it simple and use three categories.
```R
# specify the mixture model
num_div_cats = 3
```

We now draw the diversification and relative-extinction rates for each category.
```R
# draw the rates for each category
for(i in 1:num_div_cats) {
  diversification_rate_cat[i] ~ diversification_prior
  moves.append( mvScale(diversification_rate_cat[i]) )
}

# draw the rates for each category
for(i in 1:num_div_cats) {
  relext_rate_cat[i] ~ relext_prior
  moves.append( mvScale(relext_rate_cat[i]) )
}
```

Some categories may include more epochs than others.
We therefore want to let the different categories have different "weights", or prior probabilities that any given epoch is drawn from that category.
Again we do this separately for diversification and relative-extinction rates.
```R
# draw the mixture weights for each category
div_mixture_weights ~ dnDirichlet(rep(1, num_div_cats))
moves.append( mvBetaSimplex(div_mixture_weights, weight = 1.0) )
moves.append( mvElementSwapSimplex(div_mixture_weights, weight = 1.0) )

# draw the mixture weights for each category
relext_mixture_weights ~ dnDirichlet(rep(1, num_div_cats))
moves.append( mvBetaSimplex(relext_mixture_weights, weight = 1.0) )
moves.append( mvElementSwapSimplex(relext_mixture_weights, weight = 1.0) )
```

Now that we've defined the rate categories, we draw each epoch rate from the rate categories (using a mixture distribution, i.e., a model that says the rate for an epoch takes one of a set of values with some probability):
```R
# draw the rates for each epoch
for(i in 1:(breakpoints.size() + 1)) {

	# diversification rate
  diversification[i] ~ dnMixture(diversification_rate_cat, div_mixture_weights)
  moves.append( mvMixtureAllocation(diversification[i], weight = 1.0) )

  # relative-extinction rate
  relext[i] ~ dnMixture(relext_rate_cat, relext_mixture_weights)
  moves.append( mvMixtureAllocation(relext[i], weight = 1.0) )

}
```

Finally, we transform the diversification and relative-extinction rates into speciation and extinction rates.
```R
# transform to real parameters
lambda := abs(diversification / (1 - relext))
mu     := abs(lambda * relext)
```

To allow fossilization rates to vary, we basically repeat this process but for the `psi` parameter.
See the `modules/fossilization_models/epochal.Rev` model for the code.

{% endaside %}

After running the analyses, plot the summary tree for each analysis.
Do divergence-time estimates vary among models?
How about posterior probabilities for tree topologies or tip/sampled-ancestor relationships?

It may be difficult or impossible to get a good sense of how these inferences vary by eye-balling the tree.
In the next section, we'll explore some more useful ways of exploring the impact of model choice on our estimates.


<!--  -->
