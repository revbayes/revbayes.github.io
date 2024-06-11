---
title: StairwayPlot Analyses
subtitle: Estimating Demographic Histories from SNP data with Bayesian StairwayPlot Approach
authors: Sebastian Höhna
level: 9
order: 1
prerequisites:
- intro
- mcmc
- ctmc
- mcmc/moves
index: true
include_all: false
include_files:
---

> ## For your info
> This tutorial and the included exercises are currently under construction.
> If you want to run the analyses, please compile `RevBayes` from the [dev_stairwayplot](https://github.com/revbayes/revbayes/tree/dev_stairwayplot) branch as described [here](https://revbayes.github.io/compile-linux) (for the development branch). The code should be available in the next release (RevBayes v1.2.5).
{:.info}

{% section Overview %}
This tutorial describes how to run a demographic analysis using the coalescent process in `RevBayes`.
The data for these analyses are taken from {% citet Catalan2024 %} and {% citet Hoehna2024b %}.

<br>
<br>
<br>


{% section Preparation %}

> In order to perform the different analyses in this tutorial, you will need to create a directory on your computer for this tutorial and download a few files.
{:.instruction}

{% subsection The Data %}

> In the tutorial directory on your computer, create a subdirectory called "data" and download the data files that you can find on the left of this page.
{:.instruction}

You should now have the following files in your data folder:

-   horses_isochronous_sequences.fasta: an alignment in FASTA format, containing sequences of 36 horse taxa, all sampled at the same time.

-   horses_heterochronous_sequences.fasta: an alignment in FASTA format, containing sequences of 173 horse taxa, sampled at various times.

-   horses_heterochronous_ages.tsv: a tab seperated table listing the heterochronous horse samples and their ages. For extant taxa, the minimum age is 0.0 (i.e. the present).


{% subsection The Scripts %}

It is useful to create `.Rev` scripts for the different analyes.
We will also provide a full script in every tutorial that you can easily run for the whole analysis.

> Please create a "scripts" directory in the tutorial directory.
{:.instruction}

{% subsection The Figures %}

The `R` package `RevGadgets` provides functionality for plotting `RevBayes` results.
In each exercise, you can plot the population size trajectories resulting from the different analyses.

> If you want to plot the results from the exercises, please create a "figures" directory in the tutorial directory and install the `R` package `RevGadgets`.
{:.instruction}

{% section Exercises %}

> You can begin by clicking on the first exercise!
{:.instruction}

If you want to turn back to this page, it is listed on the left as prerequisite in all the exercises.
The exercise for heterochronous data is based on the exercises for isochronous data.
It aims at highlighting the changes you have to make when considering samples with different ages.
It is therefore recommended to do the exercises for isochronous data first.
