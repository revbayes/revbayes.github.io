{% section Controlling for Background-Rate Variation %}

The previous models have assumed that, aside from rate variation owing to the state of the discrete character, rates of continuous-character evolution are stochastically constant. We might therefore be worried that inferences about state-dependent rates of evolution might be mislead if rates of evolution vary for reasons other than the focal discrete character, which we call ''background-rate variation'' {% cite Rabosky2015 Beaulieu2016 May2019 %}.

The state-dependent model allows us to easily build in these alternative sources of rate variation. In this case, we simply relax the assumption that the ''average'' rate is constant by applying a relaxed morphological clock prior model on $\beta^2$, as described in {% page_ref cont_traits/relaxed_bm %}.

&#8680; The state-dependent BM-model with background rate variation is specified in the file called `mcmc_relaxed_state_dependent_BM.Rev`. The majority of this script is the same as `mcmc_state_dependent_BM.Rev`, except as described below.

{% subsection Relaxing the background-rate of evolution %}

To specify the relaxed background-rate model, we specify the background rate at the root of the tree, $\beta^2_R$.
```
beta_root ~ dnLoguniform(1e-3, 1)
moves.append( mvScale(beta_root, weight=1.0) )
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
Then we draw the rate multiplier from each branch from a `dnReversibleJumpMixture` distribution, and compute the background-rate of evolution for each branch.
```
for(i in nbranches:1) {

    # draw the rate multiplier from a mixture distribution
    branch_rate_multiplier[i] ~ dnReversibleJumpMixture(1, rate_shift_distribution, Probability(1 - rate_shift_probability) )

    # compute the rate for the branch
    if ( tree.isRoot( tree.parent(i) ) ) {
       background_rates[i] := beta_root * branch_rate_multiplier[i]
    } else {
       background_rates[i] := background_rates[tree.parent(i)] * branch_rate_multiplier[i]
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

Later, when we compute the branch-rates for the `dnPhyloBrownianREML` distribution, we simply multiply the state-dependent branch rates by the background branch-rates.
```
branch_rates := state_branch_rate * background_rates
```
and then provide these rates to `dnPhyloBrownianREML`.
```
Y ~ dnPhyloBrownianREML(tree, branchRates=branch_rates^0.5)
```

&#8680; The `Rev` file for performing this analysis: `mcmc_relaxed_state_dependent_BM.Rev`

You can then visualize the branch-specific rates by plotting them using our `R` package `RevGadgets`. Importantly, these plots allow you to tease apart the relative contributions of background- and state-dependent-rate variation to overall patterns of rate variation across the tree. Just start R in the main directory for this analysis and then type the following commands:
```R
library(RevGadgets)

my_tree <- read.nexus("data/haemulidae.nex")
my_output_file <- "output/relaxed_state_dependent_BM.log"

background_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                                  output_file    = my_output_file,
                                                  parameter_name = "background_rates")

state_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                             output_file    = my_output_file,
                                             parameter_name = "state_branch_rate")

overall_plot <- plot_relaxed_branch_rates_tree(tree           = my_tree,
                                               output_file    = my_output_file,
                                               parameter_name = "branch_rates")

pdf("relaxed_state_dependent_BM.pdf", height=5, width=15)
grid.arrange(state_plot, background_plot, overall_plot, nrow=1)
dev.off()
```

{% figure fig_state_dependent_relaxed_BM %}
<img src="figures/relaxed_state_dependent_BM.png" width="100%" height="100%" />
{% figcaption %}
**Estimated rates of Brownian-motion evolution with state-dependent and background-rate variation.**
Left) We show the state-dependent rates of continuous-character evolution, indicating that increased rates are strongly associated with living in reefs. Middle) We show the background rates of continuous-character evolution, indicating mild rate variation that cannot be attributed to the state of the discrete character. Right) We show the combined effect of state-dependent and state-independent sources of rate variation.
{% endfigcaption %}
{% endfigure %}


<!--  -->
