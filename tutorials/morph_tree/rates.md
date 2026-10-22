---
title: Discrete morphology - Among-character rate variation
subtitle: Relaxing the assumption of a single rate across all characters
authors:  April M. Wright, Michael J. Landis, and Sebastian Höhna
level: 3
order: 2
prerequisites:
- intro
- mcmc
- ctmc
- morph_tree
include_all: false
include_files:
- data/bears.nex
- scripts/model_tree.Rev
- scripts/model_ACRV_gamma.Rev
- scripts/model_ACRV_lognormal.Rev
- scripts/mcmc_mkv_gamma.Rev
- scripts/mcmc_mkv_lognormal.Rev
index: false
redirect: false
---


{% section Introduction %}

In {% page_ref morph_tree %} we assumed that every character in our matrix
evolves at the same rate. This is a strong assumption: some characters
(e.g. an easily-lost bristle) may change far more readily than others
(e.g. a fundamental skeletal element). Ignoring this heterogeneity can
bias branch-length and topology estimates, in much the same way that
ignoring among-site rate variation biases estimates from molecular data.

This tutorial adds **among-character rate variation** (ACRV) to the Mkv
model from the previous page. We continue to use the same 18-taxon,
62-character bears dataset {% cite abella2011 %}, so that the effect of
adding ACRV can be judged directly against the previous page's results.


{% subsection Modeling Rate Variation %}

Just as with nucleotide data, we can allow each character's rate to be
drawn from a distribution of rate multipliers, discretized into a small
number of rate categories, each visited with equal probability. RevBayes
lets us discretize essentially any distribution we like; the most common
choice for molecular and morphological data alike is a Gamma
distribution, but we will also try a lognormal distribution as an
alternative.


{% section Example: Adding Gamma-Distributed Rate Variation | sec_acrv_gamma %}

>Create a new directory **scripts** (if you have not already), and create
>the Rev-script files **model_ACRV_gamma.Rev** and **mcmc_mkv_gamma.Rev**.
{:.instruction}

We will use a discretized Gamma distribution to place a prior on the
rate multipliers. The Gamma distribution has a single shape parameter,
`alpha_morpho`; low values of `alpha_morpho` correspond to strong rate
heterogeneity (most characters change slowly, a few change quickly),
while high values correspond to roughly equal rates across characters
(recovering the plain Mkv model as a limiting case). We use a uniform
prior between 0 and $10^8$, as recommended by {% citet Fabreti2023 %}, and
initialize the value at 1.0 to improve MCMC efficiency.
{% snippet scripts/model_ACRV_gamma.Rev %}
alpha_morpho ~ dnUniform( 0.0, 1E8 )
alpha_morpho.setValue( 1.0 )
rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )
{% endsnippet %}
As usual, we add a scaling move on the new parameter.
{% snippet scripts/model_ACRV_gamma.Rev %}
moves.append( mvScale(alpha_morpho, lambda=1, weight=2.0) )
{% endsnippet %}
The only change to the CTMC itself is that we now pass our discretized
rates in as the `siteRates` argument.
{% snippet scripts/model_ACRV_gamma.Rev %}
phyMorpho ~ dnPhyloCTMC(tree=phylogeny, siteRates=rates_morpho, Q=Q_morpho, type="Standard", coding="variable")
phyMorpho.clamp(morpho)
{% endsnippet %}

The rest of `mcmc_mkv_gamma.Rev` is identical to `mcmc_mkv.Rev` from the
previous page, except that it sources `model_ACRV_gamma.Rev` instead of
`model_Mkv.Rev`, and the output filenames are changed to `mkv_gamma.*` so
that they do not overwrite your previous results.
{% snippet scripts/mcmc_mkv_gamma.Rev %}
source("scripts/model_ACRV_gamma.Rev")
{% endsnippet %}

Run this analysis in RevBayes with `source("scripts/mcmc_mkv_gamma.Rev")`,
exactly as you did for the previous two scripts.


{% section Choose Your Own Adventure: A Lognormal Alternative | sec_acrv_lognormal %}

RevBayes makes it very natural to discretize *any* distribution you
might like to work with, not just the Gamma. As an exercise, try
replacing the Gamma-distributed rates with a discretized lognormal
distribution instead:
{% snippet scripts/model_ACRV_lognormal.Rev %}
alpha_morpho ~ dnUniform( 0.0, 1E6 )
alpha_morpho.setValue( 1.0 )
rates_morpho := fnDiscretizeDistribution( dnLognormal(ln(alpha_morpho), 0.01), 4 )
{% endsnippet %}
Everything else about the model and the MCMC analysis stays the same
(see `model_ACRV_lognormal.Rev` and `mcmc_mkv_lognormal.Rev` for the full,
runnable version). Load all three log files (`mkv`, `mkv_gamma`, and
`mkv_lognormal`) into `Tracer` and compare the likelihoods and the
posterior tree lengths: adding rate variation, in either form, should
improve the likelihood over the plain Mkv model, since some of the
excess homoplasy that the plain model could only explain by inflating
branch lengths can now instead be explained by a subset of characters
evolving faster.

When you are ready, move on to {% page_ref morph_tree/multistate %},
where we apply what we have learned so far to a matrix that mixes binary
and multistate characters.
