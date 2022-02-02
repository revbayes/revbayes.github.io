---
title: Skyline Models with HSMRF
subtitle: Estimating Demographic Histories with Skyline Models using a Horsehoe Markov Random Field Prior
authors: Ronja Billenstein and Sebastian Höhna
level: 4 #may need adjustment
order: 0.3
prerequisites:
- coalescent
- coalescent/GMRF
index: false
include_all: false
include_files:
- data/horses_homochronous_sequences_nooutgroup.fasta
- scripts/mcmc_homochronous_HSMRF.Rev
---

{% section Overview %}
This page provides you with the script for a Horseshoe Markov Random Field (HSMRF) skyline analysis on the left side.
It is in addition to the [Gaussian Markov Random Field Prior tutorial]({{base.url}}/tutorials/coalescent/GMRF)