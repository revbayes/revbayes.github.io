{% section Variable Rates Among Lineages %}

In the previous section, we assumed that the average rate of evolution was the same across all of the branches in the phylogeny. However, if you have followed the {% page_ref cont_traits/state_dependent_bm %} tutorial, you are probably aware that this dataset demonstrates variation in rates of evolution among lineages.

We can relax the assumption that the average rate of evolution is constant across branches the same way that we did for univariate Brownian motion models (see {% page_ref cont_traits/relaxed_bm %}). Importantly, this tutorial assumes that the relative rates among characters and the correlation matrix are shared among all branches. Otherwise, we can simply rely on the ''random local clock'' model that we used in the relaxed univariate tutorial.

&#8680; The relaxed mvBM-model is specified in the file called `mcmc_relaxed_multivariate_BM.Rev`. The majority of this script is the same as `mcmc_multivariate_BM.Rev`, except as described below.


{% subsection Relaxing the morphological clock %}

To specify the relaxed morphological clock, we simply modify the component of the model that controls the average rate, $\sigma^2$. We specify the average rate at the root of the tree, $\sigma_R^2$.
```
sigma2_root ~ dnLoguniform(1e-3, 1)
moves.append( mvScale(sigma2_root, weight=1.0) )
```
Next, we specify the prior on the expected number of rate shifts.
```
expected_number_of_shifts <- 5
rate_shift_probability    <- expected_number_of_shifts / nbranches
```
We must also specify the prior on the magnitude of rate shifts (when they occur). This prior supposes that rate shifts result in changes of rate within one order of magnitude.
```
sd = 0.578
rate_shift_distribution = dnLognormal(-sd^2/2, sd)
```
Then we draw the rate multiplier from each branch from a `dnReversibleJumpMixture` distribution, and compute the average rate of evolution for each branch.
```
for(i in nbranches:1) {

    # draw the rate multiplier from a mixture distribution
    branch_rate_multiplier[i] ~ dnReversibleJumpMixture(1, rate_shift_distribution, Probability(1 - rate_shift_probability) )

    # compute the rate for the branch
    if ( tree.isRoot( tree.parent(i) ) ) {
       branch_rates[i] := beta_root * branch_rate_multiplier[i]
    } else {
       branch_rates[i] := background_rates[tree.parent(i)] * branch_rate_multiplier[i]
    }

    # keep track of whether the branch has a rate shift
    branch_rate_shift[i] := ifelse( branch_rate_multiplier[i] == 1, 0, 1 )

    # use reversible-jump to move between models with and without
    # shifts on the branch
    moves.append( mvRJSwitch(branch_rate_multiplier[i], weight=1) )

    # include proposals on the rate mutliplier (when it is not 1)
    moves.append( mvScale(branch_rate_multiplier[i], weight=1) )

}
```
We may also wish to keep track of the total number of rate shifts.
```
num_rate_changes := sum( branch_rate_shift )
```
We then provide these relaxed branch rates to `dnPhyloMulivariateBrownianREML` instead of `sigma2`.
```
X ~ dnPhyloMultivariateBrownianREML(tree, branchRates=branch_rates^0.5, rateMatrix=V)
X.clamp(data)
```

&#8680; The `Rev` file for performing this analysis: `mcmc_relaxed_multivariate_BM.Rev`

You can then visualize the branch-specific rates by plotting them using our `R` package `RevGadgets`. Just start R in the main directory for this analysis and then type the following commands:
```R
library(RevGadgets)

my_tree <- read.nexus("data/haemulidae.nex")
my_output_file <- "output/relaxed_multivariate_BM.log"

tree_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                            output_file    = my_output_file,
                                            parameter_name = "branch_rates")

ggsave("relaxed_mvBM.pdf", width=15, height=15, units="cm")
```
{% figure fig_relaxed_multivariate_BM %}
<img src="figures/relaxed_mvBM.png" width="50%" height="50%" />
{% figcaption %}
**Estimated rates of multivariate-Brownian-motion evolution.**
We show the estimated average rate of evolution for each branch under the mvBM model.
{% endfigcaption %}
{% endfigure %}







<!--  -->
