---
title: Tutorial modules
subtitle: Choosing the right tutorials for your analysis
level: 0
order: 0
index: false
---

This page is intended to guide users in assembling a set of tutorials that will help them learn 
how to use RevBayes for a given analysis. Each module lists the tutorials that focus on a particular 
topic, as well as those that will provide prerequisite knowledge or resources for deeper learning.    
We encourage users with no RevBayes experience to start with the **RevBayes fundamentals** module.

{% aside RevBayes fundamentals %}

This module is for users who have no experience with RevBayes. The tutorials contained here walk
the user through the basics of installing and using RevBayes, and some of the theory behind
RevBayes analyses.

- Pre-requisites: Basic knowledge on Bayesian statistics

1. [Getting started with RevBayes]({{ base.url }}/tutorials/intro/getting_started). This tutorial includes getting RevBayes working on your machine, and learning about the fundamentals of setting up models in the software.
2. MCMC fundamentals. Three tutorials lay out the basics of Markov Chain Monte Carlo analysis in RevBayes, using three different examples: [Airline fatalities]({{ base.url }}/tutorials/mcmc/poisson), [coin flips]({{ base.url }}/tutorials/mcmc/binomial), and [archery]({{ base.url }}/tutorials/mcmc/archery). It is recommended that absolute beginners go through all three.

By the end of this module, you should be able to build RevBayes, write simple Rev code, and build 
simple models on which to run MCMC analyses. From here, you can select the module(s) below that
best represent your interests and intended analyses.

{% endaside %}

{% aside Molecular phylogenetic inference %}

This module is intended for users looking to infer a phylogenetic tree using molecular (DNA) data.
Users will learn how to set up basic molecular evolution model, and be presented with more advanced
tutorials to tailor their learning to their desired analyses.

- Pre-requisites: **RevBayes fundamentals**

1. Theoretical background: [Understanding continuous-time Markov models]({{ base.url }}/tutorials/dice). This tutorial will get you up to speed with the theory behind molecular evolution models.
2. Basic molecular phylogenetic inference: [Nucleotide substitution models]({{ base.url }}/tutorials/ctmc). This tutorial will walk you through a simple example of molecular phylogeny inference.

- If interested in partitioning molecular data: [Partitioned data analysis]({{ base.url }}/tutorials/partition). 
- If interested in choosing between models of molecular evolution:
    1. [General introduction to model selection]({{ base.url }}/tutorials/model_selection_bayes_factors/bf_intro).
    2. [Model selection for one locus]({{ base.url }}/tutorials/model_selection_bayes_factors/bf_subst_model).
    3. [Model selection for partition models]({{ base.url }}/tutorials/model_selection_bayes_factors/bf_partition_model).

By the end of this module, you should be able to infer a phylogenetic tree with a simple molecular 
evolution model. Depending on your interests, you will also have learned about how to set up
partitioned models, and choose the best models for your dataset.

{% endaside %}

{% aside Morphological phylogenetic inference %}

This module is intended for users looking to infer a phylogenetic tree using morphological data.
Users will learn how to set up basic morphological evolution models, including for characters
with more than two states.

- Pre-requisites: **RevBayes fundamentals**

1. Theoretical background: [Understanding continuous-time Markov models]({{ base.url }}/tutorials/dice). This tutorial will get you up to speed with the theory behind morphological evolution models.
2. Morphological phylogenetics with binary traits: [Tree inference with discrete morphology]({{ base.url }}/tutorials/morph_tree). This tutorial will walk you through a simple example of morphological phylogeny inference, using only binary (i.e. two-state) characters.
3. Expanding your dataset: [Multistate characters]({{ base.url }}/tutorials/morph_tree/V2). This tutorial will teach you how to accommodate characters with more than two states in your morphological phylogenetics analyses.

{% endaside %}
