---
title: Model selection of common substitution models for one locus
subtitle: Comparing relative model fit with Bayes factors
authors:  Sebastian Höhna, Michael J Landis, Tracy A Heath
level: 1
order: 1
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
- bf_intro
exclude_files: 
- data/fagus_ITS.nex
- data/fagus_matK.nex
- data/fagus_rbcL.nex
- data/sim_locus1.nex
- data/sim_locus2.nex
- data/sim_locus3.nex
- data/sim_locus4.nex
- scripts/ml_Partition_model.Bodega.Rev
- data/primates_and_galeopterus_cox2.nex
- scripts/marginal_likelihood_partition_1.Rev
- scripts/marginal_likelihood_partition_2.Rev
- scripts/marginal_likelihood_partition_3.Rev
- scripts/marginal_likelihood_partition_4.Rev
- scripts/marginal_likelihood_partition_5.Rev
- scripts/model_average_primates_cytb.Rev
index: true
title-old: RB_BayesFactor_Tutorial
redirect: false
---


{% section Overview %}

This tutorial provides the third protocol from our recent publication {% cite Hoehna2017a %}. 
The first protocol is described in the {% page_ref ctmc %}
and the second protocol is described in the {% page_ref partition/index %}.

You should read first the {% page_ref model_selection_bayes_factors/bf_intro %} tutorial, which explains the theory and 
standard algorithms for estimating marginal likelihoods and Bayes factors.


{% section Substitution Models %}

The models we use here are equivalent to the models described in the
previous exercise on substitution models (continuous time Markov
models). To specify the model please consult the previous exercise.
Specifically, you will need to specify the following substitution
models:

-   Jukes-Cantor (JC) substitution model {% cite Jukes1969 %}
-   Hasegawa-Kishino-Yano (HKY) substitution model {% cite Hasegawa1985 %}
-   General-Time-Reversible (GTR) substitution model {% cite Tavare1986 %}
-   Gamma (+G) model for among-site rate variation {% cite Yang1994a %}
-   Invariable-sites (+I) model {% cite Hasegawa1985 %}


Just to be safe, it is better to clear the workspace (if you did not
just restart RevBayes):
```
    clear()
```
Now set up the model as in the previous exercise. You should start with
the simple Jukes-Cantor substitution model. Setting up the model
requires:

1.  Loading the data and retrieving useful variables about it
    (*e.g.*, number of sequences and
    taxon names).
2.  Specifying the instantaneous-rate matrix of the substitution model.
3.  Specifying the tree model including branch-length variables.
4.  Creating a random variable for the sequences that evolved under
    the `PhyloCTMC`.
5.  Clamping the data.
6.  Creating a model object.
7.  Specifying the moves for parameter updates.

The following procedure for estimating marginal likelihoods is valid for
any model in RevBayes. You will need to repeat this later for other
models. First, we create the variable containing the power-posterior
analysis. This requires that we provide a model and vector of moves, as
well as an output file name. The `cats` argument sets the number of
stepping stones.
```
    pow_p = powerPosterior(mymodel, moves, monitors, "output/model1.out", cats=50) 
```
We can start the power-posterior analysis by first burning in the chain
and and discarding the first 10000 states. This will help ensure that
analysis starts from a region of high posterior probability, rather than
from some random point.
```
    pow_p.burnin(generations=10000,tuningInterval=1000)
```
Now execute the run with the `.run()` function:
```
    pow_p.run(generations=1000)  
```
Once the power posteriors have been saved to file, create a stepping
stone sampler. This function can read any file of power posteriors and
compute the marginal likelihood using stepping-stone sampling.
```
    ss = steppingStoneSampler(file="output/model1.out", powerColumnName="power", likelihoodColumnName="likelihood")
```
These commands will execute a stepping-stone simulation with 50 stepping
stones, sampling 1000 states from each step. Compute the marginal
likelihood under stepping-stone sampling using the member function
`marginal()` of the `ss` variable and record the value in Table
[tab:ml_cytb].
```
    ss.marginal() 
```
Path sampling is an alternative to stepping-stone sampling and also
takes the same power posteriors as input.
```
    ps = pathSampler(file="output/model1.out", powerColumnName="power", likelihoodColumnName="likelihood")
```
Compute the marginal likelihood under stepping-stone sampling using the
member function `marginal()` of the `ps` variable and record the value
in Table [tab_ml_subst_models].
```
    ps.marginal() 
```

As an example we provide the file
**RevBayes_scripts/marginalLikelihood_JukesCantor.Rev**.

We have kept this description of how to use stepping-stone-sampling and
path-sampling very generic and did not provide the information about the
model here. Our main motivation is to show that the marginal likelihood
estimation algorithms are independent of the model. Thus, you can apply
these algorithms to any model, *e.g.*, relaxed
clock models and birth-death models, as well.

{% subsection Exercises %}

-   Compute the marginal likelihoods of the *cytb* alignment for the
    following substitution models:
    1.  Jukes-Cantor (JC) substitution model
    2.  Hasegawa-Kishino-Yano (HKY) substitution model
    3.  General-Time-Reversible (GTR) substitution model
    4.  GTR with gamma distributed-rate model (GTR+G)
    5.  GTR with invariable-sites model (GTR+I)
    6.  GTR+I+G model
-   Enter the marginal likelihood estimate for each model in the
    corresponding cell of Table [tab:ml_cytb].
-   Which is the best fitting substitution model?

{% figure tab_ml_subst_models %}

 |       **Model**        |   **Path-Sampling**   |   **Stepping-Stone-Sampling**   |
  -----------------------:|:---------------------:|:-------------------------------:|
 |        JC ($M_1$)      |                       |                                 |
 |       HKY ($M_2$)      |                       |                                 |
 |       GTR ($M_3$)      |                       |                                 |
 |  GTR+$\Gamma$ ($M_4$)  |                       |                                 |
 |      GTR+I ($M_5$)     |                       |                                 |
 | GTR+$\Gamma$+I ($M_6$) |                       |                                 |

{% figcaption %}
Marginal likelihoods for different substitution models.
{% endfigcaption %}
{% endfigure %}


> Now you can continue to the next tutorial: {% page_ref model_selection_bayes_factors/bf_partition_model %} or {% page_ref model_selection_bayes_factors/bf_subst_model_rj %}
{:.instruction}