---
title: Introduction to Diversification Rate Estimation
subtitle: Overview of Analyses, Models and Theory
authors:  Sebastian Höhna
level: 7
order: 0
prerequisites:
- intro
- mcmc
index: true
title-old: RB_DiversificationRate_Tutorial
redirect: false
include_all: false
---

{% section Overview: Diversification Rate Estimation | diversification_rate_overview %}


Stochastic branching models allow for inference of speciation and
extinction rates. In these tutorials we focus on the different types of macroevolutionary
models to study diversification processes and thus the
diversification-rate parameters themselves.


{% subsection Types of Hypotheses for Estimating Diversification Rates %}

Macroevolutionary diversification rate estimation focuses on different key hypothesis,
which may include:
adaptive radiation, diversity-dependent and character diversification, key innovations, and
mass extinction.
We classify these hypotheses primarily into questions whether diversification rates vary through time,
and if so, whether some external, global factor has driven diversification rate changes, or if
diversification rates vary among lineages, and if so, whether some species specific factor is correlated with
the diversification rates.

Below, we describe each of the fundamental questions regarding diversification rates.

{% subsubsection (1) Constant diversification-rate estimation %}

*What is the global rate of diversification in my phylogeny?*
The most basic models estimate parameters of the birth-death process
(*i.e.*, rates of speciation and extinction, or composite parameters
such as net-diversification and relative-extinction rates)
under the assumption that rates have remained constant across lineages and through time.
This is the most basic example and should be treated as a primer and introduction into the topic.

For more information, we recommend the {% page_ref divrate/simple %}.


{% subsubsection (2) Diversification rate variation through time %}

*Is there diversification rate variation through time in my phylogeny?*
There are several reasons why diversification rates for the entire study group can vary through time, for example:
adaptive radiation, diversity dependence and mass-extinction events.
We can detect a signal any of these causes by detecting diversification rate variation through time.

The different tutorials references below cover different scenarios for diversification rate variation through time.
The common theme of these studies is that the diversification process is tree-wide, that is,
all lineages of the study group have the exact same rates at a given time.


{% subsubsection (2a) Detecting diversification rate variation through time %}

In RevBayes we use an episodic birth-death model to study diversification rate variation through time.
That is, we assume that diversification rates are constant within an epoch but may shift between episodes ({% citet Stadler2011 Hoehna2015a %}).
Then, we are estimating the diversification rates for each episode, and thus diversification rate variation through time.

You can find examples and more information in the {% page_ref divrate/ebd %}.


{% subsubsection (2b) Detecting the impact of mass-extinction events on diversification %}

Another question in this category asks whether our study tree was impacted by a mass-extinction event
(where a large fraction of the standing species diversity is suddenly lost, e.g., {% citet Hoehna2015a May2016 Magee2021 %}).
That is, we infer and test for the impact of instantaneous mass extinction events where each species alive at the given time has a probability of survival of the event.

You can find examples and more information in the {% page_ref divrate/efbdp_me %}.


{% subsubsection (2c) Diversification-rate correlation to environmental (e.g., abiotic) factors %}

*Are diversification rates correlated with some abiotic (e.g., environmental) variable in my phylogeny?*
If we have found evidence in the previous section that diversification rates vary through time,
then we can start asking the question whether these changes in diversification
rates are driven by some abiotic (e.g., environmental) factors.
For example, we can ask whether changes in diversification rates are correlated with
environmental factors, such as environmental CO<sub>2</sub> or temperature {% cite Condamine2013 Condamine2018 %}.

You can find examples and more information in the {% page_ref divrate/env %}.


{% subsubsection (3) Diversification-rate variation across branches estimation %}
*Is there evidence that diversification rates have varied across the branches of my phylogeny?*
Have there been significant diversification-rate shifts along branches in my phylogeny,
and if so, how many shifts, what magnitude of rate-shifts and along which branches?
Similarly, one may ask what are the branch-specific diversification rates?

You can study diversification rate variation among lineages using our birth-death-shift process {% cite Hoehna2019 %}.
Examples and more information is provided in the {% page_ref divrate/branch_specific %}.


{% subsubsection (4) Character-dependent diversification-rate estimation %}
If we have found that there is rate variation among lineage, then we could ask if
diversification rates correlated with some biotic (e.g., morphological) variable.
This can be addressed by using character-dependent birth-death models
(often also called state-dependent speciation and extinction models; SSE models).
Character-dependent diversification-rate models aim to identify
overall correlations between diversification rates and organismal
features (binary and multi-state discrete morphological traits,
continuous morphological traits, geographic range, etc.). For example,
one can hypothesize that a binary character, say if an organism is
herbivorous/carnivorous or self-compatible/self-incompatible, impact the
diversification rates. Then, if the organism is in state 0 (e.g., is herbivorous)
it has a lower (or higher) diversification rate than if the organism is in state 1 (e.g., carnivorous) {% cite Maddison2007 %}.

You can find examples and more information in the {% page_ref sse/bisse-intro %}.





{% section Diversification Rate Models | models %}


We begin this section with a general introduction to the stochastic
birth-death branching process that underlies inference of
diversification rates in RevBayes. This primer will
provide some details on the relevant theory of stochastic-branching
process models. We appreciate that some readers may want to skip this
somewhat technical primer; however, we believe that a better
understanding of the relevant theory provides a foundation for
performing better inferences. We then discuss a variety of specific
birth-death models, but emphasize that these examples represent only a
tiny fraction of the possible diversification-rate models that can be
specified in RevBayes.

{% subsection The birth-death branching process %}


{% figure fig_birth_death_shift %}
<img src="figures/BirthDeathShift.png" width="50%" height="50%" />
{% figcaption %}
A realization of the birth-death process with mass extinction.
Lineages that have no extant or sampled descendant are shown in gray and
surviving lineages are shown in a thicker black line.
{% endfigcaption %}
{% endfigure %}

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
with rate $d(t)$ ({% ref fig_birth_death_shift %} and
{% ref fig_bdp %}). Note that although each lineage evolves
independently, all lineages share both a common (tree-wide) speciation
rate $b(t)$ and a common extinction rate $d(t)$
{% cite Nee1994b Hoehna2015a %}. Additionally, at certain times,
$t_{\mathbb{M}}$, a mass-extinction event occurs and each species
existing at that time has the same probability, $\rho$, of survival.
Finally, all extinct lineages are pruned and only the reconstructed tree
remains ({% ref fig_birth_death_shift %}).

{% figure fig_bdp %}
<img src="figures/birth-death-sketch.png" width="75%" height="75%" />
{% figcaption %}
**Examples of trees produced under a birth-death process.**
The process is initiated at the first speciation event (the 'crown-age' of the MRCA)
when there are two initial lineages. At each speciation event the ancestral lineage is replaced by two
descendant lineages. At an extinction event one lineage simply
terminates. (A) A complete tree including extinct lineages. (B) The
reconstructed tree of tree from A with extinct lineages pruned away. (C)
A *uniform* subsample of the tree from B, where each species was sampled
with equal probability, $\rho$. (D) A *diversified* subsample of the
tree from B, where the species were selected so as to maximize diversity.
{% endfigcaption %}
{% endfigure %}

To condition the probability of observing the branching times on the
survival of both lineages that descend from the root, we divide by
$P(N(T) > 0 | N(0) = 1)^2$. Then, the probability density of the
branching times, $\mathbb{T}$, becomes

$$\begin{aligned}
P(\mathbb{T}) = \frac{\overbrace{P(N(T) = 1 \mid N(0) = 1)^2}^{\text{both initial lineages have one descendant}}}{ \underbrace{P(N(T) > 0 \mid N(0) = 1)^2}_{\text{both initial lineages survive}} } \times \prod_{i=2}^{n-1} \overbrace{i \times b(t_i)}^{\text{speciation rate}} \times \overbrace{P(N(T) = 1 \mid N(t_i) = 1)}^\text{lineage has one descendant},
\end{aligned}$$

and the probability density of the reconstructed tree (topology and branching times) is then

$$\begin{aligned}
P(\Psi) = \; & \frac{2^{n-1}}{n!(n-1)!} \times \left( \frac{P(N(T) = 1 \mid N(0) = 1)}{P(N(T) > 0 \mid N(0) = 1)} \right)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} i \times b(t_i) \times P(N(T) = 1 \mid N(t_i) = 1)
		  \label{eq:tree_probability}
\end{aligned}$$

We can expand Equation ([eq:tree_probability]) by substituting
$P(N(T) > 0 \mid N(t) =1)^2 \exp(r(t,T))$ for
$P(N(T) = 1 \mid N(t) = 1)$, where $r(u,v) = \int^v_u d(t)-b(t)dt$; the
above equation becomes

$$\begin{aligned}
P(\Psi) = \; & \frac{2^{n-1}}{n!(n-1)!} \times \left( \frac{P(N(T) > 0 \mid N(0) =1 )^2 \exp(r(0,T))}{P(N(T) > 0 \mid N(0) = 1)} \right)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} i \times b(t_i) \times P(N(T) > 0 \mid N(t_i) = 1)^2 \exp(r(t_i,T)) \nonumber\\
		= \; & \frac{2^{n-1}}{n!} \times \Big(P(N(T) > 0 \mid N(0) =1 ) \exp(r(0,T))\Big)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} b(t_i) \times P(N(T) > 0 \mid N(t_i) = 1)^2 \exp(r(t_i,T)).
		\label{eq:tree_probability_substitution}
\end{aligned}$$

For a detailed description of this substitution, see {% citet Hoehna2015a %}. Additional
information regarding the underlying birth-death process can be found in
{% citet Thompson1975 %} [Equation 3.4.6] and {% citet Nee1994b %} for constant rates and
{% citet Hoehna2013 Hoehna2014a Hoehna2015a %} for arbitrary rate functions.

To compute the equation above we need to know the rate function,
$r(t,s) = \int_t^s d(x)-b(x) dx$, and the probability of survival,
$P(N(T)\!>\!0|N(t)\!=\!1)$.
{% citet Yule1925 %} and later {% citet Kendall1948 %} derived the
probability that a process survives ($N(T) > 0$) and the probability of
obtaining exactly $n$ species at time $T$ ($N(T) = n$) when the process
started at time $t$ with one species. Kendall's results were summarized
in Equation (3) and Equation (24) in {% citet Nee1994b %}

$$\begin{aligned}
P(N(T)\!>\!0|N(t)\!=\!1) & = & \left(1+\int\limits_t^{T} \bigg(\mu(s) \exp(r(t,s))\bigg) ds\right)^{-1} \label{eq:survival} \\ \nonumber \\
P(N(T)\!=\!n|N(t)\!=\!1) & = & (1-P(N(T)\!>\!0|N(t)\!=\!1)\exp(r(t,T)))^{n-1} \nonumber\\
& & \times P(N(T)\!>\!0|N(t)\!=\!1)^2 \exp(r(t,T)) \label{eq:N} %\\
%P(N(T)\!=\!1|N(t)\!=\!1) & = & P(N(T)\!>\!0|N(t)\!=\!1)^2 \exp(r(t,T)) \label{eq:1}
\end{aligned}$$

An overview for different diversification models is given in {% citet Hoehna2015a %}.

{% aside Phylogenetic trees as observations %}
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
{% endaside %}
