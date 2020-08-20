---
title: Stepwise Bayesian inference of phylogeny
subtitle: A full analysis pipeline for phylogenetic inference using RevBayes
authors: Sebastian Höhna and Allison Hsiang
level: 3
order: 4
prerequisites:
- intro
- mcmc
include_all: false
index: true
redirect: false
---

Overview
========
{:.section}

This tutorial aims to guide you through our stepwise Bayesian inference pipeline using [RevBayes](http://revbayes.com). The exercises are based on a dataset of north american fireflies (genus *Photinus*) for which we have molecular sequence data for extant species. The material used in this tutorial is directly taken from three others that explore some of the topics in more detail.

* [Continuous Time Markov Models]({{ base.url }}/tutorials/ctmc/) written by Sebastian Höhna

In [exercises 1]({{ base.url }}/tutorials/step_bayes/unrooted_gene_trees) we'll use the molecular sequence data to infer the relationships among living species.
In [exercise 2]({{ base.url }}/tutorials/step_bayes/relaxed) we transform the branch lengths from units of substitution into units of time assuming a relaxed clock model.


### The data

>Create a directory on your computer for this tutorial.
>In this directory, create a subdirectory called **data**, and download the data files that you can find on the left of this page.
{:.instruction}

In the **data** folder, you should now have seven files.
Each file is a *fasta* formatted alignment of a different protein coding gene.


### Scripts

For more complex models and analyses, it's useful to create separate Rev scripts that contain all the model parameters, moves, and functions for different model components (e.g. the substitution model and the clock model).

>Create another subdirectory called **scripts**.
{:.instruction}

In this tutorial, you will work primarily in your text editor and create a set of modular files that can be easily managed and interchanged. Examples of all the commands used to perform each analysis are also provided at the top of this page under **Scripts** but try to write the complete scripts yourself from the beginning to ensure you understand all the steps involved and the differences between setting up each analysis.

### Exercises

>Click on the first exercise to begin!
{:.instruction}

1. [Estimating unrooted gene tree(s)]({{ base.url }}/tutorials/step_bayes/unrooted_gene_trees)
2. [Rooting and time calibrating the gene tree(s)]({{ base.url }}/tutorials/step_bayes/dating)
