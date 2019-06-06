---
title: Relaxed Ornstein-Uhlenbeck Models
subtitle: Estimating lineage-specific optima under Ornstein-Uhlenbeck evolution
authors: Michael R. May
level: 5
order: 7
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
- cont_traits/cont_trait_intro
- cont_traits/simple_ou
index: true
redirect: false
include_all: false
include_files:
- data/trees.nex
- data/traits.nex
- scripts/mcmc_relaxed_OU.Rev
- scripts/plot_relaxed_OU.R
---

{% section Estimating Branch-Specific Evolutionary Optima %}

This tutorial demonstrates how to specify an Ornstein-Uhlenbeck model where the optimal phenotype is allowed to vary over branches of a time-calibrated phylogeny {% cite Uyeda2014 %} using the datasets of (log) body-size across vertebrate clades from {% cite Landis2017%}. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the parameters of branch-specific Ornstein-Uhlenbeck evolution using reversible-jump Markov chain Monte Carlo (rjMCMC).

{% include_relative modules/relaxed_OU_parameter_estimation.md %}

{% include_relative modules/relaxed_OU_exercise_1.md %}
