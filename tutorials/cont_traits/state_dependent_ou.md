---
title: State-dependent Ornstein-Uhlenbeck Models
subtitle: Detecting adaptation to different discrete character states
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
- data/artiodactyla.tree
- data/artiodactyla_diet.nex
- data/artiodactyla_hypsodonty_index.nex
- scripts/mcmc_state_dependent_OU.Rev
- scripts/plot_state_dependent_OU.R
- scripts/plot_state_dependent_OU_helper.R
---

{% section Inferring adaptation of a continuous character to various discrete character states %}

This tutorial demonstrates how to specify an Ornstein-Uhlenbeck model with state-dependent rates of attraction ($\alpha$), optima ($\theta$), and diffusion variances ($\sigma^2$) to model continuous-character adaptation to different discrete character states.
We provide two probabilistic graphical models for this tutorial, which correspond to sequential and joint inference approaches respectively.
After specifying the model, you will estimate the parameters of the state-dependent Ornstein-Uhlenbeck process for each character state.

{% include_relative modules/state_dependent_OU_parameter_estimation.md %}

{% include_relative modules/state_dependent_OU_exercise_1.md %}
{% include_relative modules/state_dependent_OU_exercise_2.md %}
{% include_relative modules/state_dependent_OU_exercise_3.md %}
