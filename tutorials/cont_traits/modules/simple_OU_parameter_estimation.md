{% section Ornstein-Uhlenbeck Model %}

Under the simple Ornstein-Uhlenbeck (OU) model, a continuous character is assumed to evolve toward an optimal value, $\theta$. The character evolves stochastically according to a drift parameter, $\sigma^2$. The character is pulled toward the optimum by the rate of adaptation, $\alpha$; larger values of alpha indicate that the character is pulled more strongly toward $\theta$. As the character moves away from $\theta$, the parameter $\alpha$ determines how strongly the character is pulled back. For this reason, $\alpha$ is sometimes referred to as a ''rubber band'' parameter. When the rate of adaptation parameter $\alpha = 0$, the OU model collapses to the BM model. The resulting graphical model is quite simple, as the probability of the continuous characters depends only on the phylogeny (which we assume to be known in this tutorial) and the three OU parameter ({% ref fig_ou_gm %}).

{% figure fig_ou_gm %}
<img src="figures/ou_gm.png" width="50%" height="50%" />
{% figcaption %}
The graphical model representation of the homogeneous Ornstein-Uhlenbeck (OU) process.
For more information about graphical model representations see {% citet Hoehna2014b %}.
{% endfigcaption %}
{% endfigure %}

In this tutorial, we use the 66 vertebrate phylogenies and (log) body-size datasets from {% cite Landis2017b %}.

&#8680; The full OU-model specification is in the file called `mcmc_OU.Rev`.

{% subsection Read the data %}

We begin by deciding which of the 66 vertebrate datasets to use. Here, we assume we are analyzing the first dataset (_Acanthuridae_), but you should feel free to choose any of the datasets.
```
dataset <- 1
```

Now, we read in the (time-calibrated) tree corresponding to our chosen dataset.
```
T <- readTrees("data/trees.nex")[dataset]
```

Next, we read in the character data for the same dataset.
```
data <- readContinuousCharacterData("data/traits.nex")[dataset]
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

{% subsubsection Rate parameter %}

The stochastic rate of evolution is controlled by the rate parameter, $\sigma^2$. We draw the rate parameter from a loguniform prior. This prior is uniform on the log scale, which means that it is represents ignorance about the _order of magnitude_ of the rate.

```
sigma2 ~ dnLoguniform(1e-3, 1)
```

In order to estimate the posterior distribution of $\sigma^2$, we must provide an MCMC proposal mechanism that operates on this node. Because $\sigma^2$ is a rate parameter, and must therefore be positive, we use a scaling move called `mvScale`.
```
moves.append( mvScale(sigma2, weight=1.0) )
```

{% subsubsection Adaptation parameter %}

The rate of adaptation toward the optimum is determined by the parameter $\alpha$. We draw $\alpha$ from an exponential prior distribution, and place a scale proposal on it.
```
alpha ~ dnExponential(10)
moves.append( mvScale(alpha, weight=1.0) )
```

{% subsubsection Optimum %}

We draw the optimal value from a vague uniform prior ranging from -10 to 10 (you should change this prior if your character is outside of this range). Because this parameter can be positive or negative, we use a slide move to propose changes during MCMC.
```
theta ~ dnUniform(-10, 10)
moves.append( mvSlide(theta, weight=1.0) )
```

{% subsubsection Ornstein-Uhlenbeck model %}

Now that we have specified the parameters of the model, we can draw the character data from the corresponding phylogenetic OU model. In this example, we use the REML algorithm to efficiently compute the likelihood {% cite Felsenstein1985a %}. We assume the character begins at the optimal value at the root of the tree.
```
X ~ dnPhyloOrnsteinUhlenbeckREML(tree, alpha, theta, sigma2^0.5, rootStates=theta)
```

Noting that $X$ is the observed data ({% ref fig_bm_gm %}), we clamp the `data` to this stochastic node.
```
X.clamp(data)
```

Finally, we create a workspace object for the entire model with `model()`. Remeber that workspace objects are initialized with the `=` operator, and are not themselves part of the Bayesian graphical model. The `model()` function traverses the entire model graph and finds all the nodes in the model that we specified. This object provides a convenient way to refer to the whole model object, rather than just a single DAG node.

```
mymodel = model(theta)
```

{% subsection Running an MCMC analysis %}

{% subsubsection Specifying Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to record the states of our Markov chain. The monitor functions are all called `mn*`, where `*` is the wildcard representing the monitor type. First, we will initialize the model monitor using the `mnModel` function. This creates a new monitor variable that will output the states for all model parameters when passed into a MCMC function.
```
monitors.append( mnModel(filename="output/simple_OU.log", printgen=10) )
```
Additionally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=1000, sigma2, alpha, theta) )
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
mymcmc.run(generations=50000)
```
When the analysis is complete, you will have the monitored files in your
output directory.

&#8680; The `Rev` file for performing this analysis: `mcmc_OU.Rev`

Characters evolving under the OU process will tend toward a stationary distribution, which is a normal distribution with mean $\theta$ and variance $\sigma^2 \div 2\alpha$. Therefore, if rates of evolution are high (or the branches in the tree are relatively long), it can be difficult to estimate $\sigma^2$ and $\alpha$ separately, since they both determine the long-term variance of the process. We can see whether this affects our analysis by examining the _joint posterior distribution_ of the parameters in `Tracer`. When the parameters are positively correlated, we should hesitate to interpret their marginal distributions (_i.e._, don't make inferences about the rate of adaptation or the variance parameter separately).

{% figure ou_figure %}
<img src="figures/ou_joint_posterior.png" height="50%" width="50%" />
{% figcaption %}
Estimates of the joint posterior distribution of the rate of adaptation, $\alpha$ (x-axis), and the variance parameter, $\sigma^2$ (y-axis). Note that these parameters are positively correlated.
{% endfigcaption %}
{% endfigure %}








<!--  -->
