---
title: Coalescent Analyses
subtitle: Estimating Demographic Histories with Bayesian Coalescent Skyline Plot Models
authors: Ronja Billenstein and Sebastian Höhna
level: 9
order: 0
prerequisites:
- intro
- mcmc
- ctmc
- mcmc/moves
index: true
include_all: false
include_files:
- data/horses_isochronous_sequences.fasta
- data/horses_heterochronous_sequences.fasta
- data/horses_heterochronous_ages.tsv
---

> ## For your info
> This tutorial and the included exercises are currently under construction.
> If you want to run the analyses, please compile `RevBayes` from the [dev-coalescent](https://github.com/revbayes/revbayes/tree/dev-coalescent) branch as described [here](https://revbayes.github.io/compile-linux) (for the development branch).
{:.info}

{% section Overview %}
This tutorial describes how to run a demographic analysis using the coalescent process in `RevBayes`.
Demographic inference is about estimating population dynamics and in this tutorial, we will specifically focus on population size estimation.
The coalescent process provides a flexible way of estimating population size trajectories through time.
We are primarily interested in asking:
(1) what the population size for our given population was?
and (2) how population sizes have changed over time, *e.g.*, increased or decreased towards the present or experienced a bottleneck.
The input data are usually sequence alignments or estimated trees.
In case of sequence data, trees and population size parameters will be jointly estimated.
Here, we consider different types of analysis, starting with a constant demographic history and doing more complex analyses in later exercises.
The first analyses will consider data from isochronous samples, *i.e.*, data from samples that have all been collected at the same time.
In the second part of the exercises, you will be asked to also analyze data from heterochronous samples, *i.e.*, samples that have been collected at different points in time.
The data for these analyes are taken from {% citet Vershinina2021 %}.

<br>
<br>
<br>

The following table provides an overview of different coalescent models. The tutorials column links directly to the respective tutorial with isochronous data. The tutorial on [heterochronous data]({{base.url}}/tutorials/coalescent/heterochronous) shows how to apply the models to data from different points in time.

| Model                                                                                                                              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                    | Demographic function within intervals                | Prior on the population sizes                                                  | Interval change-point method                                 | Multiple loci analysis possible? | Tutorial                                                                                                                                                                         |
|------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Constant                                                                                                                           | A simple coalescent model with one constant population size.                                                                                                                                                                                                                                                                                                                                                                                   | constant                            | individually chosen                                                            | -                                                            | Yes                              | [Constant]({{base.url}}/tutorials/coalescent/constant)                                                                                                                           |
| Linear                                                                                                                             | A coalescent model with a linear population size trajectory.                                                                                                                                                                                                                                                                                                                                                                                   | linear                              | individually chosen                                                            | -                                                            | Yes                              |                                                                                                                                                                                  |
| Exponential                                                                                                                        | A coalescent model with an exponential population size trajectory.                                                                                                                                                                                                                                                                                                                                                                             | exponential                         | individually chosen                                                            | -                                                            | Yes                              |                                                                                                                                                                                  |
| Bayesian Skyline Plot without autocorrelation                                                                                      | A coalescent model with a piecewise constant population size trajectory. The different pieces (intervals) are not correlated. The times of interval change are dependent on coalescent events ("coalescent event based").                                                                                                                                                                                                                                 | piecewise constant                            | individually chosen, independent and identically distributed (iid)             | coalescent event based                                                            | No, only single loci                              | [Skyline]({{base.url}}/tutorials/coalescent/skyline)                                                                                                                             |
| Bayesian Skyline Plot with autocorrelation<br>{% cite Drummond2005 %}                                                              | A coalescent model with a piecewise constant population size trajectory. The different pieces (intervals) are correlated, each population size is drawn from an exponential distribution with the mean being the previous population size. The times of interval change are dependent on coalescent events ("coalescent event based").                                                                                                                    | piecewise constant                            | $\theta_i \| \theta_{i-1}$ (exponential distribution with mean $\theta_{i-1}$) | coalescent event based                                                  | No, only single loci             | Little description included in [skyline]({{base.url}}/tutorials/coalescent/skyline#secAltPriors)<br><br>[Example script](scripts/mcmc_isochronous_BSP.Rev)                       |
| Extended Bayesian Skyline Plot<br>{% cite Heled2008 %}                                                                             | A coalescent model with a piecewise constant or linear population size trajectory. The different pieces are not correlated. The times of interval change are dependent on coalescent events ("coalescent event based"), they are independent and identically distributed (iid). The number of changes and thus the number of intervals is determined by stochastic variable search.                                                                                   | piecewise constant or linear                            | independent and identically distributed (iid)                                  | coalescent event based - number and position of change points estimated | Yes                              | Little description included in [skyline]({{base.url}}/tutorials/coalescent/skyline#secAltPriors)<br><br>[Example script](scripts/mcmc_isochronous_EBSP.Rev)                      |
| Skyride<br>{% cite Minin2008 %}                                                                                                    | A coalescent model with a piecewise constant population size trajectory. The different pieces are correlated via a Gaussian Markov Random Field (GMRF) Prior, the degree of smoothing is determined by a precision parameter. The times of interval change are dependent on coalescent events ("coalescent event based").                                                                                                                                 | piecewise constant                            | $\theta_i \| \theta_{i-1}$ (GMRF Prior with precision parameter)               | coalescent event based                                                  | No, only single loci             | Little description included in [skyline]({{base.url}}/tutorials/coalescent/skyline#secAltPriors)<br><br>[Example script](scripts/mcmc_isochronous_skyride.Rev)                   |
| Skygrid<br>{% cite Gill2012 %}                                                                                                     | A coalescent model with a piecewise constant population size trajectory. The different pieces are correlated via a Gaussian Markov Random Field (GMRF) Prior and are equally spaced in time, the degree of smoothing is determined by a precision parameter. The times of interval change are independent from coalescent events, they are independent and identically distributed (iid). | piecewise constant                  | $\theta_i \| \theta_{i-1}$ (GMRF Prior with precision parameter)               | coalescent event independent - equally sized                                                | Yes                              |                                                                                                                                                                                  |
| Gaussian Markov Random Field (GMRF) Prior with interval change points independent from coalescent events  {% cite Faulkner2020 %}                          | A coalescent model with a piecewise constant or linear population size trajectory. The different pieces are correlated via a Gaussian Markov Random Field (GMRF) Prior. The times of interval change are independent from coalescent events, they are independent and identically distributed (iid).                                                                                                                                           | piecewise constant or linear                  | $\theta_i \| \theta_{i-1}$ (GMRF Prior)                                        | coalescent event independent, user-specified - here equally sized                               | Yes                              | With sequences as input data: [GMRF]({{base.url}}/tutorials/coalescent/GMRF)<br><br>With trees as input data: [GMRF treebased]({{base.url}}/tutorials/coalescent/GMRF_treebased) |
| Horseshoe Markov Random Field (HSMRF) Prior with interval change points independent from coalescent events {% cite Faulkner2020 %} | A coalescent model with a piecewise constant or linear population size trajectory. The different pieces are correlated via a Horseshoe Markov Random Field (HSMRF) Prior. The times of interval change are independent from coalescent events, they are independent and identically distributed (iid).                                                                                                                                         | piecewise constant or linear                  | $\theta_i \| \theta_{i-1}$ (HSMRF Prior)                                       | coalescent event independent, user-specified - here equally sized                               | Yes                              | Little description included in [GMRF]({{base.url}}/tutorials/coalescent/GMRF#secHSMRF)<br><br>Script in [HSMRF]({{base.url}}/tutorials/coalescent/HSMRF)                         |
| Skyfish model<br>(similar to {% citet OpgenRhein2005 %})                                                    | A coalescent model with a piecewise constant or linear population size trajectory. The number of pieces (intervals) is not fixed. A Poisson Prior is used on the number of interval change points, additional priors need to be defined for population sizes and change points. The number of change points is determined via reversible jump MCMC (rjMCMC).                                                                                   | piecewise constant or linear                  | independent and identically distributed (iid)                                  | coalescent event independent, number and position of change points estimated   | Yes                              | Little description included in [GMRF]({{base.url}}/tutorials/coalescent/GMRF#secCPP)<br><br>Script in [Skyfish]({{base.url}}/tutorials/coalescent/Skyfish)                               |
| Piecewise<br>(similar to {% citet Pybus2002%}, but with flexible combinations)                                                     | A coalescent model with user-defined demographic functions for a user-defined number of intervals. Base demographic functions included in RevBayes are constant, linear and exponential population size trajectories. These can be combined in an arbitrary way, but the most ancient one should always be constant due to computational reasons.                                                                                                           | piecewise constant, linear, or exponential; can be different for every interval | individually chosen, independent and identically distributed (iid)             | coalescent event independent, user-specified                              | No, only single loci             | [Piecewise]({{base.url}}/tutorials/coalescent/piecewise)                                                                                                                         |


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

The first five exercises work with isochronous data, the last one with heterochronous data:
1. [The constant coalescent model]({{base.url}}/tutorials/coalescent/Constant)
2. [The skyline model]({{base.url}}/tutorials/coalescent/Skyline)
3. [The Gaussian Markov Random Field (GMRF) model]({{base.url}}/tutorials/coalescent/GMRF)
4. [The Skyfish model]({{base.url}}/tutorials/coalescent/Skyfish)
5. [The GMRF model with trees as input data]({{base.url}}/tutorials/coalescent/GMRF_treebased)
6. [A piecewise model]({{base.url}}/tutorials/coalescent/piecewise)
7. [Heterochronous data]({{base.url}}/tutorials/coalescent/heterochronous)

{% section Summary %}
After doing all the exercises, you can compare the resulting population sizes.
Have a look at the [summary]({{base.url}}/tutorials/coalescent/summary).
