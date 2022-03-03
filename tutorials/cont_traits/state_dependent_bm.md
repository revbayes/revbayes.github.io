---
title: State-Dependent Brownian Rate Estimation
subtitle: Estimating state-dependent rates of Brownian-motion evolution
authors: Michael R. May
level: 6
order: 1.5
prerequisites:
- intro
- intro/revgadgets
- mcmc
- cont_traits/cont_trait_intro
- cont_traits/simple_bm
index: true
redirect: false
include_all: false
include_files:
- data/haemulidae.nex
- data/haemulidae_trophic_traits.nex
- data/haemulidae_habitat.nex
- scripts/mcmc_state_dependent_BM.Rev
- scripts/mcmc_relaxed_state_dependent_BM.Rev
- scripts/plot_relaxed_state_dependent_BM.R
---

{% section Estimating State-Dependent Rates of Evolution %}

This tutorial demonstrates how to estimate state-dependent rates of continuous-character
evolution. Specifically, we will specify a state-dependent rate model that assigns a
Brownian-motion rate parameter for each state of a discrete character. We provide the
probabilistic graphical model representation of each component for this tutorial. After
specifying the model, you will estimate the state-dependent rates of Brownian-motion
evolution using Markov chain Monte Carlo (MCMC).

You should read the {% page_ref cont_traits/simple_bm %} tutorial, which provides a
general introduction to simple Brownian-motion models, and {% page_ref morph_ase %},
which describes models of discrete-character evolution, before using this tutorial.


{% include_relative modules/state_dependent_BM_parameter_estimation.md %}

{% include_relative modules/state_dependent_BM_exercise_1.md %}

{% include_relative modules/state_dependent_BM_parameter_estimation_RJ.md %}

{% include_relative modules/state_dependent_BM_exercise_2.md %}

{% include_relative modules/state_dependent_BM_relaxed.md %}

{% include_relative modules/state_dependent_BM_exercise_3.md %}

>Click below to begin the next exercise!
{:.instruction}

* [Multivariate Brownian Motion]({{ base.url }}/tutorials/cont_traits/multivariate_bm)
