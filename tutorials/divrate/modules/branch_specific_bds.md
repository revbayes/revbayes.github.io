{% section Estimating Branch-Specific Diversification Rates %}

In this analysis we are interested in estimating the
branch-specific diversification rates.
We are going to use the `dnCBDP` distribution which uses a finite number of rate-categories
instead of drawing rates from a continuous distribution directly.

Here we adopt an approach using (few) discrete rate categories instead.
This allows us to numerically integrate over all possible rate
categories using a system of differential equation originally described
by {% citet Maddison2007 %} (see also {% citet FitzJohn2009 %} and {% citet FitzJohn2010 %}). The
numerical procedure beaks time into very small time intervals and sums
over all possible events occurring in that interval (see {% ref fig_likelihood %}).

You don't need to worry about any of the technical details. It is
important for you to realize that this model assumes that new rates at a
rate-shift event are drawn from a given (discrete) set of rates.

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
discrete rate categories, another helper variable for the expected
number of rate-shift events, the total number of species, and the
variation in rates.
```
NUM_RATE_CATEGORIES = 6
EXPECTED_NUM_EVENTS = 2
NUM_TOTAL_SPECIES = 367
H = 0.587405
```
Using these variables we can easily change our script, for example, to
use more or fewer categories and test the impact.

{% subsection Specifying the model %}

{% subsubsection Priors on rates %}

{% figure fig_discretized_lognormal %}
<img src="figures/discretized_lognormal.png" width="75%" height="75%" /> 
{% figcaption %}
**Discretization of a lognormal distribution.**
The two left figures have 4 rate categories
and the two right plots have 10 rate categories. The top plots have the
95% probability interval spanning one order of magnitude (`sd`
$=0.587405$) and the bottom plots have the 95% probability interval
spanning two orders of magnitude (`sd` $=2*0.587405$) . 
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
 fixed on our expected diversification rate, which is
$$\ln( \ln(\frac{\#Taxa}{2})/age )$$. 
```
speciation_mean ~ dnLoguniform( 1E-6, 1E2)
moves.append( mvScale(speciation_mean, lambda=1, tune=true, weight=2.0) )

```
Next, we choose an exponential prior distribution with mean of $H$ for the variation in speciation rates.
```
rate_sd ~ dnExponential( 1.0 / H )
moves.append( mvScale(rate_sd, lambda=1, tune=true, weight=2.0) )
```
Now, we can compute the speciation rate categories.
We will use a lognormal distribution discretized into `NUM_RATE_CATEGORIES` quantiles and the parameters that we should created.
```
speciation := fnDiscretizeDistribution( dnLognormal(ln(speciation_mean), rate_sd), NUM_RATE_CATEGORIES )
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
estimated simultaneously because only if the tree is do we also know the
tree length. As usual for rate parameter, we apply a scaling move to the
`event_rate` variable.
```
event_rate ~ dnUniform(0.0, 100.0/tree_length)
event_rate.setValue(EXPECTED_NUM_EVENTS/tree_length)
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
For summary and plotting purposes, we need to extract the branch-specific diversification rate estimate from the tree.
We will use a stochastic rate mapping algorithm, which is derived from stochastic character mapping.
```
moves.append( mvGibbsDrawCharacterHistory(timetree, weight=1) )
branch_lambda := timetree.averageSpeciationRate()
branch_mu := timetree.averageExtinctionRate()
branch_net_div := branch_lambda - branch_mu
branch_rel_ext := branch_mu / branch_lambda
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
monitors.append( mnModel(filename="output/primates_FRC_BDSP.log",printgen=10, separator = TAB) )
```
Additionally, we create an extended-Newick monitor. The extended-Newick
monitor writes the tree to a file and adds parameter values to the
branches and/or nodes of the tree. We can thus print the tree with the
average speciation and extinction rates, as well as the net
diversification (speciation - extinction) and relative extinction
(extinction / speciation) rates, for each branch into a file. We will
need this file later to estimate and visualize the posterior
distribution of the rates at the branches.
```
monitors.append( mnStochasticBranchRate(cdbdp=timetree, printgen=1, filename="output/primates_BDS_rates.log") )
monitors.append( mnExtNewick(filename="output/primates_BDS_rates.trees", isNodeParameter=FALSE, printgen=1, tree=timetree, branch_lambda, branch_mu, branch_net_div, branch_rel_ext) )
```
Finally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=10, event_rate, mean_speciation, root_category, total_num_events) )
```

{% subsubsection Initializing and Running the MCMC Simulation %}

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The `mcmc()` function will
create our MCMC object:
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=1, combine="mixed")
```
Now, run the MCMC:
```
mymcmc.run(generations=10000,tuning=200)
```
When the analysis is complete, you will have the monitored files in your
output directory. You can then visualize the branch-specific rates by
attaching them to the tree. This is actually done automatically in our
`mapTree` function.
```
treetrace = readTreeTrace("output/primates_BDS_rates.trees", treetype="clock")
map_tree = mapTree(treetrace,"output/primates_BDS_rates_MAP.tree")
```
Now you can open the tree in `FigTree`.

&#8680; The `Rev` file for performing this analysis: `mcmc_BDS.Rev`
