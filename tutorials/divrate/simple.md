---
title: Simple Diversification Rate Estimation
subtitle: Comparing different constant-rate models of lineage diversification
authors:  Sebastian Höhna and Tracy Heath
level: 4
order: 1
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
- divrate/div_rate_intro
index: true
title-old: RB_DiversificationRate_Tutorial
redirect: false
exclude_files:
- scripts/mcmc_BD.Rev
- scripts/mcmc_CBDSP.Rev
- scripts/mcmc_EBD_Corr_RJ.Rev
- scripts/mcmc_EBD_Corr.Rev
- scripts/mcmc_EBD.Rev
- scripts/mcmc_IRC_BDSP.Rev
- scripts/mcmc_MRBD.Rev
- scripts/mcmc_Yule_prior.Rev
- scripts/ml_BD.Rev
- scripts/ml_MRBD.Rev
- scripts/plot.R
---


{% section Estimating Constant Speciation & Extinction Rates | bdp_rate_estimation %}

This tutorial describes how to specify basic branching-process models in
RevBayes; two variants of the constant-rate birth-death process
{% cite Yule1925 Kendall1948 Thompson1975 Nee1994b Rannala1996 Yang1997 Hoehna2015a %}.
The probabilistic graphical model is given for each component of this
tutorial. After each model is specified, you will estimate speciation
and extinction rates using Markov chain Monte Carlo (MCMC). Finally, you
will estimate the marginal likelihood of the model and evaluate the
relative support using Bayes factors.

You should read first the {% page_ref divrate/div_rate_intro %} tutorial, which explains the theory and 
gives some general overview of diversification rate estimation.


{% include_relative modules/simple_Yule_parameter_estimation.md %}

{% include_relative modules/simple_exercise_1.md %}

{% include_relative modules/simple_Yule_marginal_likelihood_estimation.md %}

{% include_relative modules/simple_exercise_2.md %}

{% include_relative modules/simple_birth_death.md %}

{% include_relative modules/simple_exercise_3.md %}
