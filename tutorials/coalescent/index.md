---
title: Coalescent Analyses
subtitle: Estimating Demographic Histories with Coalescent Processes
authors: Ronja Billenstein and Sebastian Höhna
level: 8 #may need adjustment
order: 0
prerequisites:
- intro
- mcmc
- ctmc
index: true
include_all: false
include_files:
- data/horses_homochronous_sequences.fasta
- data/horses_heterochronous_sequences.fasta
- data/horses_heterochronous_ages.tsv
---

> ## For your info
> This tutorial and the included exercises are currently under construction.
{:.info}

{% section Overview %}
This tutorial describes how to run a demographic analysis using the coalescent process in `RevBayes`.
The coalescent process provides a flexible way of estimating population size trajectories through time.
We are primarily interested in asking:
(1) what the population size for our given population was?
and (2) how population sizes have changed over time, *e.g.*, increased or decreased towards the present or experienced a bottleneck.
The input data are usually sequence alignments or estimated trees.
Here, we consider different types of analysis, starting with a constant demographic history and doing more complex analyses in later exercises.
The first analyses will consider data from homochronous samples, *i.e.*, data from samples that have all been collected at the same time.
In the second part of the exercises, you will be asked to also analyze data from heterochronous samples, *i.e.*, samples that have been collected at different points in time.
The data for these analyes are taken from {% citet Vershinina2021 %}.


<!--- ### Why?! --->

<!---
{% subsection The Coalescent %}
The coalescent process is constructing a tree backwards in time.
Starting from the samples, lineages are merged (*i.e.* coalesced), always two at a time.
Under the coalescent process, the waiting time between two coalescent events is exponentially distributed and depends on the number of 'active' lineages and the effective population size $N_e$.
Active lineages are the ones that can coalesce, the number is reduced by one with every coalescent event.
The coalescent process was first introduced by Kingman in 1982 for a constant population size {% cite Kingman1982 %}.
Griffiths and Tavaré then extended the model to be applicable to varying population sizes {% cite Griffiths1994 %}.
--->
<!--- Also, samples from different ages can be included {% cite %}. (Should go to heterochronous part) --->

<!--- ### Add figure!! --->

{% section Preparation %}

In order to perform the different analyses in this tutorial, you will need to create a directory on your computer for this tutorial and download a few files.
{:.instruction}

{% subsection The Data %}

In the tutorial directory on your computer, create a subdirectory called "data" and download the data files that you can find on the left of this page.
{:.instruction}

You should now have the following files in your data folder:

-   horses_homochronous_sequences.fasta: an alignment in FASTA format, containing sequences of 36 horse taxa, all sampled at the same time.

-   horses_heterochronous_sequences.fasta: an alignment in FASTA format, containing sequences of 173 horse taxa, sampled at various times.

-   horses_heterochronous_ages.tsv: a tab seperated table listing the heterochronous horse samples and their ages. For extant taxa, the minimum age is 0.0 (i.e. the present).


{% subsection The Scripts %}

It is useful to create `.Rev` scripts for the different analyes.
We will also provide a full script in every tutorial that you can easily run for the whole analysis.

Please create a "scripts" directory in the tutorial directory.
{:.instruction}

{% section Exercises %}

You can begin by clicking on the first exercise!
{:.instruction}

If you want to turn back to this page, it is listed on the left as prerequisite in all the exercises.
The exercise for heterochronous data is based on the exercises for homochronous data.
It aims at highlighting the changes you have to make when considering samples with different ages.
It is therefore recommended to do the exercises for homochronous data first.

The first five exercises work with homochronous data, the last one with heterochronous data:
1. [The constant coalescent model]({{base.url}}/tutorials/coalescent/constant)
2. [The skyline model]({{base.url}}/tutorials/coalescent/skyline)
3. [The Gaussian Markov Random Field (GMRF) model]({{base.url}}/tutorials/coalescent/GMRF)
4. [The GMRF model with trees as input data]({{base.url}}/tutorials/coalescent/GMRF_treebased)
5. [A piecewise model]({{base.url}}/tutorials/coalescent/piecewise)

<!--- 6. [Heterochronous data]({{base.url}}/tutorials/coalescent/heterochronous) --->

{% section Summary %}
After doing all the exercises, you can compare the resulting population sizes.
Have a look at the [summary]({{base.url}}/tutorials/coalescent/summary).
