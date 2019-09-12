---
title: Relaxed Brownian Rate Estimation
subtitle: Estimating branch-specific rates of Brownian-motion evolution
authors: Michael R. May
level: 6
order: 3
prerequisites:
- intro
- mcmc
- cont_traits/cont_trait_intro
- cont_traits/simple_bm
index: true
redirect: false
include_all: false
include_files:
- data/trees.nex
- data/traits.nex
- scripts/mcmc_relaxed_BM.Rev
- scripts/plot_relaxed_BM.R
---

{% section Estimating Branch-Specific Rates of Evolution %}

This tutorial demonstrates how to specify a relaxed morphological clock model for continuous characters. Specifically, we will specify a ‘‘random local clock’’ model, which allows for a small number of shifts in rates across branches. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the branch-specific rates of Brownian-motion evolution using reversible-jump Markov chain Monte Carlo (rjMCMC).

{% include_relative modules/relaxed_BM_parameter_estimation.md %}

{% include_relative modules/relaxed_BM_exercise_1.md %}
