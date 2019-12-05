---
title: A simple FBD analysis
subtitle: Joint inference of divergence times and phylogenetic relationships of fossil and extant taxa from morphological data
authors:  Tracy A. Heath, Josh Justison, Joëlle Barido-Sottani, and Walker Pett
level: 1
order: 15
prerequisites:
- intro
- mcmc
exclude_files:
index: true
redirect: false
---


{% section Overview | overview %}

This tutorial shows a simple phylogenetic analysis of extant and fossil bear species (family Ursidae), using morphological data as well as fossil occurrence data from the fossil record. 

{% section Introduction | introduction %}

{% section Setting up the analysis | analysis %}

In this section, we will create the RevLanguage script which will be used to run our phylogenetic analysis in RevBayes.

{% subsection Data and files %}

>On your own computer or your remote machine, create a directory called `RB_FBD_Tutorial`
>(or any name you like).
>
>Then, navigate to the folder you created and make a new one called `data`.
>
>Download the files listed below into the `data` folder, by clicking on the hyperlinked file names below (these files are also listed in the "Data files and scripts" box at the top of this page).
{:.instruction}

In the `data` folder, add the following files:

-   [`bears_taxa.tsv`](data/bears_taxa.tsv): a tab-separated table listing every bear species
    (both fossil and extant) and their occurrence age ranges (minimum and maximum ages). For extant taxa, the minimum age is 0.0 (*i.e.* the present).

-   [`bears_morphology.nex`](data/bears_morphology.nex): a matrix of 62 discrete, binary (coded `0`
    or `1`) morphological characters for 18 species of fossil and extant bears.
    
> In the main directory created above, create a blank file called `FBD_tutorial.Rev` and open it in a text editor.
{:.instruction}

This file will be our main script, and will contain all the instructions required to load the data, assemble the different models used in the analysis, and finally configure and run the MCMC. Note that it is possible to split instructions between different Rev scripts, however in this tutorial we will use only one file to keep things simple.

{% assign mcmc_script = "FBD_tutorial.Rev" %}

{% subsection Importing the data into RevBayes %}

We will begin the Rev script by loading the two data files that were downloaded previously.

{{ mcmc_script | snippet:"block#","1" }}

The function `readTaxonData` reads a tab-delimited file. This command creates a variable called `taxa` which contains a table with all of the fossil and extant bear species names in the first column, their minimum age in the second column and their maximum age in the third column.

Next, we will import the morphological character matrix and assign it to the variable `morpho`.

{{ mcmc_script | snippet:"block#","2" }}

RevBayes uses the function `readDiscreteCharacterData` to load a data matrix to the workspace from a formatted file. This function can be used for both molecular sequences and discrete morphological characters.

{% subsection The Fossilized Birth-Death Process %}

{% subsection The morphological substitution model %}

{% subsection The morphological clock model %}

{% subsection Monitoring variables %}

{% subsection MCMC %}

{% section Results %}

{% subsection Evaluating convergence %}

{% subsection Summarizing the tree %}