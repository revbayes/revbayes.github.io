{% section Overview %}

This tutorial describes how to specify an episodic birth-death model in `RevBayes`.
The episodic birth-death model is a process where diversification rates vary episodically through time 
and are modeled as piecewise-constant rates {% cite Stadler2011 Hoehna2015a %}.
The probabilistic graphical model is given once at the beginning of this tutorial.
Your goal is to estimate speciation and extinction rates through-time using 
Markov chain Monte Carlo (MCMC).

You should read first the {% page_ref divrate/div_rate_intro %}
which explains the theory and gives some general overview of diversification rate estimation 
and {% page_ref divrate/simple %} which goes through a very simple pure birth and birth-death model
for estimating diversification rates.