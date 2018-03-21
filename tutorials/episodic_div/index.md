---
title: Episodic Diversification Rate Estimation
subtitle: Estimating episodic, tree-wide changes in diversification rates
authors:  Sebastian H&#246;hna
level: 2
index: true
prerequisites:
- intro
title-old: RB_DiversificationRate_Episodic_Tutorial
redirect: true
---




Overview: Diversification Rate Estimation {#sec:diversification_rate_overview}
=========================================

Models of speciation and extinction are fundamental to any phylogenetic
analysis of macroevolutionary processes
(*e.g.,* divergence time estimation,
diversification rate estimation, continuous and discrete trait
evolution, and historical biogeography). First, a prior model describing
the distribution of speciation events over time is critical to
estimating phylogenies with branch lengths proportional to time. Second,
stochastic branching models allow for inference of speciation and
extinction rates. These inferences allow us to investigate key questions
in evolutionary biology.

Diversification-rate parameters may be included as nuisance parameters
of other phylogenetic models—*i.e.,* where
these diversification-rate parameters are not of direct interest. For
example, many methods for estimating species divergence times—such as
`BEAST`{% cite Drummond2012 %},
`MrBayes`{% cite Ronquist2012 %}, and RevBayes
{% cite Hoehna2016b %}—implement 'relaxed-clock models' that include a
constant-rate birth-death branching process as a prior model on the
distribution of tree topologies and node ages. Although the parameters
of these 'tree priors' are not typically of direct interest, they are
nevertheless estimated as part of the joint posterior probability
distribution of the relaxed-clock model, and so can be estimated simply
by querying the corresponding marginal posterior probability densities.
In fact, this may provide more robust estimates of the
diversification-rate parameters, as they accommodate uncertainty in the
other phylogenetic-model parameters (including the tree topology,
divergence-time estimates, and the other relaxed-clock model
parameters). More recent work,
*e.g.,* {% cite Heath2014 %}, uses macroevolutionary
models (the fossilized birth-death process) to calibrate phylogenies and
thus to infer dated trees.

In these tutorials we focus on the different types of macroevolutionary
models to study diversification processes and thus the
diversification-rate parameters themselves. Nevertheless, these
macroevolutionary models should be used for other evolutionary
questions, when an appropriate prior distribution on the tree and
divergence times is needed.

Types of Hypotheses for Estimating Diversification Rates
--------------------------------------------------------

Many evolutionary phenomena entail differential rates of diversification
(speciation – extinction); *e.g.,* adaptive
radiation, diversity-dependent diversification, key innovations, and
mass extinction. The specific study questions regarding lineage
diversification may be classified within three fundamental categories of
inference problems. Admittedly, this classification scheme is somewhat
arbitrary, but it is nevertheless useful, as it allows users to navigate
the ever-increasing number of available phylogenetic methods. Below, we
describe each of the fundamental questions regarding diversification
rates.

#### (1) Diversification-rate through time estimation

*What is the (constant) rate of diversification in my study group?* The
most basic models estimate parameters of the stochastic-branching
process (*i.e.,* rates of speciation and
extinction, or composite parameters such as net-diversification and
relative-extinction rates) under the assumption that rates have remained
constant across lineages and through time;
*i.e.,* under a constant-rate birth-death
stochastic-branching process model {% cite Nee1994b %}. Extensions to the
(basic) constant-rate models include diversification-rate variation
through time {% cite Stadler2011} {% cite Hoehna2015a %}. First, we might ask whether
there is evidence of an episodic, tree-wide increase in diversification
rates (associated with a sudden increase in speciation rate and/or
decrease in extinction rate), as might occur during an episode of
adaptive radiation. A second question asks whether there is evidence of
a continuous/gradual decrease in diversification rates through time
(associated with decreasing speciation rates and/or increasing
extinction rates), as might occur because of diversity-dependent
diversification (*i.e.,* where competitive
ecological interactions among the species of a growing tree decrease the
opportunities for speciation and/or increase the probability of
extinction, *e.g.,* {% cite Hoehna2014a %}). Third, we
can ask whether changes in diversification rates are correlated with
environmental factors, such as environmental CO~2~ or temperature
{% cite Condamine2013 %}. A final question in this category asks whether our
study tree was impacted by a mass-extinction event (where a large
fraction of the standing species diversity is suddenly lost,
*e.g.,* {% cite May2016 %}). The common theme of these
studies is that the diversification process is tree-wide, that is, all
lineages of the study group have the exact same rates at a given time.

#### (2) Diversification-rate variation across branches estimation

*Is there evidence that diversification rates have varied significantly
across the branches of my study group?* Models have been developed to
detect departures from rate constancy across lineages; these tests are
analogous to methods that test for departures from a molecular
clock—*i.e.,* to assess whether substitution
rates vary significantly across lineages {% cite Alfaro2009 Rabosky2014a %}.
These models are important for assessing whether a given tree violates
the assumptions of rate homogeneity among lineages. Furthermore, these
models are important to answer questions such as: *What are the
branch-specific diversification rates?*; and *Have there been
significant diversification-rate shifts along branches in my study
group, and if so, how many shifts, what magnitude of rate-shifts and
along which branches?*

#### (3) Character-dependent diversification-rate estimation

*Are diversification rates correlated with some variable in my study
group?* Character-dependent diversification-rate models aim to identify
overall correlations between diversification rates and organismal
features (binary and multi-state discrete morphological traits,
continuous morphological traits, geographic range, etc.). For example,
one can hypothesize that a binary character, say if an organism is
herbivorous/carnivorous or self-compatible/self-incompatible, impact the
diversification rates. Then, if the organism is in state 0
(*e.g.,* is herbivorous) it has a lower (or
higher) diversification rate than if the organism is in state 1
(*e.g.,* carnivorous) {% cite Maddison2007 %}.

Diversification Rate Models {#sec:models}
===========================

We begin this section with a general introduction to the stochastic
birth-death branching process that underlies inference of
diversification rates in RevBayes. This primer will provide some
details on the relevant theory of stochastic-branching process models.
We appreciate that some readers may want to skip this somewhat technical
primer; however, we believe that a better understanding of the relevant
theory provides a foundation for performing better inferences. We then
discuss a variety of specific birth-death models, but emphasize that
these examples represent only a tiny fraction of the possible
diversification-rate models that can be specified in RevBayes.

The birth-death branching process
---------------------------------

Our approach is based on the *reconstructed evolutionary process*
described by {% cite Nee1994b %}; a birth-death process in which only sampled,
extant lineages are observed. Let $N(t)$ denote the number of species at
time $t$. Assume the process starts at time $t_1$ (the 'crown' age of
the most recent common ancestor of the study group, $t_\text{MRCA}$)
when there are two species. Thus, the process is initiated with two
species, $N(t_1) = 2$. We condition the process on sampling at least one
descendant from each of these initial two lineages; otherwise $t_1$
would not correspond to the $t_\text{MRCA}$ of our study group. Each
lineage evolves independently of all other lineages, giving rise to
exactly one new lineage with rate $b(t)$ and losing one existing lineage
with rate $d(t)$ (Figure [fig:BirthDeathShift] and
Figure [fig:BDP]). Note that although each lineage evolves
independently, all lineages share both a common (tree-wide) speciation
rate $b(t)$ and a common extinction rate $d(t)$
{% cite Nee1994b cite Hoehna2015a %}. Additionally, at certain times,
$t_{\mathbb{M}}$, a mass-extinction event occurs and each species
existing at that time has the same probability, $\rho$, of survival.
Finally, all extinct lineages are pruned and only the reconstructed tree
remains (Figure [fig:BirthDeathShift]).

![A realization of the birth-death process with mass extinction.
Lineages that have no extant or sampled descendant are shown in gray and
surviving lineages are shown in a thicker black line.<span
data-label="fig:BirthDeathShift">](\ResourcePath figures/BirthDeathShift.pdf){width="80.00000%"}

> ![](figures/BirthDeathShift.png) 
> A realization of the
birth-death process with mass extinction. Lineages that have no extant
or sampled descendant are shown in gray and surviving lineages are shown
in a thicker black line. 
{:.figure}

![ The process is initiated at the first speciation event (the
'crown-age' of the MRCA) when there are two initial lineages. At each
speciation event the ancestral lineage is replaced by two descendant
lineages. At an extinction event one lineage simply terminates. (A) A
complete tree including extinct lineages. (B) The reconstructed tree of
tree from A with extinct lineages pruned away. (C) A *uniform* subsample
of the tree from B, where each species was sampled with equal
probability, $\rho$. (D) A *diversified* subsample of the tree from B,
where the species were selected so as to maximize diversity.<span
data-label="fig:BDP">](\ResourcePath figures/birth-death-sketch.pdf){width="\textwidth"}

> ![](figures/birth-death-sketch.png) 
> **Examples of
trees produced under a birth-death process.** The process is
initiated at the first speciation event (the 'crown-age' of the MRCA)
when there are two initial lineages. At each speciation event the
ancestral lineage is replaced by two descendant lineages. At an
extinction event one lineage simply terminates. (A) A complete tree
including extinct lineages. (B) The reconstructed tree of tree from A
with extinct lineages pruned away. (C) A *uniform* subsample of the tree
from B, where each species was sampled with equal probability, $\rho$.
(D) A *diversified* subsample of the tree from B, where the species were
selected so as to maximize diversity. 
{:.figure}

To condition the probability of observing the branching times on the
survival of both lineages that descend from the root, we divide by
$P(N(T) > 0 | N(0) = 1)^2$. Then, the probability density of the
branching times, $\mathbb{T}$, becomes $$\begin{aligned}
P(\mathbb{T}) = \fra\frac{}{b}ace{P(N(T) = 1 \mid N(0) = 1)^2}^{\text{both initial lineages have one descendant}}}{ \underbrace{P(N(T) > 0 \mid N(0) = 1)^2}_{\text{both initial lineages survive}} } \times \prod_{i=2}^{n-1\frac{ }{b}ace{i \times b(t_i)}^{\text{speciation rate}} \time\frac{ }{b}ace{P(N(T) = 1 \mid N(t_i) = 1)}^\text{lineage has one descendant},\end{aligned}$$
and the probability density of the reconstructed tree (topology and
branching times) is then $$\begin{aligned}
P(\Psi) = \; & \frac{2^{n-1}}{n!(n-1)!} \times \left( \frac{P(N(T) = 1 \mid N(0) = 1)}{P(N(T) > 0 \mid N(0) = 1)} \right)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} i \times b(t_i) \times P(N(T) = 1 \mid N(t_i) = 1)
	\label{eq:tree_probability}\end{aligned}$$

We can expand Equation ([eq:tree_probability]) by substituting
$P(N(T) > 0 \mid N(t) =1)^2 \exp(r(t,T))$ for
$P(N(T) = 1 \mid N(t) = 1)$, where $r(u,v) = \int^v_u d(t)-b(t)dt$; the
above equation becomes $$\begin{aligned}
P(\Psi) = \; & \frac{2^{n-1}}{n!(n-1)!} \times \left( \frac{P(N(T) > 0 \mid N(0) =1 )^2 \exp(r(0,T))}{P(N(T) > 0 \mid N(0) = 1)} \right)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} i \times b(t_i) \times P(N(T) > 0 \mid N(t_i) = 1)^2 \exp(r(t_i,T)) \nonumber\\
		= \; & \frac{2^{n-1}}{n!} \times \Big(P(N(T) > 0 \mid N(0) =1 ) \exp(r(0,T))\Big)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} b(t_i) \times P(N(T) > 0 \mid N(t_i) = 1)^2 \exp(r(t_i,T)).
		\label{eq:tree_probability_substitution}\end{aligned}$$ For a detailed
description of this substitution, see {% cite Hoehna2015a %}. Additional
information regarding the underlying birth-death process can be found in
@Thompson1975 [Equation 3.4.6] and {% cite Nee1994b %} for constant rates and
{% cite Hoehna2013} {% cite Hoehna2014a} {% cite Hoehna2015a %} for arbitrary rate functions.

To compute the equation above we need to know the rate function,
$r(t,s) = \int_t^s d(x)-b(x) dx$, and the probability of survival,
$P(N(T)\!>\!0|N(t)\!=\!1)$. {% cite Yule1925 %} and later {% cite Kendall1948 %} derived
the probability that a process survives ($N(T) > 0$) and the probability
of obtaining exactly $n$ species at time $T$ ($N(T) = n$) when the
process started at time $t$ with one species. Kendall's results were
summarized in Equation (3) and Equation (24) in {% cite Nee1994b %}
$$\begin{aligned}
P(N(T)\!>\!0|N(t)\!=\!1) & = & \left(1+\int\limits_t^{T} \bigg(\mu(s) \exp(r(t,s))\bigg) ds\right)^{-1} \label{eq:survival} \\ \nonumber \\
P(N(T)\!=\!n|N(t)\!=\!1) & = & (1-P(N(T)\!>\!0|N(t)\!=\!1)\exp(r(t,T)))^{n-1} \nonumber\\
& & \times P(N(T)\!>\!0|N(t)\!=\!1)^2 \exp(r(t,T)) \label{eq:N} $$ An
overview for different diversification models is given in
{% cite Hoehna2015a %}.

***Sidebar: Phylogenetic trees as observations***

The branching processes used here describe probability distributions on
phylogenetic trees. This probability distribution can be used to infer
diversification rates given an “observed” phylogenetic tree. In reality
we never observe a phylogenetic tree itself. Instead, phylogenetic trees
themselves are estimated from actual observations, such as DNA
sequences. These phylogenetic tree estimates, especially the divergence
times, can have considerable uncertainty associated with them. Thus, the
correct approach for estimating diversification rates is to include the
uncertainty in the phylogeny by, for example, jointly estimating the
phylogeny and diversification rates. For the simplicity of the following
tutorials, we take a shortcut and assume that we know the phylogeny
without error. For publication quality analysis you should always
estimate the diversification rates jointly with the phylogeny and
divergence times.

Estimating Speciation & Extinction Rates Through Time
=====================================================

Outline
-------

This tutorial describes how to specify an episodic branching-process
model in RevBayes; a birth-death process where diversification rates
vary episodically through time modeled as piecewise-constant rates
{% cite Stadler2011} {% cite Hoehna2015a %}. The probabilistic graphical model is given
once at the beginning of this tutorial. Your goal is to estimate
speciation and extinction rates through-time using Markov chain Monte
Carlo (MCMC).

Requirements
------------

We assume that you have read and hopefully completed the following
tutorials:

-   [Getting
    started](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Getting_Started/RB_Getting_Started.pdf)

-   [Very Basic Introduction to
    `Rev`](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Intro_Tutorial/RB_Intro_Tutorial.pdf)

-   [General Introduction to the `Rev`
    syntax](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Rev_Tutorial/RB_Rev_Tutorial.pdf)

-   [General Introduction to MCMC using an archery
    example](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Archery_Tutorial/RB_MCMC_Archery_Tutorial.pdf)

-   [General Introduction to MCMC using a coin-flipping
    example](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Binomial_Tutorial/RB_MCMC_Binomial_Tutorial.pdf)

-   [Basic Diversification Rate
    Estimation](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_DiversificationRate_Tutorial/RB_DiversificationRate_Tutorial.pdf)

Note that the [`Rev` basics
tutorial](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Intro_Tutorial/RB_Intro_Tutorial.pdf)
introduces the basic syntax of `Rev` but does not cover any phylogenetic
models. We tried to keep this tutorial very basic and introduce all the
language concepts and theory on the way. You may only need the [`Rev`
syntax
tutorial](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_Rev_Tutorial/RB_Rev_Tutorial.pdf)
for a more in-depth discussion of concepts in `Rev`.

Data and files
==============

We provide the data file(s) which we will use in this tutorial. You may
want to use your own data instead. In the 'data' folder, you will find
the following files

-   'primates_tree.nex': Dated primates phylogeny including 233 out of
    367 species from {% cite MagnusonFord2012 %}.

Open the tree 'data/primates_tree.nex' in
`FigTree`.

Episodic Birth-Death Model
==========================

The basic idea behind the model is that speciation and extinction rates
are constant within time intervals but can be different between time
intervals. Thus, we will divide time into equally sized intervals, with
the only exception that the first 20% of the time does not have any rate
changes. Our only reason to do so is because there are too few lineages
in the reconstructed tree at that time to obtain reliable parameter
estimates. An overview of the underlying theory of the specific model
and implementation is given in {% cite Hoehna2015a %}.

> ![](figures/EBD_scenarios.png) 
> Two scenarios of
birth-death models. On the left we show constant diversification. On the
right we show an example of an episodic birth-death process where rates
are constant in each time interval (epoch). The top panel of this figure
shows an example realization under the given rates. 
{:.figure}

Figure [fig:EBD] shows an example of a constant rate birth-death
process and an episodic birth-death process.

We assume that the log-transformed rates are drawn from a normal
distribution. Furthermore, we will assume that rates are autocorrelated,
that is, rates in the current time interval will be centered around the
rates in the previous time interval. Thus, we model (log-transformed)
diversification rates by a Brownian motion. The assumption of
autocorrelated rates does not only makes sense biologically but also
improves our ability to estimate parameters.

> ![](figures/graphical_model_EBD.png) 
> A graphical model
with the outline of the `Rev` code. On the left we see the graphical
model describing the correlated (Brownian motion) model for
rate-variation through time. On the right we show the corresponding
`Rev` commands to instantiate this model. This figure gives a complete
overview of the model that we use here in this analysis. 
{:.figure}

We show a graphical model of the episodic birth-death process with
autocorrelated rates in Figure [fig:EBD_GM]. This graphical model
shows you which variables are included in the model, and the dependency
between the variables. Thus, it makes the structure and assumption of
the model clear and visible instead of a black-box {% cite Hoehna2014b %}. For
example, you see how the speciation and extinction rates in each time
interval depend on the rates of the previous interval, and that we use a
hyperprior for the standard deviation of rates between time intervals.

Read the tree
-------------

Begin by reading in the “observed” tree.

    T <- readTrees("data/primates_tree.nex")[1]

From this tree, we get some helpful variables, such as the taxon
information which we need to instantiate the birth-death process.

    taxa <- T.taxa()

Additionally, we initialize an iterator variable for our vector of moves
and monitors.

    mvi = 0
    mni = 0

Finally, we create a helper variable that specifies the number of
intervals.

    NUM_INTERVALS = 10

Using this variable we can easily change our script to break-up time
into many (*e.g.,*  `NUM_INTERVALS = 100`) or
few (*e.g.,*  `NUM_INTERVALS = 4`) intervals.

Specifying the model
--------------------

### Priors on amount of rate variation

We start by specifying prior distributions on the rates. Each
interval-specific speciation- and extinction-rate will be drawn from a
normal distribution. Thus, we need a parameter for the standard
deviation of those normal distributions. We use an exponential
hyperprior with rate 1.0 to estimate the standard deviation, but assume
that all speciation rates and all extinction rates share the same
standard deviation. The motivation for an exponential hyperprior is that
it has the highest probability density at 0 which would make the
variance of rates between consecutive time intervals 0 and thus
represent a constant-rate process. The data will tell us if there should
be much variation in rates through time. (You may want to experiment
with this hyperprior if you are interested.)

    speciation_sd ~ dnExponential(1.0)
    extinction_sd ~ dnExponential(1.0)

We apply a simple scaling move on each prior parameter.

    moves[++mvi] = mvScale(speciation_sd,weight=5.0)
    moves[++mvi] = mvScale(extinction_sd,weight=5.0)

### Specifying episodic rates

As we mentioned before, we will apply normal distributions as priors for
each log-transformed rate. We begin with the rate at the present which
is our initial rate parameter. The rates at the present will be
specified slightly differently because they are not correlated to any
previous rates. This is because we are actually modeling rate-changes
backwards in time and there is no previous rate for the rate at the
present. Modeling rates backwards in time makes it easier for us if we
had some prior information about some event affected diversification
sometime before the present, *e.g.,* 25 million
years ago.

We use a uniform distribution between -10 and 10 because of our lack of
prior knowledge on the diversification rate. This actually means that we
allow speciation and extinction rates between $e^{-10}$ and $e^10$, so
we should clearly cover the true values. (Note that for diversification
rate estimates, $e^{-10}$ is virtually 0 since the rate is so slow).

    log_speciation[1] ~ dnUniform(-10.0,10.0)
    log_speciation[1] ~ dnUniform(-10.0,10.0)

Notice that we store the diversification rate variables in vectors.
Storing the rate parameters in vectors will be useful and important
later when we pass the rates into the birth-death process.

We apply simple sliding window moves for the rates. Normally we would
use scaling moves but in this case we work on the log-transformed
parameters and thus sliding moves perform better. (If you are keen you
can test the differences.)

    moves[++mvi] = mvSlide(log_speciation[1], weight=2)
    moves[++mvi] = mvSlide(log_extinction[1], weight=2)

Now we transform the diversification rate parameters into actual rates
using an exponential parameter transformation.

    speciation[1] := exp( log_speciation[1] )
    extinction[1] := exp( log_extinction[1] )

Next, we specify the speciation and extinction rates for each time
interval (*i.e.,* epoch). This can be done
efficiently using a `for`-loop. We will use a specific index variable so
that we can more easily refer to the rate at the previous interval.
Remember that we want to model the rates as a Brownian motion, which we
achieve by specifying a normal distribution as the prior distribution on
the rates centered around the previous rate
(*i.e.,* the mean of the normal distribution is
equal to the previous rate).

    for (i in 1:NUM_INTERVALS) {
        index = i+1

        log_speciation[index] ~ dnNormal( mean=log_speciation[i], sd=speciation_sd )
        log_extinction[index] ~ dnNormal( mean=log_extinction[i], sd=extinction_sd )

        moves[++mvi] = mvSlide(log_speciation[index], weight=2)
        moves[++mvi] = mvSlide(log_extinction[index], weight=2)

        speciation[index] := exp( log_speciation[index] )
        extinction[index] := exp( log_extinction[index] )

    }

Finally, we apply moves that slide all values in the rate vectors,
*i.e.,* all speciation or extinction rates. We
will use an 'mvVectorSlide' move.

    moves[++mvi] = mvVectorSlide(log_speciation, weight=10)
    moves[++mvi] = mvVectorSlide(log_extinction, weight=10)

Additionally, we apply a 'mvShrinkExpand' move which changes the spread
of several variables around their mean.

    moves[++mvi] = mvShrinkExpand( log_speciation, sd=speciation_sd, weight=10 )
    moves[++mvi] = mvShrinkExpand( log_extinction, sd=extinction_sd, weight=10 )

Both moves considerably improve the efficiency of our MCMC analysis.

### Setting up the time intervals

In RevBayes you actually have the possibility to specify unequal time
intervals or even different intervals for the speciation and extinction
rate. This is achieved by providing a vector of times when each interval
ends. Here we simply break-up the most recent 80% of time since the root
in equal-length intervals.

    interval_times <- T.rootAge() * (1:NUM_INTERVALS) / (NUM_INTERVALS) * 0.8

This vector of times will be used for both the speciation and extinction
rates. Also, remember that the times of the intervals represent ages
going backwards in time.

### Incomplete Taxon Sampling

We know that we have sampled 233 out of 367 living primate species. To
account for this we can set the sampling parameter as a constant node
with a value of 233/367. For simplicity, and since almost all species
have been sampled, we assume *uniform* taxon sampling
{% cite Hoehna2011} {% cite Hoehna2014a %},

    rho <- T.ntips()/367

### Root age

The birth-death process requires a parameter for the root age. In this
exercise we use a fixed tree and thus we know the age of the tree.
Hence, we can get the value for the root from the @MagnusonFord2012
tree.

    root_time <- T.rootAge()

### The time tree

Now we have all of the parameters we need to specify the full episodic
birth-death model. We initialize the stochastic node representing the
time tree.

    timetree ~ dnEpisodicBirthDeath(rootAge=T.rootAge(), lambdaRates=speciation, lambdaTimes=interval_times, muRates=extinction, muTimes=interval_times, rho=rho, samplingStrategy="uniform", condition="survival", taxa=taxa)

You may notice that we explicitly specify that we want to condition on
survival. It is possible to change this condition to the *time of the
process* or *the number of sampled taxa* too.

Then we attach data to the 'timetree' variable.

    timetree.clamp(T)

Finally, we create a workspace object of our whole model using the
'model()' function.

    mymodel = model(speciation)

The 'model()' function traversed all of the connections and found all of
the nodes we specified.

Running an MCMC analysis
------------------------

### Specifying Monitors

For our MCMC analysis, we need to set up a vector of *monitors* to
record the states of our Markov chain. First, we will initialize the
model monitor using the 'mnModel' function. This creates a new monitor
variable that will output the states for all model parameters when
passed into a MCMC function.

    monitors[++mni] = mnModel(filename="output/primates_EBD.log",printgen=10, separator = TAB)

Additionally, we create four separate file monitors, one for each vector
of speciation and extinction rates and for each speciation and
extinction rate epoch (*i.e.,* the times when
the interval ends). We want to have the speciation and extinction rates
stored separately so that we can plot them nicely afterwards.

    monitors[++mni] = mnFile(filename="output/primates_EBD_speciation_rates.log",printgen=10, separator = TAB, speciation)
    monitors[++mni] = mnFile(filename="output/primates_EBD_speciation_times.log",printgen=10, separator = TAB, interval_times)
    monitors[++mni] = mnFile(filename="output/primates_EBD_extinction_rates.log",printgen=10, separator = TAB, extinction)
    monitors[++mni] = mnFile(filename="output/primates_EBD_extinction_times.log",printgen=10, separator = TAB, interval_times)

Finally, we create a screen monitor that will report the states of
specified variables to the screen with 'mnScreen':

    monitors[++mni] = mnScreen(printgen=1000, extinction_sd, speciation_sd)

### Initializing and Running the MCMC Simulation

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The 'mcmc()' function will
create our MCMC object:

    mymcmc = mcmc(mymodel, monitors, moves)

First, we will run a pre-burnin to tune the moves and to obtain starting
values from the posterior distribution.

    mymcmc.burnin(generations=10000,tuningInterval=200)

Now, run the MCMC:

    mymcmc.run(generations=50000)

When the analysis is complete, you will have the monitored files in your
output directory. You can then visualize the rates through time using
`R`using our package `Rev`Gadgets. If you don't have the
R-package `Rev`Gadgets installed, or if you have trouble with the
package, then please read the separate tutorial about the package.

Just start `R`in the main directory for this analysis and
then type the following commands:

    library(RevGadgets)

    tree <- read.nexus("data/primates_tree.nex")

    rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_speciation_times.log", speciation_rates_file = "output/primates_EBD_speciation_rates.log", extinction_times_file = "output/primates_EBD_extinction_times.log", extinction_rates_file = "output/primates_EBD_extinction_rates.log", tree, burnin=0.25,numIntervals=100)

    pdf("EBD.pdf")
    par(mfrow=c(2,2))
    rev.plot.output(rev_out,use.geoscale=FALSE)
    dev.off()

(Note, you may want to add a nice geological timescale to the plot by
setting 'use.geoscale=TRUE' but then you can only plot one figure per
page.)

The `Rev` file for performing this analysis:
['mcmc_EBD.Rev'](https://github.com/revbayes/revbayes_tutorial/raw/master/RB_DiversificationRate_Episodic_Tutorial/scripts/mcmc_EBD.Rev).

> ![](figures/EBD_10_Result.png) 
> Resulting
diversification rate estimations when using 10 intervals. You should
obtain similar results when you use 10 intervals. The estimated rates
might change when you use a different resolution,
*i.e.,* a different number of intervals. 
{:.figure}

Exercise 1
----------

-   Run an MCMC simulation to estimate the posterior distribution of the
    speciation rate and extinction rate.

-   Visualize the rate through time using `R`.

-   Do you see evidence for rate decreases or increases? What is the
    general trend?

-   Is there evidence for rate variation? Look at the estimates of
    `speciation_sd` and `extinction_sd`: Is there information in the
    data to change the estimates from the prior?

-   Run the analysis using a different number of intervals,
    *e.g.,* 5 or 50. How do the rates change?

Exercise 2
----------

-   In our results we see that the extinction rate is fairly constant.
    Modify the model by using a constant-rate for the extinction rate
    parameter but still let the speciation rate vary through time.

    -   Remove all previous occurrences of the extinction rates
        (*i.e.,* priors, parameters and moves).

    -   Specify a lognormal prior distribution on the constant
        extinction rate\
        ('extinction $\sim$ dnLognormal(-5,sd=2\*0.587405)')

    -   Add a move for the new extinction rate parameter\
        'moves[++mvi] = mvScale(extinction,weight=5.0)'.

    -   Remove the argument 'muTimes=interval_times' from the
        birth-death process.

-   How does this influence your estimated rates?

