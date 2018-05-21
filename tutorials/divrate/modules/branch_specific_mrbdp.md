{% section Testing for Branch-Specific-Diversification Rates %}

In this first exercise we are interested in knowing if there is
diversification-rate variation among branches for our study tree. That
is, we want to see if we can reject a constant rate birth-death process.
Therefore, we don't focus on branch-specific parameter estimates but
instead on the marginal likelihood estimation for model testing.

We assume that you have completed the
RB_BasicDiversificationRate_Tutorial to estimate the marginal
likelihood under a constant-rate birth-death process. If you haven't
done so, then you should go back and do this now!

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
Additionally, we can initialize an iterator variable for our vector of
moves and monitors:
```
mvi = 1
mni = 1
```
Finally, we create a helper variable that specifies the number of
discrete rate categories, another helper variable for the expected
number of rate-shift events, the total number of species, and the
variation in rates.
```
NUM_RATE_CATEGORIES = 4
EXPECTED_NUM_EVENTS = 2
NUM_TOTAL_SPECIES = 367
H = 0.587405
```
Using these variables we can easily change our script, for example, to
use more or fewer categories and test the impact. For example, setting
`NUM_RATE_CATEGORIES = 1` gives the constant rate birth-death process.

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
distribution (*i.e.*, the lognormal
distribution in our case) change the quantiles will update automatically
as well. Thus we only need to specify parameters for our base
distribution, the lognormal distribution. We choose a stochastic
variable for the mean parameter of the lognormal distribution drawn from
yet another lognormal prior distribution. We fix the prior mean on this
mean speciation rate on our expected diversification rate, which is
$$\ln( \ln(\frac{\#Taxa}{2})/age )$$. Remember that the median of a
lognormal distribution is equal to the exponential of the mean
parameter. This is why we used a log-transform of the actual mean. This
prior density is analogous to the prior on the speciation-rate parameter
in the constant-rate birth-death process.
```
speciation_prior_mean <- ln( ln(NUM_TOTAL_SPECIES/2.0) / root )
speciation_mean ~ dnLognormal(mean=speciation_prior_mean, sd=H)
moves[mvi++] = mvScale(speciation_mean,lambda=1,tune=true,weight=5)
```
Additionally, we choose a fixed standard deviation of $2*H$
($0.587405*2$) for the speciation rates because it represents two orders
of magnitude variance in the rate categories.
```
speciation_sd <- 2*H
speciation_categories := fnDiscretizeDistribution( dnLognormal(ln(speciation_mean), speciation_sd), NUM_RATE_CATEGORIES )
```
We also need discretized extinction-rate categories. We are completely
free to choose how we construct these rate categories. For example, we
could choose a similar discretization of a lognormal distribution using
its quantiles to provide different extinction-rate categories. For
simplicity, this is how we specify the current model. Alternatively, we
could assume that each rate category has the same extinction rate.
```
extinction_prior_mean <- ln( ln(NUM_TOTAL_SPECIES/2.0) / root )
extinction_mean ~ dnLognormal(mean=extinction_prior_mean,sd=2*H)
moves[mvi++] = mvScale(extinction_mean,lambda=1.0,tune=true,weight=3.0)
```
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
Next, we need a rate parameter for the rate-shifts events. We do not
have much prior information about this rate but we can provide some
realistic ranges. For example, we can specify a mean rate so that the
resulting number of expected rate-shift events is 2 (as specified in our
global variable `EXPECTED_NUM_EVENTS`). Furthermore, we can say that
the 95% prior ranges exactly one order of magnitude. We achieve all this
by specifying a lognormal prior distribution with mean `ln(
EXPECTED_NUM_EVENTS/tree_length )` and standard deviation of `H`.
Remember that this is only possible if the tree is known and not
estimated simultaneously because only if the tree is do we also know the
tree length. As usual for rate parameter, we apply a scaling move to the
`event_rate` variable.
```
event_rate ~ dnLognormal( ln( EXPECTED_NUM_EVENTS/tree_length ), H)
moves[mvi++] = mvScale(event_rate,lambda=1,tune=true,weight=5)
```
Additionally, we need a rate-matrix parameter providing the relative
rates between paired rate categories. In this case we simply use equal
rates between each rate category; and thus use the Jukes-Cantor rate
matrix. You could, for example, also use an ordered rate matrix where
the process needs to go through rate 2 before going to rate 3 when
starting in rate 1.
```
rate_matrix <- fnJC( NUM_RATE_CATEGORIES * NUM_RATE_CATEGORIES )
```
Furthermore, we need prior probabilities for the process being in either
paired rate category at the root. Given our lack of prior knowledge we
create a flat prior distribution giving each rate category equal weight.
We do this by create a constant variable using the simplex function.
```
rate_category_prior <- simplex( rep(1, NUM_RATE_CATEGORIES * NUM_RATE_CATEGORIES) )
```

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

Now we have all of the parameters we need to specify the full episodic
birth-death model. We initialize the stochastic node representing the
time tree.
```
timetree ~ dnMRBDP(lambda=speciation, mu=extinction, Q=rate_matrix, rootAge=root, rho=rho, pi=rate_category_prior, delta=event_rate, taxa=taxa)
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

{% subsection Running a marginal likelihood estimation %}

{% subsubsection Specifying Monitors %}

For the marginal likelihood analysis we don't necessarily need monitors
because we are not going to look into the samples. However, as good
practice we still define our two standard monitors: the model monitor
and a screen monitor
```
monitors[++mni] = mnModel(filename="output/primates_MRBD.log",printgen=10, separator = TAB)
monitors[++mni] = mnScreen(printgen=10, diversification_mean, turnover)
```

{% subsubsection Initializing and Running the MCMC Simulation %}

If you don't feel comfortable with Bayesian model selection
anymore, then have a look at the
[RB_BayesFactor_Tutorial](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_BayesFactor_Tutorial/RB_BayesFactor_Tutorial.pdf)
again.

First, we create the variable containing the power posterior. This
requires us to provide a model and vector of moves, as well as an output
file name. The `cats` argument sets the number of power steps.
```
pow_p = powerPosterior(mymodel, moves, "output/MRBD_powp.out", cats=100)
```
We can start the power posterior by first burning in the chain and and
discarding the first 5000 states.
```
pow_p.burnin(generations=5000,tuningInterval=200)
```
Now execute the run with the `.run()` function:
```
pow_p.run(generations=2000)
```
Once the power posteriors have been saved to file, create a
stepping-stone sampler. This function can read any file of power
posteriors and compute the marginal likelihood using stepping-stone
sampling.
```
ss = steppingStoneSampler(file="output/MRBD_powp.out", powerColumnName="power", likelihoodColumnName="likelihood")
```
Compute the marginal likelihood under stepping-stone sampling using the
member function `marginal()` of the `ss` variable and record the value
in Table [tab:ss].
```
ss.marginal()
```
Path sampling is an alternative to stepping-stone sampling and also
takes the same power posteriors as input.
```
ps = pathSampler(file="output/MRBD_powp.out", powerColumnName="power", likelihoodColumnName="likelihood")
```
Compute the marginal likelihood under stepping-stone sampling using the
member function `marginal()` of the `ps` variable and record the value
in Table [tab:ss].
```
ps.marginal()
```
The Rev file for performing this analysis:
[`ml_MRBD.Rev`](https://github.com/revbayes/revbayes_tutorial/raw/master/RB_DiversificationRateBranchSpecific_Tutorial/RevBayes_scripts/ml_MRBD.Rev).

{% subsection Exercise 1 %}

-   Enter the marginal likelihood estimate from the previous exercise on
    the constant-rate birth-death process in the table below.

-   Compute the marginal likelihood under the 2-rate model,
    *i.e.*, set the NUM_Rate_CATEGORIES
    variable to 2.

-   Repeat the estimation of the marginal likelihoods with other number
    of rate categories to fill out the table.

-   What is the most supported model? Can we reject the constant-rate
    birth-death process?

{% figure tab_ml_models %}

 |       **Model**        |   **Path-Sampling**   |   **Stepping-Stone-Sampling**   |
  -----------------------:|:---------------------:|:-------------------------------:|
 |  constant-rate ($N=1$) |                       |                                 |
 |     two rate ($N=2$)   |                       |                                 |
 |    four rate ($N=4$)   |                       |                                 |
 |     six rate ($N=6$)   |                       |                                 |

{% figcaption %}
Marginal likelihoods for different number of rate categories.
{% endfigcaption %}
{% endfigure %}
