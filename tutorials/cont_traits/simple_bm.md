---
title: Simple Brownian Rate Estimation
subtitle: Estimating rates of Brownian-motion evolution
authors: Michael R. May
level: 6
order: 1.1
prerequisites:
- intro
- intro/revgadgets
- mcmc
- cont_traits/cont_trait_intro
index: true
redirect: false
include_all: false
include_files:
- data/primates_tree.nex
- data/primates_cont_traits.nex
- scripts/plot_BM.R
- scripts/mcmc_BM.Rev
- scripts/mcmc_BM_prior.Rev
---

{% section Estimating Constant Rates of Evolution %}

This tutorial demonstrates how to specify a Brownian-motion model where the rate of evolution is assumed to be constant among branches of a time-calibrated phylogeny {% cite Felsenstein1985a %}. We provide the probabilistic graphical model representation of each component for this tutorial. After specifying the model, you will estimate the rate of Brownian-motion evolution using Markov chain Monte Carlo (MCMC).


### The data

>Create a directory on your computer for this tutorial.
>In this directory, create a subdirectory called **data**, and download the data files that you can find on the left of this page.
{:.instruction}

We have taken the phylogeny from {% citet MagnusonFord2012 %}, who took it from {% citet Vos2006 %} and then randomly resolved the polytomies using the method of {% citet Kuhn2011 %} and the trait data from {% citet Redding2010 %}. In the **data** folder, you should now have the following files:

-   [primates_tree.nex](data/primates_tree.nex):
    Dated primate phylogeny including 233 out of 367 species.
-   [primates_cont_traits.nex](data/primates_cont_traits.nex):
    A file with the primates continuous data.

The dataset includes:
-   **Female Mass**: Body mass in grams of adult female, log-transformed, mean measurement.
-   **Tail Length – Body Length Residuals**: The residuals of linear model of tail length (cm) and body length (cm), sqrt-transformed, mean measurement
-   **Body Length – Mass Residuals**: The residuals of linear model of body length (cm) and adult female mass (g), sqrt-transformed, mean measurement
-   **Maximum Age**: Maximum age reported in years, log-transformed, mean measurement
-   **Sexual Dimorphism**: Adult male average weight divided by adult female average weight, log-transformed, mean measurement
-   **Geographic Range Size**: Geographical extent (km2) of species' occurrence, log-transformed
-   **Latitudinal Midpoint**: Latitude of species’ geographic range mid-point, sqrt-transformed
-   **Distance to Continental Centroid**: Distance of geographic range mid-point to mid-point of the combined area of all species found in that continent
-   **Population Density**: Average number of individuals per km2, log-transformed
-   **Home Range Size**: Size in m2 of group or individual's land use, log-transformed
-   **Group Size**: Number of individuals in social group, log-transformed
-   **Gestation Duration**: Duration in months of gestation periods, mean measurement
-   **Litter size**: Size of litter, mean measurement


{% include_relative modules/simple_BM_parameter_estimation.md %}

{% include_relative modules/simple_BM_exercise_1.md %}



>Click below to begin the next exercise!
{:.instruction}

* [Relaxed Brownian Rate Estimation]({{ base.url }}/tutorials/cont_traits/relaxed_bm)
