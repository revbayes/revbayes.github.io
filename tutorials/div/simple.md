---
title: Simple Diversification Rate Estimation
subtitle: Comparing different constant-rate models of lineage diversification
authors:  Sebastian Höhna and Tracy Heath
level: 4
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
order: 0
index: true
software: true
title-old: RB_DiversificationRate_Tutorial
redirect: false
---

{% include_relative modules/simple_overview.md %}

{% include_relative modules/simple_intro.md %}


{% section Estimating Constant Speciation & Extinction Rates | bdp_rate_estimation %}

This tutorial describes how to specify basic branching-process models in
RevBayes; two variants of the constant-rate birth-death process
{% cite Yule1925 Kendall1948 Thompson1975 Nee1994b Rannala1996 Yang1997 Hoehna2015a %}.
The probabilistic graphical model is given for each component of this
tutorial. After each model is specified, you will estimate speciation
and extinction rates using Markov chain Monte Carlo (MCMC). Finally, you
will estimate the marginal likelihood of the model and evaluate the
relative support using Bayes factors.



{% include_relative modules/simple_Yule_parameter_estimation.md %}

{% include_relative modules/simple_exercise_1.md %}

{% include_relative modules/simple_Yule_marginal_likelihood_estimation.md %}

{% include_relative modules/simple_exercise_2.md %}

{% include_relative modules/simple_birth_death.md %}

{% include_relative modules/simple_exercise_3.md %}
