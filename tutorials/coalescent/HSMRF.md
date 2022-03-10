---
title: Skyline Models with HSMRF
subtitle: Estimating Demographic Histories with Skyline Models using a Horsehoe Markov Random Field Prior
authors: Ronja Billenstein and Sebastian Höhna
level: 9 #may need adjustment
order: 0.7
prerequisites:
- coalescent
- coalescent/GMRF
index: false
include_all: false
include_files:
- data/horses_homochronous_sequences.fasta
- scripts/mcmc_homochronous_HSMRF.Rev
---

{% section Overview %}
This page provides you with the script for a Horseshoe Markov Random Field (HSMRF) skyline analysis on the left side.
It is in addition to the [Gaussian Markov Random Field Prior tutorial]({{base.url}}/tutorials/coalescent/GMRF).

{% section Results %}
After running your analysis, you can plot the results using the `R` package `RevGadgets`.

{% figure example_HSMRF %}
<img src="figures/horses_HSMRF.png" width="800">
{% figcaption %}
This is how the resulting HSMRF plot should roughly look like.
{% endfigcaption %}
{% endfigure %}
