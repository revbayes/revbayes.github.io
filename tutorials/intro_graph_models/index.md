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

1. Transparency: All the modeling assumptions are explicitly specified in [RevBayes](http://revbayes.com). The `Rev` script that runs an analysis makes these assumptions clear and can be easily shared. The assumptions can easily be modified in the `Rev` script and then the analysis can be rerun to see how changes affect the results. There is no reliance on "defaults" that may change with different versions of the software.

2. Flexibility: Users are not limited by a small set of models the programmers hard coded, instead users can specify their own custom models uniquely tailored to their hypotheses and datasets. 

3. Modularity: Each model component can be combined with others in an endless number of new ways like a LEGO kit. Testing many complex evolutionary hypotheses require tying different models together. For example, suppose you wish to test how the effect of biographic range on trait evolution changes through time. In [RevBayes](http://revbayes.com) you could simultaneously infer a time-calibrated phylogeny and estimate biogeography-dependent trait evolution using molecular data, biogeographic range data, and morphological data from both fossils and extant lineages.

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
See {% ref legend %} for a description of the visual symbols.
Image from {% citet murphy2012machine %}*
{% endfigcaption %}
{% endfigure %}

A *graphical model* is a way to represent a joint multivariate probability distribution as a graph.
Here we mean *graph* in the mathematical sense of a set of nodes (vertices) and edges.
In a graphical model, the nodes represent variables and the edges represent conditional dependencies among the variables. 
There are three important types
of variables:

1. Constant nodes: represents a fixed value that will not change. 
2. Stochastic nodes: represents a random variable with a value drawn from a probability distribution.
3. Deterministic nodes: represents a deterministic transformation of the values of other nodes.

In the graphical modeling framework observed data is simply a variable with an observed value.
To specify that a node has an observed value associated with it we say that the
node is *clamped*, or fixed, to the observed value.
{% ref graphicalmodel %} illustrates the graphical model that represents the joint probability distribution

$$
\begin{aligned}
p(\theta,\mathcal{D}) = p(\theta) \Big[ \displaystyle\prod^N_{i=1} p(X_i|\theta) \Big],
\end{aligned}
$$

where $$\mathcal{D}$$ is the vector of observed data points $$X_1,\dots,X_N$$.

Nearly any probabilistic model can be represented as a graphical model: neural networks, classification models, time series models, and of course phylogenetic models!
In some literature the terms Bayesian networks, belief networks, or causal networks are sometimes used to refer to graphical models.


Visual Representation
---------------------
{:.subsection}

The statistics literature has developed a rich visual representation for graphical models.
Visually representing graphical models can be useful for communication and pedagogy.
We will mention the notation used in this visual representation here only briefly 
(see {% ref legend %}),
and enourage readers to see {% citet Hoehna2014b %} for more details.
Representing graphical models in computer code (like the `Rev` language)
will likely be the most useful aspects of graphical models to most readers.

{% figure legend %}
<img src="figures/graphical_model_legend.png" width="400" />  
{% figcaption %}
*The symbols for a visual representation of a graphical
model. a) Solid squares represent constant nodes, which specify fixed-
valued variables. b) Stochastic nodes are represented by solid circles.
These variables correspond to random variables and may depend on
other variables. c) Deterministic nodes (dotted circles) indicate variables
that are determined by a specific function applied to another variable.
They can be thought of as variable transformations. d) Observed states
are placed in clamped stochastic nodes, represented by gray-shaded
circles. e) Replication over a set of variables is indicated by enclosing
the replicated nodes in a plate (dashed rectangle). f) A tree plate. 
Represents the different classes of nodes in a phylogeny. 
The tree topology orders the nodes in the tree plate and
may be a constant node (as in this example) or a stochastic node (if the
topology node is a solid circle).
Image and text modified from {% citet Hoehna2014b %}*
{% endfigcaption %}
{% endfigure %}

Phylogenetic Graphical Models
-----------------------------
{:.subsection}

In phylogenetics, observations about different species are not considered independent data points
due to their shared evolutionary history.
So in a phylogenetic probabilistic model the topology of the tree determines the conditional dependencies among variables. This can be represented as a graphical model as in {% ref phylo_graph %} (left).   

Phylogenetic models are often highly complex with hundreds of variables. Not only do we model
the conditional dependencies due to shared evolutionary history (the tree topology), 
but we also commonly model character evolution (nucleotide substitution models, etc.),
branching processes that determine the times between speciation events (birth-death processes),
and many other aspects of the evolutionary process.
With graphical models we can think of each part of these models as discrete components that can
be combined in a myriad of ways to assemble different phylogenetic models ({% ref phylo_graph %} right).

{% figure phylo_graph %}
<img src="figures/phylo_graphical.png" width="400"/><img src="figures/graphical_lego_kit.png" width="400"/>  
{% figcaption %}
*Left: In a phylogenetic probabilistic model the topology of the tree determines the conditional dependencies among variables.
Right: A complex phylogenetic model that includes a clock model, a GTR+$\Gamma$ nucleotide substitution model, and a uniform tree topology model. Here the repeated nodes within the tree are represented by a tree plate.
Images from {% citet Hoehna2014b %}*
{% endfigcaption %}
{% endfigure %}

Probabilistic Programming
=========================
{:.section}

To describe complex probabilistic models and perform computational tasks with them,
we need a way to formally specify the models in a computer. 
Probabilistic programming languages were designed exactly for this purpose.
A probabilistic programming language is a tool for probabilistic inference that:

1. formally specifies graphical models, and
2. specifies the inference algorithms used with the model.

Probabilistic programming languages are being actively developed within
the statistics and machine learning communities.
Some of the most common are <a href="http://mc-stan.org/">Stan</a>, <a href="http://mcmc-jags.sourceforge.net/">JAGS</a>, <a href="http://edwardlib.org/">Edward</a>, and <a href="https://docs.pymc.io/">PyMC3</a>.
While these are all excellent tools, they are all unsuitable for phylogenetic models 
since the tree topology itself must be treated as a random variable to be inferred.

The `Rev` Probabilistic Programming Language
--------------------------------------------
{:.subsection}

[RevBayes](http://revbayes.com) provides its own probabilistic programming language called `Rev`.
While `Rev` focuses on phylogenetic models, nearly any type of probabilistic
model can be programmed in `Rev` making it a highly flexible probabilistic computing environment.
Most `Rev` scripts consist of two different parts:

1. Model specification. This part of the script defines the constant, stochastic, and determinstic nodes that make up the model.
2. Inference algorithm specification. This part of the script specifies what sort of inference algorithm we want to use with the model. Typically this is a Markov chain Monte Carlo algorithm, and we need to specify what sort of proposals (or moves) will operate on each variable.

In more complex `Rev` scripts, these two different elements (model specification and infernence algorithm specification) will be woven together.
In the example for this tutorial we will keep the two parts separate.


Linear Regression Example
=========================
{:.section}

To demonstrate how to use the `Rev` language to specify a graphical model,
we will start with a simple non-phylogenetic model.
This tutorial will show both how to specify linear regression
as a graphical model, and how to perform Bayesian inference over
the model using MCMC.


Linear Regression as a Graphical Model
--------------------------------------
{:.subsection}


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

