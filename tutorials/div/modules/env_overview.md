{% section Overview %}

This tutorial describes how to specify a branching-process model with 
diversification rate correlated with an environmental variable in `RevBayes`.
Diversification rates are assumed to be equal among all lineages but vary through time 
correlated with an environmental predictor variable.
Thus, this model can be used to test for correlations between diversification rates 
and environmental variables, such as $\text{CO}_2$ and temperature.
However, these tests are only to establish a correlation, not a causality.

As usual, we provide the probabilistic graphical model at the beginning of this tutorial.
Hopefully this will help you to get a better idea of all the variables in the model and 
their dependencies.
Our goal in this tutorial is to estimate the correlation coefficient between speciation and 
extinction rates to historical $\text{CO}_2$ measurements using Markov chain Monte Carlo (MCMC).


