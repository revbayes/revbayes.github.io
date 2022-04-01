---
title: Coalescent Models with a Compound Poisson Prior
subtitle: Estimating Demographic Histories with Coalescent Models using a Compound Poisson Prior
authors: Ronja Billenstein and Sebastian Höhna
level: 9
order: 0.9
prerequisites:
- coalescent
- coalescent/skyline
- coalescent/GMRF
index: false
include_all: false
include_files:
- data/horses_isochronous_sequences.fasta
- scripts/mcmc_isochronous_CPP.Rev
- scripts/mcmc_isochronous_CPP_maptreebased.Rev
---

{% section Overview %}
This page provides you with scripts for a coalescent analysis with a compound poisson prior on the left side.
It is in addition to the [Gaussian Markov Random Field Prior tutorial]({{base.url}}/tutorials/coalescent/GMRF).

{% section Results %}
After running your analysis, you can plot the results using the `R` package `RevGadgets`.

{% figure results-CPP %}
<img src="figures/horses_iso_CPP.png" width="800">
{% figcaption %}
Example output from plotting the CPP analysis. The bold line represents the median of the posterior distribution of the population size and the shaded are shows the $95\%$ credible intervals.
{% endfigcaption %}
{% endfigure %}
