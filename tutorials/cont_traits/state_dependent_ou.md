---
title: State-dependent Ornstein-Uhlenbeck Models
subtitle: Detecting state-dependent evolutionary optima and rates of adaptation (work in progress)
authors: Priscilla Lau and Sebastian Höhna
level: 6
order: 1.9
prerequisites:
- intro
- intro/revgadgets
- mcmc
- cont_traits/cont_trait_intro
- cont_traits/simple_ou
- cont_traits/relaxed_ou

index: true
redirect: false
include_all: false
include_files:
- data/diprotodontia_tree.nex
- data/diprotodontia_discrete_diet.nex
- data/diprotodontia_discrete_island.nex
- data/diprotodontia_continuous.nex
- scripts/mcmc_state_dependent_OU.Rev
- scripts/plot_state_dependent_OU.R
- scripts/plot_helper_state_dependent_OU.R
---

{% section Inferring adaptation of a continuous character to various discrete selective regimes %}

This tutorial demonstrates how to specify an Ornstein-Uhlenbeck model where all parameters ($\alpha$, $\sigma^2$, and $\theta$) are allowed to vary depending on the state of a discrete character on a time-calibrated phylogeny {% cite LauInprep %}. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the parameters of the Ornstein-Uhlenbeck process for each state.

{% include_relative modules/state_dependent_OU_parameter_estimation.md %}

{% include_relative modules/state_dependent_OU_exercise_1.md %}
