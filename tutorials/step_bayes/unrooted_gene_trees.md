---
title: Stepwise Bayesian inference of phylogeny
subtitle: Rooting and calibrating the gene trees
authors: Sebastian Höhna and Allison Hsiang
level: 3
order: 4.1
prerequisites:
- ctmc
include_all: false
include_files:
- scripts/mcmc_unrooted_gene_tree.Rev

index: false
redirect: false
---

Exercise 1
===========
{:.section}



{% figure fig_uexp_gm %}
<img src="figures/tikz/uexp_gm.png" width="400" />
{% figcaption %}
A graphical model of the uncorrelated exponential relaxed clock model. In this model, the clock rate on each branch is independent and identically distributed according to an exponential density with mean drawn from an exponential hyperprior distribution.
{% endfigcaption %}
{% endfigure %}

### The data

The data used in this exercise is the same as in the previous exercise (**bears_cytb.nex**). We will also use the same tree model (the birth-death process model) and the same substitution model (the GTR + $\Gamma$ model).

There are just three steps you need to complete before running the analysis in this exercise. First, we need to create a script for the relaxed clock model.
Second, we need to switch out the global clock model for the relaxed clock model in our master script and we need to update the name of the output files, so we don't overwrite the output generated in the previous exercise.


### The clock model




### The master Rev script

>Copy the master script from the previous exercise and call it **MCMC_dating_ex2.Rev**.
{:.instruction}

```
GENE = "COI"

### Read in sequence data for the gene
data = readDiscreteCharacterData( "data/photinus_"+GENE+".fas" )
```

```
# Get some useful variables from the data. We need these later on.
num_taxa <- data.ntaxa()
num_branches <- 2 * num_taxa - 3
taxa <- data.taxa()
```

```
moves    = VectorMoves()
monitors = VectorMonitors()
```

```
######################
# Substitution Model #
######################

# specify the stationary frequency parameters
pi_prior <- v(1,1,1,1)
pi ~ dnDirichlet(pi_prior)
moves.append( mvBetaSimplex(pi, weight=2.0) )
moves.append( mvDirichletSimplex(pi, weight=1.0) )


# specify the exchangeability rate parameters
er_prior <- v(1,1,1,1,1,1)
er ~ dnDirichlet(er_prior)
moves.append( mvBetaSimplex(er, weight=3.0) )
moves.append( mvDirichletSimplex(er, weight=1.5) )


# create a deterministic variable for the rate matrix, GTR
Q := fnGTR(er,pi)
```

```
#############################
# Among Site Rate Variation #
#############################

# among site rate variation, +Gamma4
alpha ~ dnUniform( 0, 1E8 )
alpha.setValue(1.0)

sr := fnDiscretizeGamma( alpha, alpha, 4, false )
moves.append( mvScale(alpha, weight=2.0) )
```

```
# the probability of a site being invariable, +I
p_inv ~ dnBeta(1,1)
moves.append( mvBetaProbability(p_inv, weight=2.0) )
```


```
##############
# Tree model #
##############

# hyper-prior for the
branch_length_lambda <- 10.0

# Prior distribution on the tree topology and branch lengths
psi ~ dnUniformTopologyBranchLength(taxa, branchLengthDistribution=dnExponential(branch_length_lambda))

moves.append( mvNNI(psi, weight=num_taxa) )
moves.append( mvSPR(psi, weight=num_taxa/5.0) )
moves.append( mvBranchLengthScale(psi, weight=num_branches*2) )

TL := psi.treeLength()
```


```
###################
# PhyloCTMC Model #
###################

# the sequence evolution model
seq ~ dnPhyloCTMC(tree=psi, Q=Q, siteRates=sr, pInv=p_inv, type="DNA")

# attach the data
seq.clamp(data)
```

```
############
# Analysis #
############

mymodel = model(psi)
```

```
# add monitors
monitors.append( mnScreen(alpha, p_inv, TL, printgen=100) )
monitors.append( mnFile(psi, filename="output/photinus_"+GENE+".trees", printgen=1) )
monitors.append( mnModel(filename="output/photinus_"+GENE+".log", printgen=1) )
```

```
# run the analysis
mymcmc = mcmc(mymodel, moves, monitors, nruns=2, combine="mixed")
mymcmc.run(generations=25000, tuningInterval=100)
```

```
# show the performance of the operators
mymcmc.operatorSummary()
```

```
# summarize output
treetrace = readTreeTrace("output/photinus_"+GENE+".trees", treetype="non-clock")
# and then get the MAP tree
map_tree = mapTree(treetrace,"output/photinus_"+GENE+"_MAP.tre")
```

```
# you may want to quit RevBayes now
q()
```

>Run your MCMC analysis!
{:.instruction}


### Examining the output

Let's compare the output from the two different clock models in Tracer.

>Open the program Tracer and load the log files **bears_global.log** and **bears_relaxed_exponential.log**.
{:.instruction}

You may notice that convergence isn't as good for this analysis,
which is probably caused by having a larger number of parameters.

Have a look at the estimate for the mean branch-rate parameter (`branch_rates_mean`) in comparison
to the estimate recovered in the previous analysis assuming a global molecular clock (`branch_mean`).
You'll notice that median estimates for these parameters differ quite a bit.

In Tracer you can also highlight multiple parameters simultaneously, by using the shift key.
Have a look at the rates obtained across different branches.
You can see that there appears to be signal in the data for variation in rates along different branches.

{% figure fig_trace %}
<img src="figures/bears_relaxed_branchrates.png" width="700" />
{% figcaption %}
The estimates panel in Tracer showing the rates estimated for different branches.
{% endfigcaption %}
{% endfigure %}

You can also compare the same parameters estimated using different models by selecting multiple trace files.

{% figure fig_trace2 %}
<img src="figures/bears_relaxed_likelihood.png" width="700" />
{% figcaption %}
The estimates panel in Tracer showing the likelihood estimates obtained using two different clock models.
{% endfigcaption %}
{% endfigure %}

Note that the likelihood obtained using the relaxed clock model is higher than for the global clock model,
which hints that it might be a better fit to our data.
However, this analysis has quite a lot of additional parameters (i.e. one addition rate parameter for each branch).
To work out whether this model really is more appropriate for our data,
we would need to use a more robust model testing approach.
For more on this topic see Tracy Heath's tutorial [Relaxed Clocks & Time Trees]({{ base.url }}/tutorials/clocks/).

Scroll through the other parameter estimates and see if you can spot any differences.


#### The tree output

Let's also have a quick look at the trees.

{% figure fig_tree %}
<img src="figures/bears_relaxed.mcc.tre.png" width="700" />
{% figcaption %}
The FigTree window. To open your tree you can use File > Open. Select Node Labels to view the relative node ages.
{% endfigcaption %}
{% endfigure %}

If you open the trees generated using the global versus relaxed clock models in FigTree, you can compare them to see whether these models made an important difference to the inferred topology and/or relative node ages. Another useful thing to look at are the posterior probabilities obtained for different nodes. Go to the options under Node Labels and select Display > posterior.



#### Exercise

We have seen above how to specify the UCE (uncorrelated exponential) clock model.
For this exercise, we want you the change the UCE clock model into a UCLN clock model (uncorrelated relaxed clock).
That means, we will need to replace the prior on the `branch_rates` so that they are drawn from a lognormal distribution.

>Copy the script called **clock_relaxed_exponential.Rev**, name it **clock_relaxed_lognormal.Rev** and open it in your text editor.
{:.instruction}

Since the lognormal distribution is parameterized by the log of the mean, we transform first the mean into the log mean.
```
ln_branch_rates_mean := ln( branch_rates_mean )
```
Now we can replace the `for`-loop and specify that we use a lognormal distribution
```
for(i in 1:n_branches){
    branch_rates[i] ~ dnLognormal(ln_branch_rates_mean,sd=0.587405)
    moves.append( mvScale(branch_rates[i], lambda=0.5, tune=true, weight=1.0) )
}
```
Next, we are ready to set up the master script to run the analysis.

>Copy the master script from the previous exercise and call it **MCMC_dating_ex2b.Rev**.
{:.instruction}

Change the file used to specify the clock model from **clock_relaxed_exponential.Rev** to **clock_relaxed_lognormal.Rev**.
```
source("scripts/clock_relaxed_lognormal.Rev")
```
Don't forget to update the filenames of the output (*e.g.,* from `bears_relaxed_exponential` to `bears_relaxed_lognormal`).

>Run your MCMC analysis!
{:.instruction}


### Next

>Click below to begin the next exercise!
{:.instruction}

* [Estimating speciation times using node dating]({{ base.url }}/tutorials/dating/nodedate)

For further options and information about clock models see Tracy Heath's tutorial [Relaxed Clocks & Time Trees]({{ base.url }}/tutorials/clocks/).
