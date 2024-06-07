---
title: Sequential Bayesian inference of phylogeny
subtitle: Example sequential Bayesian analysis for divergence time estimation in RevBayes
authors: Sebastian Höhna
level: 3
order: 4
prerequisites:
- intro
- mcmc
exclude_files:
- scripts/mcmc_ultrametric_partitioned.Rev
- scripts/mcmc_ultrametric.Rev
- scripts/mcmc_unrooted_concatenation.Rev
- scripts/mcmc_unrooted_gene_tree.Rev
index: true
redirect: false
---

Overview
========
{:.section}

This tutorial aims to guide you through our sequential (or stepwise) Bayesian inference pipeline using [RevBayes](http://revbayes.com) {% cite Hoehna2024 %}. The exercises are based on a dataset of North American fireflies (genus *Photinus*) for which we have molecular sequence data for extant species {% cite Catalan2022 %}. Our goal is to estimate a time-calibrated phylogeny using a relaxed clock model. The two steps in our sequential Bayesian analysis are first to estimate the posterior distribution of phylogenies with branch lengths, and second to use these samples to infer a time-calibrated phylogeny.

In [exercises 1]({{ base.url }}/tutorials/sequential_bayes/unrooted_gene_trees) we'll use the molecular sequence data to infer the relationships among living species.
In [exercise 2]({{ base.url }}/tutorials/sequential_bayes/stepwise_dating) we transform the branch lengths from units of substitution into units of time assuming a relaxed clock model.


### The data

>Create a directory on your computer for this tutorial.
>In this directory, create a subdirectory called **data**, and download the data files that you can find on the left of this page.
{:.instruction}

In the **data** folder, you should now have seven files.
Each file is a *fasta* formatted alignment of a different protein coding gene.
In the tutorial we are only going to use a single gene, COI, but as an exercise you should repeat the analysis with another gene and also with all genes concatenated together as a partitioned analysis.


### Scripts

For more complex models and analyses, it's useful to create separate Rev scripts that contain all the model parameters, moves, and functions for different model components (e.g., the substitution model and the clock model).

>Create another subdirectory called **scripts**.
{:.instruction}

In this tutorial, you will work primarily in your text editor and create a set of modular files that can be easily managed and interchanged. Examples of all the commands used to perform each analysis are also provided at the top of this page under **scripts** but try to write the complete scripts yourself from the beginning to ensure you understand all the steps involved and the differences between setting up each analysis.

### Exercises

>Click on the first exercise to begin!
{:.instruction}

1. [Estimating unrooted gene tree(s)]({{ base.url }}/tutorials/sequential_bayes/unrooted_gene_trees)
2. [Rooting and time calibrating the gene tree(s)]({{ base.url }}/tutorials/sequential_bayes/stepwise_dating)
