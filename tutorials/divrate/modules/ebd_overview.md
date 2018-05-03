{% section Overview %}

This tutorial describes how to specify an episodic branching-process model in `RevBayes`; 
a birth-death process where diversification rates vary episodically through time 
modeled as piecewise-constant rates {% cite Stadler2011 Hoehna2015a %}.
The probabilistic graphical model is given once at the beginning of this tutorial.
Your goal is to estimate speciation and extinction rates through-time using 
Markov chain Monte Carlo (MCMC).

