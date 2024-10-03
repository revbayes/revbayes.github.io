---
title: Dating trees
subtitle: Estimating species divergence times using RevBayes
authors:  Rachel Warnock, Sebastian Höhna, Tracy Heath, April  Wright and Walker Pett
level: 3
order: 3
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

This tutorial aims to guide you through different options for calibrating species divergences to time using [RevBayes](http://revbayes.com). The exercises are based on a dataset of bears (family Ursidae) for which we have molecular sequence data for extant species, morphological data for extant and fossil species, and information about fossil sampling times. The material used in this tutorial is directly taken from three others that explore some of the topics in more detail.

* [Relaxed Clocks & Time Trees]({{ base.url }}/tutorials/clocks/) written by Tracy Heath
* [Divergence Time Calibration](https://github.com/revbayes/revbayes_tutorial/blob/master/tutorial_TeX/RB_DivergenceTime_Calibration_Tutorial/) written by Tracy Heath and Sebastian Höhna
* [Estimating a Time-Calibrated Phylogeny of Fossil and Extant Taxa using Morphological Data]({{ base.url }}/tutorials/fbd_simple/) written by Joëlle Barido-Sottani, Joshua Justison, April M. Wright, Rachel C. M. Warnock, Walker Pett, and Tracy A. Heath

In [exercises 1]({{ base.url }}/tutorials/dating/global) and [2]({{ base.url }}/tutorials/dating/relaxed) we'll use the molecular sequence data to infer the relationships among living species and transform the branch lengths assuming a strict or relaxed clock model. Since these analyses don't incorporate any information from the geological record, this approach can only be used to infer the *relative* age of speciation events. 

In [exercises 3]({{ base.url }}/tutorials/dating/nodedate) and [4]({{ base.url }}/tutorials/dating/fbdr) we'll use information from the fossil record to calibrate the tree to *absolute* time using two different approaches to calibration (node dating versus the fossilized birth-death process). Finally, in [exercise 5]({{ base.url }}/tutorials/dating/tefbd) we'll also incorporate the morphological data to infer the relationships and divergence times among living and fossil bear species (total-evidence dating).

### The data

>Create a directory on your computer for this tutorial.
>In this directory, create a subdirectory called **data**, and download the data files that you can find on the left of this page.
{:.instruction}

In the **data** folder, you should now have the following files:

-   **bears_cytb.nex**: an alignment in NEXUS format of 1,000 bp of
    cytochrome b sequences for 8 living bear species. 
    
-   **bears_morphology.nex**: a matrix of 62 discrete, binary (coded `0`
    or `1`) morphological characters for 18 species of fossil and
    extant bears.

-   **bears_taxa.tsv**: a tab-separated table listing every bear species
    (both fossil and extant) and their stratigraphic age ranges. For extant taxa, the minimum age is 0.0 (i.e. the present).

### Scripts

For more complex models and analyses, it's useful to create separate Rev scripts that contain all the model parameters, moves, and functions for different model components (e.g. the substitution model and the clock model).

>Create another subdirectory called **scripts**.
{:.instruction}

In this tutorial, you will work primarily in your text editor and create a set of modular files that can be easily managed and interchanged. Examples of all the commands used to perform each analysis are also provided at the top of this page under **Scripts** but try to write the complete scripts yourself from the beginning to ensure you understand all the steps involved and the differences between setting up each analysis.

### Exercises

>Click on the first exercise to begin!
{:.instruction}

1. [The global molecular clock model]({{ base.url }}/tutorials/dating/global)
2. [The uncorrelated exponential relaxed clock model]({{ base.url }}/tutorials/dating/relaxed)
3. [Estimating speciation times using node dating]({{ base.url }}/tutorials/dating/nodedate)
4. [Estimating speciation times using the fossilized birth-death process]({{ base.url }}/tutorials/dating/fbd_simple)
