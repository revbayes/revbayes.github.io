---
title: Branch-Specific Diversification Rate Estimation
subtitle: How to estimate branch-specific shifts in diversification rates 
authors:  Sebastian Höhna and Michael R. May
level: 4
order: 0
index: true
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
- diversification_rate_simple
title-old: RB_DiversificationRate_BranchSpecific_Tutorial
redirect: false
---


Estimating Branch-Specific Speciation & Extinction Rates
========================================================

Outline
-------

This tutorial describes how to specify a branch-specific
branching-process models in RevBayes; a birth-death process where
diversification rates vary among branches, similar to {% cite Rabosky2014a %}.
The probabilistic graphical model is given for each component of this
tutorial. The goal is to obtain estimate of branch-specific
diversification rates using Markov chain Monte Carlo (MCMC).

