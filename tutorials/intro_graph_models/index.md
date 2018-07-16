---
title: Introduction to Graphical Models
subtitle: An introduction to graphical models, probabilistic programming, and MCMC using a simple linear regression example.
authors:  Will Freyman
level: 0
order: 1
prerequisites:
- intro
index: false
redirect: false
---

Overview
========
{:.section}

[RevBayes](http://revbayes.com) uses a *graphical model* framework in
which all probabilistic models, including phylogenetic models,
are comprised of modular components that can be assembled in a myriad of ways.
[RevBayes](http://revbayes.com) provides a highly flexible language called `Rev`
that users employ to specify their own custom graphical models.

This tutorial is intended to be a gentle introduction on how to use `Rev` to specify graphical models.
Additionally we'll cover how to use `Rev` to specify the Markov chain Monte Carlo (MCMC) 
algorithms used to perform inference with the model.
We will focus on a simple linear regression example,
and use [RevBayes](http://revbayes.com) to estimate the posterior distributions of our parameters.

Why Graphical Models?
=====================
{:.section}

[RevBayes](http://revbayes.com) is a fundamental reconception of phylogenetic software.
Most phylogenetic software have default settings that allow a user to run an analysis
without truly understanding the assumptions of the model.
[RevBayes](http://revbayes.com), on the other hand, has no defaults and is a complete
blank slate when started. [RevBayes](http://revbayes.com) requires users to 
fully specify the model they want to use for their analysis.
This means the learning curve is steep, however there are a number of benefits:

1. Transparency:

2. Flexibility:

3. Modularity:

What is a Graphical Model?
==========================
{:.section}

{% figure graphicalmodel %}
<img src="figures/graphical_model.png" width="400" />  
{% figcaption %}
*Left: a graphical model in which 
the observed data points $X_i$ are conditionally independent given $\theta$.
Right: the same graphical model using plate notation to represent the $N$ repeated $X_i$.
These graphical models represents the joint probability distribution
$$p(\theta,X_1,\dots,X_N)$$.
Image from Murphy {% cite murphy2012machine -A %}*
{% endfigcaption %}
{% endfigure %}

A *graphical model* is a way to represent a joint multivariate probability distribution as a graph.
Here we mean *graph* in the mathematical sense of a set of nodes (vertices) and edges.

{% ref graphicalmodel %} illustrates the graphical model that represents the joint probability distribution

$$
\begin{aligned}
p(\theta,\mathcal{D}) = p(\theta) \Big[ \displaystyle\prod^N_{i=1} p(X_i|\theta) \Big],
\end{aligned}
$$

where $$\mathcal{D}$$ is the vector of observed data points $$X_1,\dots,X_N$$.

Probabilistic Programming
=========================
{:.section}



Linear Regression Example
=========================
{:.section}

Tutorial Format {#subsect:Exercise-Format}
---------------
{:.subsection}

This tutorial follows a specific format for issuing instructions and
information.

The boxed instructions guide you to complete tasks that are not part of the RevBayes syntax, but rather direct you to create directories or files or similar.

Information describing the commands and instructions will be written in paragraph-form before or after they are issued.

All command-line text, including all `Rev` syntax, are given in `monotype font`. Furthermore, blocks of `Rev` code that are needed to build the model, specify the analysis, or execute the run are given in separate shaded boxes. For example, we will instruct you to create a new variable called `n` that is equal to `10` using the `=` operator like this:

    n = 10

Create Your Script File
-----------------------
{:.subsection}

Make yourself familiar with the example script called [`linear_regression.Rev`](https://raw.githubusercontent.com/revbayes/) which shows the code for the following sections. Then, start a new and empty script in your text editor and follow each step provided as below.

Name the script file `my_linear_regression.Rev` or anything you’d like.


`Rev` Script Structure
----------------------
{:.subsection}

Metropolis-Hastings MCMC algorithm {% cite Metropolis1953 Hastings1970 %} 

1.  model specification

2.  MCMC algorithm


Bayesian Linear Regression
--------------------------
{:.subsection}


### Read in data

```
x_obs <- readDataDelimitedFile(file="data/x.csv", header=FALSE, delimiter=",")[1]
y_obs <- readDataDelimitedFile(file="data/y.csv", header=FALSE, delimiter=",")[1]
```



Improving MCMC Mixing
=====================
{:.section}


Prior Sensitivity
=================
{:.section}

Generative vs Discriminative Models
===================================
{:.section}

