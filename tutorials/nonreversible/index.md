---
title: Testing for non-reversible substitution with reversible-jump MCMC
subtitle: Comparing the time-reversible and non-reversible nucleotide models in one analysis
authors:  John Huelsenbeck, Sebastian Höhna and Matthias Köppe
level: 3
order: 3.6
prerequisites:
- intro
- mcmc
- ctmc
- model_selection_bayes_factors/bf_intro
index: true
redirect: false
include_files:
- nonreversible/data/anolis.nex
- nonreversible/data/anolis.tre
- nonreversible/scripts/rj_nonreversible.Rev
- nonreversible/scripts/measure_center.Rev
---

{% section Overview %}

Almost every phylogenetic analysis of nucleotide data assumes that substitution is time reversible: that the average rate of A→G substitutions equals the average rate of G→A substitutions, and so on for every pair of nucleotides. The general time-reversible (GTR) model is the most general model with this property. The time-reversibility assumption is made because ... well, it's not clear why the assumption of time-reversibility is made. Perhaps it is made out of convenience. Some of the programming becomes easier (for example, one doesn't need to worry about dealing with complex numbers in computer memory when calculating transition probabilities). Or maybe it's because the time reversible model is pretty, mathematically at least. Whatever the reason, as far as you, the biologist, is concerned, the time-reversible model is not used because we think it necessarily explains the data better.

Interestingly, there are models that are more complex than the time-reversible model. These models do not have the time-reversibility requirement and are called (sensibly enough) "non-reversible" models. This tutorial explains how you can test whether a non-reversible model is appropriate for your data set. Specifically, we show you how to compare the two models using reversible-jump MCMC (Green, 1995), described in the paper by Huelsenbeck et al. (In Review).

The ideas behind the RJ-MCMC procedure are involved, but running the analysis in RevBayes is relatively straight-forward. In what follows, we show you the details of how to do the analysis and some of the gotchas you should look out for.

This tutorial describes how to compare the two models directly with reversible-jump MCMC, so that a single analysis moves between them and the Bayes factor is read off from how often it visits each. The method, the prior it uses, and the results for sixteen empirical data sets are described in Huelsenbeck et al. (In Review). Along the way we see one thing the non-reversible model can do that the reversible model cannot: locate the root of the tree.

Before delving into this tutorial, you should familiarize yourself with the {% page_ref ctmc %} tutorial, and with the idea of a Bayes factor from {% page_ref model_selection_bayes_factors/bf_intro %}.

{% subsection Why not just compute two marginal likelihoods? %}

You can, and the {% page_ref model_selection_bayes_factors/bf_intro %} tutorial shows you how using the power posterior methodology. Before you go that route, however, just be aware that the power posterior methods need MCMC samples from many intermediate power posteriors (distributions that lie between the prior and the posterior) to resolve a difference of a few log units between them. Let's face it, the path sampling methods are useful, but they also take a lot of time. Basically, instead of running the Markov chain once, you end up running it many, many times along a path between the prior and the posterior. This is time consuming. I suppose that if you have the time to wait, there's nothing wrong with the methods. After all, it's not like you're spending the time breaking rocks in a quarry while the chain is running. (The computer is doing the equivalent of that!) But, this tutorial shows you a more efficient way of comparing the time-reversible and non-reversible models using the reversible-jump MCMC procedure, which estimates the Bayes factor for the two models directly, in one run, while at the same time giving you posterior samples under both models. It almost seems too good to be true! It is true, but comes at a cost, most of it already paid by the kindly RevBayes team: the cost is a harder kind of proposal and this tutorial is mostly about making that proposal work.

{% section The two models %}

Both models are described by the *weights* $w_{ij} = \pi_i q_{ij}$, the rate at which $i \rightarrow j$ substitutions occur per site per unit time. Weights are non-negative, sum to one (so that branch lengths are in expected substitutions per site), and satisfy *flow balance*: at every nucleotide the total weight in equals the total weight out, which is what makes $\pi$ the stationary distribution. The non-reversible model is the set of all such weights. The time-reversible model is the subset in which $w_{ij} = w_{ji}$ for every pair, so that there is no net flow on any pair.

The sets describing both models are polytopes, which are faceted shapes in some dimension (5 and 8 for the time-reversible and non-reversible models respectively), and the prior used here is uniform on each. The volumes of the polytopes are known exactly, so the prior densities are known exactly, which is what makes a reversible-jump comparison between them well defined. The details, including why the usual Dirichlet prior on GTR exchangeability rates is *not* uniform on the time-reversible model, are in (Huelsenbeck et al., In Review).

{% section The data %}

We use the *Anolis* lizard alignment of {% cite losos98 %}, thirty sequences of 1456 sites, and a fixed tree topology estimated for it. Download [anolis.nex](data/anolis.nex) and [anolis.tre](data/anolis.tre) into a `data` directory.

{% section Setting up the analysis %}

The full script is at [rj_nonreversible.Rev](scripts/rj_nonreversible.Rev). We will go through this script line-by-line, explaining what each does in RevBayes.

{% subsection Reading the data and the tree %}

```
aln <- readDiscreteCharacterData("data/anolis.nex")
n_taxa <- aln.size()
taxa <- aln.taxa()
rooted_tree <- readBranchLengthTrees("data/anolis.tre")[1]
```

The tree must be **rooted** and **fully bifurcating**. Under the non-reversible model the likelihood depends on where the root is, so the root is a parameter; and the move that relocates the root assumes every node has two descendants. If your tree has a polytomy, resolve it first (any resolution, even with zero-length branches, will do).

{% subsection The tree model %}

We keep the topology fixed and sample the branch lengths and the position of the root.

```
moves    = VectorMoves()
monitors = VectorMonitors()

# Tree: fixed topology; branch lengths and root position sampled
tree ~ dnUniformTopologyBranchLength( branchLengthDistribution=dnExp(10.0), taxa, rooted=TRUE )
tree.setValue( rooted_tree )
TL := tree.treeLength()

moves.append( mvBranchLengthScale( tree, weight=n_taxa*2-1 ) )
moves.append( mvReversibilityAwareBranchLengthScale( tree, weight=n_taxa*2-1 ) )
moves.append( mvMPQTree( tree=tree, updateRoot=TRUE, weight=n_taxa*2-1 ) )
```

Three moves act on the tree. `mvBranchLengthScale` is the ordinary single-branch scaling move. `mvReversibilityAwareBranchLengthScale` scales the two branches either side of the root together, which matters because under the time-reversible model only their sum affects the likelihood. `mvMPQTree` with `updateRoot=TRUE` slides the root to a new position on the tree; under the reversible model this changes nothing in the likelihood and the root wanders according to its prior, while under the non-reversible model the data pull it toward the branches favored by the data.

{% subsection The rate matrix %}

```
Q ~ dnQ( alpha=v(1,1,1,1) )
moves.append( mvMPQRateMatrix( Q, weight=50, tune=TRUE, tuneModelPrior=TRUE ) )
```

`dnQ` is the joint prior on the model indicator and the rate matrix. Specifically, it places equal prior odds on the two models, a flat Dirichlet on the stationary frequencies, and uniform distributions over the polytopes describing the models. `mvMPQRateMatrix` is the move on the rate matrix. Nine-tenths of the time, this move proposes a change within the current model, to the frequencies, to the weights, or to the non-reversible part alone; one-tenth of the time it proposes a jump to the other model (see next section). The `weight` of 50 is high because the rate matrix has up to eleven parameters and this one move updates all of them. Let's face it, this is a complicated move and the chain should spend a lot of its effort updating this portion of the model, hence the weight of 50.

{% aside The jump %}

A jump from reversible to non-reversible has to add three parameters. The move keeps the pair sums $w_{ij} + w_{ji}$ and draws how each of three pairs is split between its two directions, as a point $(u_1,u_2,u_3)$ in a polyhedron whose shape depends on the current weights; the reverse jump discards the split and keeps the sums. The polyhedron, its volume, and the Jacobian of this map are what the paper derives. You do not need to know any of it to run the analysis, but it is why the move has the two extra arguments discussed below.

{% endaside %}

{% subsection Rate variation and the likelihood %}

```
alpha ~ dnUniform(0.0, 1E6)
alpha.setValue( 1.0 )
moves.append( mvScale(alpha, lambda=0.5, tune=true, weight=1.0) )
rates := fnDiscretizeGamma(alpha, alpha, 4)

# Likelihood
seq ~ dnPhyloCTMC(tree=tree, Q=Q, siteRates=rates, type="DNA")
seq.clamp(aln)
```

Just implementing gamma-distributed rate variation. Nothing new here. Move along...

{% subsection What to monitor %}

Three derived quantities are the point of the analysis:

```
prob_reversible := ifelse( Q.isReversible(), 1.0, 0.0 )
ln_prior_odds   := Q.lnPriorOdds()
u               := Q.getU()
```

`prob_reversible` is 1 when the chain is in the time-reversible model and 0 otherwise; its average over the run is the posterior probability of the time-reversible model. `ln_prior_odds` is explained in the next section. `u` is the point in the polyhedron. Note that all three of the coordinates are exactly one half under the time-reversible model. The Huelsenbeck et al. (In Review) paper shows the models geometrically.

```
monitors.append( mnModel(filename="output/anolis_rj.log", printgen=10) )
monitors.append( mnFile(filename="output/anolis_rj.trees", printgen=10, tree) )
monitors.append( mnScreen(printgen=100, prob_reversible, ln_prior_odds, TL) )
```

{% section Running the chain, and the prior odds %}

```
mymodel = model(Q)
mymcmc = mcmc(mymodel, monitors, moves, nruns=1)
mymcmc.burnin(generations=20000, tuningInterval=500)
mymcmc.run(generations=50000)
mymcmc.operatorSummary()
```

The burn-in does something beyond the usual tuning of step sizes, and it is the key to the whole approach. If the data favor one model by a factor of $e^{5}$, then with equal prior odds the chain will spend 99.3% of its time in that model, and the estimate of the Bayes factor from a run of any reasonable length will be poor. The problem is even more severe if one of the two models is favored by the data by an even larger amount. The result in such a case would be a chain that fails to visit one of the models, so the MCMC estimates of the model probabilities would be 0 and 1. Of course, the probabilities aren't exactly 0 or 1, but rather numbers close to 0 and 1. We need to know those numbers as precisely as possible to correctly calculate the Bayes factor. We solve this problem by tilting the prior in favor of the disfavored model. During burn-in the move **adapts the prior odds on the two models**, tilting the prior against whichever model the chain is spending more time in, until the chain visits the two models about equally frequently. Once burn-in ends the tilt is frozen and never changes again. This is what `tuneModelPrior=TRUE` turns on, and `ln_prior_odds` is the tilt, $\ln(\rho_R / \rho_N)$, the log of the prior odds in favor of the time-reversible model.

The Bayes factor is then recovered from the run by undoing the tilt:
$$
\ln BF_{NR} = \ln \frac{1 - \bar p_R}{\bar p_R} + \ln\text{prior odds},
$$
where $\bar p_R$ is the average of `prob_reversible` over the run. The tilt is exactly the quantity the chain needed to balance, so it is itself an estimate of $\ln BF_{NR}$; the first term is a small correction for the balance not being perfect.

{% subsection Interpreting the result %}

From the log file, take the columns `prob_reversible` and `ln_prior_odds` (constant during the run) and, in R,

```
log  <- read.table("output/anolis_rj.log", header=TRUE)
p_R  <- mean(log$prob_reversible)
tilt <- log$ln_prior_odds[1]
lnBF <- log((1 - p_R) / p_R) + tilt
```

The Monte Carlo error comes from the effective sample size of `prob_reversible`. Numerous programs will estimate the ESS of a Markov chain for you. We find Tracer v1.7 (Rambaut et al., 2018) helpful here. Simply look at the row in the output for `prob_reversible`. The ESS is one of the column entries for that row.
$$
\mathrm{MCSE}(\ln BF) = \frac{1}{\bar p_R (1 - \bar p_R)} \sqrt{\frac{\bar p_R (1-\bar p_R)}{\mathrm{ESS}}}.
$$

For *Anolis* you should find $\ln BF_{NR} \approx -5.5$: decisive support for the time-reversible model, and an ESS in the low thousands from a 50,000-generation run. Running the chain with different seeds and comparing the results is the standard check that the MCMC did not run off a cliff.

{% subsection What the operator summary tells you %}

`operatorSummary()` prints, for `mvMPQRateMatrix`, the frozen `lnPriorOdds`, the tuned step size and acceptance rate of every sub-move, and the acceptance rate of the jumps in each direction. Two things to look for. The within-model sub-moves should have acceptance rates near their targets (0.23 for the joint moves, 0.44 for the single-parameter ones); a sub-move stuck at zero with its step size at a limit is a problem, not a tuning issue. And the jump acceptance rates should be nonzero in both directions. If `jumpAcceptance N->R` is zero the chain never got back to the reversible model, which brings us to the next section.

{% section When the data are very informative %}

On data sets that strongly favor the non-reversible model, the default jump can fail. The point $(u_1,u_2,u_3)$ is drawn uniformly over the polyhedron, but the posterior under the non-reversible model may occupy a small region of it, so almost every proposal lands somewhere useless and no jump is accepted. The symptom is a tilt that climbs through burn-in without settling, and a chain that never returns to the reversible model.

The solution is to tell the proposal where to look. `mvMPQRateMatrix` takes two extra arguments: `polyhedronCenter`, a point to concentrate the draw around, and `polyhedronAlpha`, how strongly to concentrate it (1 is uniform; 10 is a good first try). The center comes from a short preliminary run confined to the non-reversible model, [measure_center.Rev](scripts/measure_center.Rev):

```
Q ~ dnQ( alpha=v(1,1,1,1), fixedModel="nonreversible" )
moves.append( mvMPQRateMatrix( Q, weight=50, tune=TRUE, tuneModelPrior=FALSE ) )
u := Q.getU()
```

The posterior mean of the three `u` columns is the center. Let's say the center was found to be u = (0.56, 0.54, 0.34). Then, in the main analysis,

```
moves.append( mvMPQRateMatrix( Q, weight=50, tune=TRUE, tuneModelPrior=TRUE,
                               polyhedronCenter=v(0.56,0.54,0.34), polyhedronAlpha=10.0 ) )
```

Neither argument changes what is being estimated; the proposal density is computed consistently for whatever center and concentration are used, so any choice gives a valid move and only the acceptance rate differs. Two of the sixteen data sets in Huelsenbeck et al. (In Review) needed this, both with $\ln BF_{NR} > 60$; the remaining alignments from that study successfully ran with the defaults.

{% section The root %}

Under the time-reversible model the likelihood is the same wherever the tree is rooted. Under the non-reversible model it is not, and the root becomes something the data can inform. The tree file written by `mnFile` records the root position at every sample, and the log file records which model the chain was in, so you can tally, over the samples taken under the non-reversible model, how often the root sat on each branch. Compared with the prior, which is uniform along the tree, the posterior tells you how much the data say about the root. For *Anolis* they say little; for the strongly non-reversible data sets in the paper they confine the root to a handful of branches.

{% section Exercises %}

1. Run the analysis on *Anolis* twice with different seeds. Compute $\ln BF_{NR}$ and its Monte Carlo error from each run. Do the two agree within their errors?
2. Set `tuneModelPrior=FALSE`, so that the prior odds stay at one, and rerun. How much of its time does the chain spend in each model? Is the Bayes factor estimate usable?
3. Run [measure_center.Rev](scripts/measure_center.Rev) on *Anolis* and look at the posterior of `u`. How far are the three coordinates from one half? Relate this to the Bayes factor you found.
4. Compare your $\ln BF_{NR}$ with the difference of the two marginal likelihoods from stepping-stone sampling, using the {% page_ref model_selection_bayes_factors/bf_intro %} tutorial with `fixedModel="reversible"` and `fixedModel="nonreversible"` in `dnQ`. Which method needed more computation to reach the same precision?
