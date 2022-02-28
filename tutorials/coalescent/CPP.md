---
title: Skyline Models with a Compound Poisson Prior
subtitle: Estimating Demographic Histories with Skyline Models using a Compound Poisson Prior
authors: Ronja Billenstein and Sebastian Höhna
level: 9 #may need adjustment
order: 0.8
prerequisites:
- coalescent
- coalescent/skyline
- coalescent/GMRF
index: false
include_all: false
include_files:
- data/horses_homochronous_sequences.fasta
- scripts/mcmc_homochronous_CPP.Rev
- scripts/mcmc_homochronous_CPP_maptreebased.Rev
---

{% section Overview %}
This page provides you with scripts for a skyline analysis with a compound poisson prior on the left side.
It is in addition to the [Gaussian Markov Random Field Prior tutorial]({{base.url}}/tutorials/coalescent/GMRF).

{% section Results %}
After running your analysis, you can plot the results using the `R` package `RevGadgets`.

{% figure example_HSMRF %}
<img src="figures/horses_CPP.png" width="800">
{% figcaption %}
This is how the resulting rjMCMC plot should roughly look like.
{% endfigcaption %}
{% endfigure %}
