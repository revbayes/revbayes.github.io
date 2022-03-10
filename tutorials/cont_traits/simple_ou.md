---
title: Simple Ornstein-Uhlenbeck Models
subtitle: Estimating optima under Ornstein-Uhlenbeck evolution
authors: Michael R. May and Sebastian Höhna
level: 6
order: 1.7
prerequisites:
- intro
- intro/revgadgets
- mcmc
- cont_traits/cont_trait_intro
index: true
redirect: false
include_all: false
include_files:
- data/primates_tree.nex
- data/primates_cont_traits.nex
- scripts/mcmc_OU.Rev
- scripts/mcmc_OU_RJ.Rev
- scripts/plot_OU.R
- scripts/plot_OU_RJ.R
---

{% section Estimating Evolutionary Optima %}

This tutorial demonstrates how to specify an Ornstein-Uhlenbeck model where the optimal phenotype is assumed to be constant among branches of a time-calibrated phylogeny {% cite Hansen1997 Butler2004 %}. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the parameters of Ornstein-Uhlenbeck evolution using Markov chain Monte Carlo (MCMC).

{% include_relative modules/simple_OU_parameter_estimation.md %}

{% include_relative modules/simple_OU_exercise_1.md %}

{% include_relative modules/simple_OU_model_selection.md %}
