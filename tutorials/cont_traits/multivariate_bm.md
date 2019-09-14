---
title: Multivariate Brownian Motion
subtitle: Accounting for correlations among continuous traits
authors: Michael R. May
level: 6
order: 5
prerequisites:
- intro
- mcmc
- cont_traits/cont_trait_intro
- cont_traits/simple_bm
- cont_traits/relaxed_bm
index: true
redirect: false
include_all: false
include_files:
- data/haemulidae.nex
- data/haemulidae_trophic_traits.nex
- scripts/mcmc_multivariate_BM.Rev
- scripts/mcmc_relaxed_multivariate_BM.Rev
- scripts/plot_relaxed_multivariate_BM.R
---

{% section Estimating Correlated Evolution %}

This tutorial demonstrates how to specify a multivariate Brownian motion model for multiple continuous characters. Specifically, we'll use a parameter separation strategy to separate the relative rates of evolution among characters from the correlations among characters {% cite Caetano2017 %}. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the correlations among characters using Markov chain Monte Carlo (MCMC). We will then measure the strength of correlation among characters to determine if there is evidence that the characters are correlated.

{% include_relative modules/multivariate_BM_parameter_estimation.md %}

{% include_relative modules/multivariate_BM_exercise_1.md %}

{% include_relative modules/relaxed_multivariate_BM_parameter_estimation.md %}

{% include_relative modules/multivariate_BM_exercise_2.md %}
