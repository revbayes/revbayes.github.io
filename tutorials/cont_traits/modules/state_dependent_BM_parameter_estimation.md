{% section A State-dependent Model of Brownian-motion Evolution %}

Under a simple Brownian-motion (BM) model, the evolution of a continuous character is entirely determined by a single rate parameter, $\sigma^2$. However, we may be interested in testing hypotheses about whether the state of a discrete character (_e.g._, habitat) are associated with differential rates of continuous-character evolution.

In this tutorial, we will specify the state-dependent model described in {% citet May2019 %}. Under this model, the rate of continuous-character evolution depends on the state of a discrete character that is also evolving on the phylogeny. We must therefore specify a model that includes both the continuouss characters and the discrete character. For a discrete character with $k$ states, we include $k$ BM rate parameters, $\boldsymbol{\zeta^2} = \[\zeta^2_0, \ldots, \zeta^2_k\]$ that describe the relative rate of evolution of the continuous character while the discrete character is in each state (these parameters have a mean of 1). We include a parameter that controls the ''average'' rate of continuous-character evolution, $\beta^2$; because the state-dependent relative rates have a mean of 1, $\beta^2$ controls the overall rate of the Brownian motion process. Finally, we include a continuous-time Markov chain model to describe the evolution of the discrete character, which is defined by the instantaneous-rate matrix $Q$.

Under this model, the changes in the continuous character while the discrete character is in state $j$, $\Delta_j$, are normally distributed with mean 0 and variance $t_j \beta^2 \zeta^2_j$, where $t_j$ is the amount of time spent in state $j$. The total change over the entire branch is a sum of normally distributed random variables:

$$
\begin{equation}
    \Delta \sim \text{Normal}(0, \beta^2 \sum_{j=0}^k t_j \zeta^2_j )
\end{equation}
$$

Consequently, the rate of evolution on branch $i$ is the weighted average of the state-dependent rates, weighted by the amount of time spent in each state:

$$
\begin{equation}
    \sigma^2_i = \beta^2 \times \sum_{j=0}^k \tau_i(j) \times \zeta^2_j,
\end{equation}
$$

where $\tau_i(j)$ is the _relative_ amount of time branch $i$ spends in discrete-state $j$ (the relative dwelling time). Given a particular history of the discrete character, which describes the amount of time spent in each state along each branch, we can therefore compute the branch-specific rates of continuous-character evolution over the entire tree. We use data augmentation to map the history of discrete characters across the tree, and use Markov chain Monte Carlo to integrate over all possible histories of the discrete character in proportion to their probability. The probabilistic graphical model for this model is represented in ({% ref fig_bm_state_dependent_gm %}).

{% figure fig_bm_state_dependent_gm %}
<img src="figures/bm_state_dependent_gm.png" width="75%" height="75%" />
{% figcaption %}
The graphical model representation of the state-dependent Brownian-motion (BM) process. For more information about graphical model representations see {% citet Hoehna2014b %}.
{% endfigcaption %}
{% endfigure %}


In this tutorial, we use the phylogenies and continuous character datasets from {% cite Price2013 May2019 %} to estimate state-dependent rates of continuous-character evolution.

&#8680; The full state-dependent BM-model specification is in the file called `mcmc_state_dependent_BM.Rev`.

{% subsection Read the data %}

In this tutorial, we will use univariate Brownian motion to analyze the state-dependent rates of a single continuous character. Here, we assume we are analyzing the first character (log body size), but you should feel free to choose any of the 9 characters described in the `haemulidae_trophic_traits.nex` file.
```
character <- 1
```
Now, we read in the (time-calibrated) tree and retrieve some useful information.
```
T <- readTrees("data/haemulidae.nex")[1]
ntips <- T.ntips()
nbranches <- 2 * ntips - 2
```

Next, we read in the continuous character data.
```
cont <- readContinuousCharacterData("data/haemulidae_trophic_traits.nex")
```
We include only the chosen character by first excluding _all_ the characters, then re-including the focal character.
```
cont.excludeAll()
cont.includeCharacter(character)
```

{% aside Alternative: Multivariate model %}

We can also include all of the continuous characters in a multivariate analysis. In this case, we don't exclude any characters, and instead retrieve the number of characters in the dataset.
```
cont <- readContinuousCharacterData("data/haemulidae_trophic_traits.nex")
nchar <- cont.nchar()
```

{% endaside %}

Now, we read in the discrete character data (habitat for each species, coded as reef [1] or non-reef [0]), and record the number of states it has.
```
disc <- readDiscreteCharacterData("data/haemulidae_habitat.nex")
num_disc_states <- disc.getStateDescriptions().size()
```

Additionally, we initialize a variable for our vector of
moves and monitors:
```
moves    = VectorMoves()
monitors = VectorMonitors()
```

{% subsection Specifying the model %}

{% subsubsection Tree model %}

In this tutorial, we assume the tree is known without area. We create a constant node for the tree that corresponds to the observed phylogeny.
```
tree <- T
```
{% subsubsection Discete-character model %}

Here, we assume that the discrete character evolves under a Mk model with rate $\lambda$ {% cite Lewis2001 %}. This is equivalent to the Jukes-Cantor model for nucleotide substitution, but with $k$ states. (You may consider a more complex model if you know how to specify it in 'RevBayes').
```
Q <- fnJC(num_disc_states)
```

We draw the rate parameter, $\lambda$, from a vague log-uniform prior.
```
lambda ~ dnLoguniform(1e-3, 2)
```
The rate parameter must be positive, so we apply a scaling move to it.
```
moves.append( mvScale(lambda, weight=1.0) )
```

Now, we draw the discrete character data and its character history from a CTMC model.
```
X ~ dnPhyloCTMCDASiteIID(tree, Q, branchRates=lambda, type="Standard", nSites=1)
```
The distribution `dnPhyloCTMCDASiteIID` _augments the data_ to include the complete history of the discrete character(s) along each branch of the phylogeny (the `DA` in `dnPhyloCTMCDASiteIID` stands for data augmentation). We must apply special MCMC proposals on the character history to average over all possible histories in proportion to their probability.
```
moves.append( mvCharacterHistory(ctmc=X, qmap_site=Q, graph="node",   proposal="rejection", weight=20.0) )
moves.append( mvCharacterHistory(ctmc=X, qmap_site=Q, graph="branch", proposal="rejection", weight=20.0) )
```
These proposals choose nodes or branches in the tree to update, and then propose a new history using the stochastic mapping algorithm {% cite Nielsen2002 Landis2013a %}.

Finally, we keep track of the number of discrete-character transitions along each branch, and over the whole phylogeny. This is mostly a sanity check, to make sure we are not inferring extremely unrealistic histories for the discrete character.

```
for(i in 1:nbranches) {
    num_changes[i] := sum(X.numCharacterChanges(i))
}
total_num_changes := sum(num_changes)
```

{% subsubsection Continuous-character model %}

As indicated in the graphical model above ({% ref fig_bm_state_dependent_gm %}), we parameterize the model by separating the _average_ rate of continuous-character evolution (averaged among the discrete-states), $\beta^2$, from the _relative_ rate of state-dependent evolution, $\boldsymbol{\zeta^2}$. The parameter $\beta^2$ gives the Brownian motion process its absolute 'scale', so if rates of evolution are high, $\beta^2$ will be high. The absolute rate of evolution in discrete state $i$ is $\beta^2 \times \zeta^2_i$.

We draw the average rate of evolution, $\beta^2$, from a vague loguniform prior. This prior is uniform on the log scale, which means that it is represents ignorance about the _order of magnitude_ of the average rate of evolution. We use a scaling move to propose updates to this parameter.
```
beta ~ dnLoguniform(1e-3, 1)
moves.append( mvScale(beta, weight=1.0) )
```

Next, we draw the _proportional_ rates of state-dependent evolution from a Dirichlet prior with parameter `concentration <- 1.0`. These rates are proportional in the sense that they sum to 1.
```
concentration <- 1.0
relative_zeta ~ dnDirichlet( rep(concentration, num_disc_states) )
```
We include a special move for simplex parameters (sets of parameters that sum to 1) called `mvBetaSimplex`.
```
moves.append( mvScale(beta, weight=1.0) )
```
To compute the _relative_ rates (_i.e._, the rates that have a mean of 1), we simply multiply the proportional rates by the number of elements.
```
zeta := proportional_zeta * num_disc_states
```
We can compute the absolute rate of evolution in each of the discrete states by multiplying $\beta \times \zeta$.
```
overall_rate := beta * zeta
```

Now, we compute the rate for each branch given the parameters of the state-dependent model and the history of the discrete character. The method `X.relativeTimeInStates(i,1)` computes the relative amount of time spent in each state of the first discrete character (in this case, we have only one character) on branch $i$, _i.e._, it computes $\tau_i(j)$. Multiplying $\tau_i(j)$ by the vector $\boldsymbol{\zeta^2}$, and taking the sum, produces the rate of evolution for branch $i$ due to the discrete character history. We compute this for each branch in the tree.
```
for(i in 1:nbranches) {
    state_branch_rate[i] := sum(X.relativeTimeInStates(i,1) * zeta)
}
```

Finally, we compute the overall branch rates by multiplying the state-dependent branch-rates by the average rate of change.
```
branch_rates := state_branch_rate * beta
```

{% aside Alternative: Multivariate model %}

To use multivariate data, we must also specify a prior model for the variance-covariance matrix, $\Sigma$. See the tutorial {% page_ref cont_traits/multivariate_bm %} for more information about this model.

First, we specify the relative rates of change among the continuous characters.
```
alpha <- 1.0
proportional_rates ~ dnDirichlet( rep(alpha, nchar) )
relative_rates := proportional_rates * nchar
moves.append( mvBetaSimplex(proportional_rates, weight=2.0) )
```
Next, we specify an LKJ prior on the partial correlation matrix, $P$, and transform it into a full correlation matrix, $R$.
```
eta <- 1.0
P ~ dnLKJPartial( eta, nchar )

moves.append( mvCorrelationMatrixRandomWalk(P, weight=3.0) )
moves.append( mvCorrelationMatrixSingleElementBeta(P, weight=5.0) )

R := fnPartialToCorr(P)

correlations := R.upperTriangle()
```
Finally, we construct the variance-covariance matrix, $\Sigma$, from the relative rates for each character and the correlation matrix.
```
V := fnDecompVarCovar( relative_rates^0.5, R )
```

{% endaside %}

{% subsubsection Brownian-motion model %}

Now that we have specified the branch-specific rate parameters, we can draw the character data from the corresponding phylogenetic Brownian-motion model, just as we did for the simple BM models. In this case, we provide the square root of the branch-specific rates to the `branchRates` argument.
```
Y ~ dnPhyloBrownianREML(tree, branchRates=branch_rates^0.5)
```

Noting that $Y$ is the observed continuous-character data, we clamp the `cont` variable to this stochastic node.
```
Y.clamp(cont)
```

{% aside Alternative: Multivariate model %}

When performing a multivariate analysis, we replace the `dnPhyloBrownianREML` with `dnPhyloMultivariateBrownianREML` and provide `V` ($\Sigma$) as an additional argument.
```
Y ~ dnPhyloMultivariateBrownianREML(tree, branchRates=branch_rates^0.5, rateMatrix=V)
Y.clamp(cont)
```

{% endaside %}

Finally, we create a workspace object for the entire model with `model()`. Remember that workspace objects are initialized with the `=` operator, and are not themselves part of the Bayesian graphical model. The `model()` function traverses the entire model graph and finds all the nodes in the model that we specified. This object provides a convenient way to refer to the whole model object, rather than just a single DAG node.

```
mymodel = model(zeta)
```

{% subsection Running an MCMC analysis %}

{% subsubsection Specifying Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to record the states of our Markov chain. The monitor functions are all called `mn*`, where `*` is the wildcard representing the monitor type. First, we will initialize the model monitor using the `mnModel` function. This creates a new monitor variable that will output the states for all model parameters when passed into a MCMC function.
```
monitors.append( mnModel(filename="output/state_dependent_BM.log", printgen=10) )
```
Additionally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=1000, zeta, total_num_changes) )
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
mymcmc.run(generations=50000)
```
When the analysis is complete, you will have the monitored files in your output directory.

&#8680; The `Rev` file for performing this analysis: `mcmc_state_dependent_BM.Rev`

You can then visualize the absolute rates of state-dependent evolution ($\beta^2 \times \boldsymbol{\zeta^2}$) in `Tracer`.

{% figure zeta_posterior %}
<img src="figures/zeta_posterior.png" height="75%" width="75%" />
{% figcaption %}
Estimates of the posterior distribution of the $\beta^2 \times \zeta^2$ visualized in
`Tracer`.
{% endfigcaption %}
{% endfigure %}

{% aside Results: Multivariate model %}

If you ran the multivariate analysis, your posterior distributions for the state-dependent rates will look quite different. In the multivariate analysis, the effect of habitat is more pronounced than it was for the univariate analysis.

{% figure zeta_posterior_multivariate %}
<img src="figures/zeta_posterior_mvBM.png" height="75%" width="75%" />
{% figcaption %}
Estimates of the posterior distribution of the $\beta^2 \times \zeta^2$ under the multivariate model.
{% endfigcaption %}
{% endfigure %}

However, comparing the posterior distribution for the number of habitat transitions under the univariate and multivariate analysis ({% ref num_transitions_comparison %}) reveals that the inferred number of transitions under the multivariate analysis is very unrealistic ($\approx 32$ transitions) compared to the univariate analysis ($\approx 6.5$ transitions). This is a strong indication that there are other sources of rate variation that are causing the multivariate analysis to infer very unrealistic patterns of habitat evolution.

{% figure num_transitions_comparison %}
<img src="figures/num_transitions_posterior.png" height="75%" width="75%" />
{% figcaption %}
Estimates of the posterior distribution of the the number of habitat transitions under the univariate model (green) and the multivariate model (blue).
{% endfigcaption %}
{% endfigure %}


{% endaside %}











<!--  -->
