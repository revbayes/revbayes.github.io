---
title: Simple Brownian Rate Estimation
subtitle: Estimating rates of Brownian-motion evolution
authors: Michael R. May
level: 6
order: 1
prerequisites:
- intro
- mcmc
- cont_traits/cont_trait_intro
index: true
redirect: false
include_all: false
include_files:
- data/trees.nex
- data/traits.nex
- scripts/mcmc_BM.Rev
---

{% section Estimating Constant Rates of Evolution %}

This tutorial demonstrates how to specify a Brownian-motion model where the rate of evolution is assumed to be constant among branches of a time-calibrated phylogeny {% cite Felsenstein1985a %} using the datasets of (log) body-size across vertebrate clades from {% cite Landis2017%}. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the rate of Brownian-motion evolution using Markov chain Monte Carlo (MCMC).

{% include_relative modules/simple_BM_parameter_estimation.md %}

{% include_relative modules/simple_BM_exercise_1.md %}
