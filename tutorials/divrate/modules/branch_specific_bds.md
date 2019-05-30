{% section Estimating Branch-Specific Diversification Rates %}

In this analysis we are interested in estimating the branch-specific diversification rates.
We show how to implement and use the model developed by {% citet Hoehna2019 %}
We are going to use the `dnCBDP` distribution which uses a finite number of rate-categories
instead of drawing rates from a continuous distribution directly.

Here we adopt an approach using (few) discrete rate categories.
This allows us to numerically integrate over all possible rate categories using
a system of differential equations originally described by {% citet Maddison2007 %}
(see also {% citet FitzJohn2009 %} and {% citet FitzJohn2010 %}).
The numerical procedure breaks time into very small time intervals and sums
over all possible events occurring in that interval (see {% ref fig_likelihood %}).

{% figure fig_likelihood %}
<img src="figures/likelihood.png" width="100%" height="100%" />
{% figcaption %}
**Possible scenarios that could occur over the interval $\Delta t$ along a lineage that is observed at time $t$.**
To compute the probability under the birth-death-shift process, we traverse the tree from the tips to the root in small time steps, $\Delta t$.
For each step into the past, from time $t$ to time ($t+\Delta t$), we compute the change in probability of the observed lineage by enumerating all of the possible scenarios that could occur over the interval $\Delta t$:
    (*i*) nothing happens,
    (*ii*) a speciation event occurs, where the right descendant survives and the left descendant goes extinct before the present, or
    (*iii*) a speciation event occurs, where the left descendant survives but the right goes extinct before the present, or
    (*iv*) a diversification-rate shift from category $i$ to $j$ occurs.
Color key: segment(s) of the tree within the interval $\Delta t$ are colored blue for state $i$ and/or green for state $j$ to reflect the conditioning of the corresponding scenarios,
segment(s) of the tree between $t$ and the present are colored gray because we have integrated over the $k$ discrete rate categories (no specific assignment of rate categories), and
segments of the tree between $t+\Delta t$ and the root are colored gray because we will integrated over the $k$ discrete rate categories.
{% endfigcaption %}
{% endfigure %}

You don't need to worry about any of the technical details.
It is important for you to realize that this model assumes that new rates at a
rate-shift event are drawn from a given (discrete) set of rates (see {% ref fig_discretized_lognormal %}).

{% subsection Read the tree %}

Begin by reading in the observed tree.
```
observed_phylogeny <- readTrees("data/primates_tree.nex")[1]
```
From this tree, we can get some helpful variables:
```
taxa <- observed_phylogeny.taxa()
root <- observed_phylogeny.rootAge()
tree_length <- observed_phylogeny.treeLength()
```
Additionally, we initialize a variable for our vector of moves and monitors.
```
moves    = VectorMoves()
monitors = VectorMonitors()
```
Finally, we create a helper variable that specifies the number of
discrete rate categories, another helper variable for the total number of species
and our constant for specifying the standard deviation of the lognormal distribution.
```
NUM_RATE_CATEGORIES = 6
NUM_TOTAL_SPECIES = 367
H = 0.587405
```
Using these variables we can easily change our script, for example,
to use more or fewer categories and test the impact.

{% subsection Specifying the model %}

{% subsubsection Priors on rates %}

{% figure fig_discretized_lognormal %}
<img src="figures/discretized_distributions.png" width="100%" height="100%" />
{% figcaption %}
**Approximation of the continuous base distributions for the diversification-rate parameters using discrete rate categories.**
From left to right, we show a discretization of a lognormal distribution with k={2,4,6,8,10,20} bins.
Our approach for computing the probability of the data under the lineage-specific birth-death-shift
model specifies *k* quantiles of the continuous base distributions for the speciation and extinction rates.
We compute probabilities by marginalizing (averaging) over the *k* discrete rate categories,
where the diversification rate for a given category is the median of the corresponding quantile (colored dots).
This approach provides an efficient alternative to computing the continuous integral,
and will provide a reliable approximation of the continuous integral when the number of categories *k* is sufficiently large to resemble the underlying continuous distribution.
{% endfigcaption %}
{% endfigure %}

Instead of using a continuous probability distribution we will use a
discrete approximation of the distribution, as done for modeling rate
variation across sites {% cite Yang1994a %} and for modeling relaxed molecular
clocks {% cite Drummond2006 %}. That means, we assume that the speciation rates
are drawn from one of the $N$ quantiles of the lognormal distribution.
For this we will use the function `fnDiscretizeDistribution` which takes
in a distribution as its first argument and the number of quantiles as
the second argument. The return value is a vector of quantiles. We use
it as a deterministic variable and every time the parameters of the base
distribution (i.e., the lognormal
distribution in our case) change the quantiles will update automatically
as well. Thus we only need to specify parameters for our base
distribution, the lognormal distribution.
We choose a log-uniform distribution as the prior distribution for the mean parameter of the lognormal distribution.
```
speciation_mean ~ dnLoguniform( 1E-6, 1E2)
moves.append( mvScale(speciation_mean, lambda=1, tune=true, weight=2.0) )
```
Next, we choose an exponential prior distribution with mean of $H$ for the variation in speciation rates.
```
speciation_sd ~ dnExponential( 1.0 / H )
moves.append( mvScale(speciation_sd, lambda=1, tune=true, weight=2.0) )
```
Now, we can compute the speciation rate categories.
We will use a lognormal distribution discretized into `NUM_RATE_CATEGORIES` quantiles and the parameters that we should created.
```
speciation := fnDiscretizeDistribution( dnLognormal(ln(speciation_mean), speciation_sd), NUM_RATE_CATEGORIES )
```

<!-- Alternatively, we choose a fixed standard deviation of $H * 2$ for the
speciation rates because it represents two orders of magnitude variance
in the rate categories.
```
speciation_sd <- H*2
speciation := fnDiscretizeDistribution( dnLognormal(ln(speciation_mean), speciation_sd), NUM_RATE_CATEGORIES )
```
-->
Similarly, we define the prior on the extinction rate in the same way as we did for
the speciation rate.
```
extinction_mean ~ dnLoguniform( 1E-6, 1E2)
extinction_mean.setValue( speciation_mean / 2.0 )
moves.append( mvScale(extinction_mean, lambda=1, tune=true, weight=2.0) )
```
However, we assume that extinction rate is the same for all categories.
Therefore, we simply replicate using the `rep` function the extinction rate `NUM_RATE_CATEGORIES` times.
```
extinction := rep( extinction_mean, NUM_RATE_CATEGORIES )
```
Next, we need a rate parameter for the rate-shifts events. We do not
have much prior information about this rate but we can provide some
realistic ranges. For example, we can specify a uniform distribution that the
goes from 0 to 100 expected events.
Remember that this is only possible if the tree is known and not
estimated simultaneously because only if the tree is known, then we also know the
tree length. As usual for rate parameter, we apply a scaling move to the
`event_rate` variable.
```
event_rate ~ dnUniform(0.0, 100.0/tree_length)
moves.append( mvScale(event_rate, lambda=1, tune=true, weight=2.0) )
```
Additionally, we need a parameter for probability that the process starts at the root in any of the diversification-rate categories.
We use a uniform/equal prior distribution on the diversification-rate categories.
```
rate_cat_probs <- simplex( rep(1, NUM_RATE_CATEGORIES) )
```

{% aside Shifts in the Extinction Rate %}
We might want to allow the extinction rate to change as well.
As with the speciation rate, we discretize the lognormal distribution
into a finite number of rate categories.
```
extinction_categories := fnDiscretizeDistribution( dnLognormal(ln(extinction_mean), H), NUM_RATE_CATEGORIES )
```
Now, we must create a vector that contains each combination of
speciation- and extinction-rates. This allows the rate of speciation to
change without changing the rate of extinction and vice versa. The
resulting vector should be $N^2$ elements long. We call these the
`paired' rate categories.
```
k = 1
for(i in 1:NUM_RATE_CATEGORIES) {
    for(j in 1:NUM_RATE_CATEGORIES) {
        speciation[k]   := speciation_categories[i]
        extinction[k++] := extinction_categories[j]
    }
}
```
Now we also need to specify a root prior for $N^2$ elements.
```
rate_cat_probs <- simplex( rep(1, NUM_RATE_CATEGORIES * NUM_RATE_CATEGORIES) )

```
Note however, that this type of analysis will take significantly longer to run!
{% endaside %}

{% subsubsection Incomplete Taxon Sampling %}

We know that we have sampled 233 out of 367 living primate species. To
account for this we can set the sampling parameter as a constant node
with a value of 233 / 367.
```
rho <- observed_phylogeny.ntips() / NUM_TOTAL_SPECIES
```

{% subsubsection Root age %}

The birth-death process requires a parameter for the root age. In this
exercise we use a fix tree and thus we know the age of the tree. Hence,
we can get the value for the root from the {% cite MagnusonFord2012 %} tree. This
is done using our global variable `root` defined above and nothing else
has to be done here.

{% subsubsection The time tree %}

Now we have all of the parameters we need to specify the full
branch-specific birth-death model. We initialize the stochastic node
representing the time tree.
```
timetree ~ dnCDBDP( rootAge           = root,
                    speciationRates   = speciation,
                    extinctionRates   = extinction,
                    Q                 = fnJC(NUM_RATE_CATEGORIES),
                    delta             = event_rate,
                    pi                = rate_cat_probs,
                    rho               = rho,
                    condition         = "time" )
```
And then we attach data to it.
```
timetree.clamp(observed_phylogeny)
```

Finally, we create a workspace object of our whole model using the
`model()` function.
```
mymodel = model(speciation)
```
The `model()` function traversed all of the connections and found all of
the nodes we specified.

{% subsection Running an MCMC analysis %}

{% subsubsection Specifying Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to
record the states of our Markov chain. First, we will initialize the
model monitor using the `mnModel` function. This creates a new monitor
variable that will output the states for all model parameters when
passed into a MCMC function.
```
monitors.append( mnModel(filename="output/primates_BDS.log",printgen=1, separator = TAB) )
```
For summary and plotting purposes, we need to obtain the branch-specific diversification rate estimate along the tree.
We will use a stochastic rate mapping algorithm {% citet Freyman2019 %}.
Thus, we create an `mnStochasticBranchRate`. The stochastic branch-rate monitor
draws stochastic character maps and writes the *simulated* branch rates into a file.
We will need this file later to estimate and visualize the posterior
distribution of the rates at the branches.
```
monitors.append( mnStochasticBranchRate(cdbdp=timetree, printgen=1, filename="output/primates_BDS_rates.log") )
```
Finally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=10, event_rate, speciation_mean, extinction_mean) )
```

{% subsubsection Initializing and Running the MCMC Simulation %}

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The `mcmc()` function will
create our MCMC object:
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=2, combine="mixed")
```
Now, run the MCMC:
```
mymcmc.run(generations=2500,tuning=200)
```

&#8680; The `Rev` file for performing this analysis: `mcmc_BDS.Rev`

When the analysis is complete, you will have the monitored files in your
output directory. You can then visualize the branch-specific rates by
plotting them using our `R` package `RevGadgets`.

Just start `R` in the main directory for this analysis and then type the following commands:
```R
library(RevGadgets)

my_tree_file = "data/primates_tree.nex"
my_branch_rates_file = "output/primates_BDS_rates.log"
tree_plot = plot_branch_rates_tree( tree_file=my_tree_file,
                                    branch_rates_file=my_branch_rates_file)

ggsave("BDS.pdf", width=15, height=15, units="cm")
```

{% figure fig_BDS %}
<img src="figures/BDS.png" width="100%" height="100%" />
{% figcaption %}
**Estimated branch-specific speciation rates.**
Here we show the results of our example analysis. You'll see that there is a speciation rate
increase for the New World Monkeys.
{% endfigcaption %}
{% endfigure %}
