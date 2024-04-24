---
title: Debugging your Markov chain Monte Carlo (MCMC)
subtitle: Practical guidelines for issues with MCMC for Bayesian phylogenetic inference
authors: Joëlle Barido-Sottani, Orlando Schwery, Rachel C. M. Warnock, Chi Zhang, April Marie Wright
level: 1
order: 0
index: true
prerequisites:
- intro
redirect: false
---

Overview
========
{:.section}

Markov Chain Monte Carlo is a common method for approximating the posterior distribution of parameters in a mathematical model. Despite how well-used the method is, many researchers have misunderstandings about how the method works. This leads to difficulties with diagnosing issues with MCMC analyses when they arise.

This tutorial closely follows the text of this paper, which describes strategies for troubleshooting MCMC. We assume that you have completed the introductory MCMC tutorials, and will not be covering the basic mechanics of the MCMC algorithm. This tutorial, instead, will focus on giving examples of issues that may impact the efficiency and convergence of your MCMC simulation, and will give strategies for solving this problems.
