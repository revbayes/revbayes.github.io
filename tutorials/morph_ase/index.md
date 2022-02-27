---
title: Introduction to Discrete Morphology Evolution
subtitle: Overview of types of Analyses
authors:  Sebastian Höhna
level: 5
order: 0
prerequisites:
- intro
- mcmc
- ctmc
- morph_tree
exclude_files:
- data/pimates_morph.nex
- mcmc_ase_ERM.Rev
- mcmc_ase_freeK.Rev
- mcmc_ase_hrm_flex.Rev
- mcmc_ase_irrev.Rev
- mcmc_corr.Rev
- mcmc_corr_RJ.Rev
- mcmc_corr_iid.Rev
- mcmc_scm_hrm.Rev
- mcmc_scm_hrm_RJ.Rev
- mcmc_scm_hrm_RJk.Rev
- ml_ase_ERM.Rev
- ml_ase_freeK.Rev
- plot_anc_states.R
- plot_anc_states_all.R
- plot_anc_states_corr_RJ.R
- plot_anc_states_freeK.R
- plot_anc_states_hrm.R
- plot_anc_states_irrev.R
- plot_corr.R
- plot_hrm.R
- plot_hrm_rates.R
- plot_iid_rates.R
- plot_irrev.R
- plot_simmap.R
index: true
redirect: false
---



{% section Introduction %}

Discrete morphological models are not only useful for tree estimation,
as was done in Tutorial {% page_ref morph_tree %}, but also to ask specific questions about the evolution of the morphological character of interest.
Specifically, there are a few types of analyses that we might be interest in.
First, we can test different models of morphological evolution,
such as reversible and irreversible models, and estimate rates under these models.
For example, using an irreversible model of evolution, we can test, for example,
for Dollo's law of a complex character that can be lost but not gained again {% cite Goldberg2008 %}.

Additionally, we might be interest in ancestral state estimation,
or mapping transition on the phylogeny.
Commonly the central problem in statistical phylogenetics concerns *marginalizing* over all unobserved character histories that evolved along the branches of a given phylogenetic tree according to some model, $M$, under some parameters, $\theta$.
This marginalization yields the probability of observing the tip states, $X_\text{tip}$,
given the model and its parameters,
$P( X_\text{tip} | \theta, M ) = \sum_{X_\text{internal}} P( X_\text{internal}, X_\text{tip} \mid \theta, M )$.
One might also wish to find the probability distribution of ancestral state
configurations that are consistent with the tip state distribution,
$P( X_\text{internal} \mid X_\text{tip}, \theta, M )$, and to sample
ancestral states from that distribution.
This procedure is known as *ancestral state estimation*.

Finally, we might be interested in testing for correlated evolution between discrete morphological characters.
For example,

This tutorial will provide a discussion of modeling morphological characters
and ancestral state estimation, and will demonstrate how to perform such
Bayesian phylogenetic analysis using RevBayes {% cite Hoehna2016b %}.


### The data

>Create a directory on your computer for this tutorial.
>In this directory, create a subdirectory called **data**, and download the data files that you can find on the left of this page.
{:.instruction}

We have taken the phylogeny from {% citet MagnusonFord2012 %}, who took it from {% citet Vos2006 %} and then randomly resolved the polytomies using the method of {% citet Kuhn2011 %} and the trait data from {% citet Redding2010 %}. In the **data** folder, you should now have the following files:

-   [primates_tree.nex](data/primates_tree.nex):
    Dated primate phylogeny including 233 out of 367 species.
-   [primates_activity_period.nex](data/primates_activity_period.nex):
    A file with the coded character states for primate species activity time. This character has just two states: `0` = diurnal and `1` = nocturnal.
-   [primates_habitat.nex](data/primates_habitat.nex):
    A file with the coded character states for primate species habitay. This character has just two states: `0` = forest and `1` = savanna.
-   [primates_solitariness.nex](data/primates_solitariness.nex):
    A file with the coded character states for primate species social system type. This character has just two states: `0` = group living and `1` = solitary.
-   [primates_terrestrially.nex](data/primates_terrestrially.nex):
    A file with the coded character states for primate species terrestrially. This character has just two states: `0` = arboreal and `1` = terrestrial.
-   [primates_males.nex](data/primates_males.nex):
    A file with the coded character states for the number of males within a group per primate species. This character has four states: `0` = single male, `1` = single and multi male, and `2` = multi male.
-   [primates_mating_system.nex](data/primates_mating_system.nex):
    A file with the coded character states for primate species mating-system type. This character has four states: `0` = monogamy, `1` = polygyny, `2` = polygynandry, and `3` = polyandry.
-   [primates_diet.nex](data/primates_diet.nex):
    A file with the coded character states for primate species diet. This character has six states: `0` = frugivore, `1` = insectivore, `2` = folivore, `3` = gummnivore, `4` = omnivore, and `5` = gramnivore.

{% figure fig_fbdr_gm %}
<img src="figures/Primates_traits.png" width="500pt" />
{% figcaption %}
Primate phylogeny with traits displayed at the tips from {% citet MagnusonFord2012 %}.
{% endfigcaption %}
{% endfigure %}

### Scripts

For more complex models and analyses, it's useful to create separate Rev scripts that contain all the model parameters, moves, and functions for different model components (e.g. the substitution model and the clock model).

>Create another subdirectory called **scripts**.
{:.instruction}

In this tutorial, you will work primarily in your text editor and create a set of modular files that can be easily managed and interchanged. Examples of all the commands used to perform each analysis are also provided at the top of this page under **Scripts** but try to write the complete scripts yourself from the beginning to ensure you understand all the steps involved and the differences between setting up each analysis.

### Exercises

>Click on the first exercise to begin!
{:.instruction}

1. [Ancestral state estimation]({{ base.url }}/tutorials/morph_ase/ase)
2. [Testing for independent rates]({{ base.url }}/tutorials/morph_ase/ase_free)
3. [Testing for irreversibility]({{ base.url }}/tutorials/morph_ase/ase_irreversible)
4. [Stochastic Character Mapping and Testing for Rate Variation]({{ base.url }}/tutorials/morph_ase/scm_hrm)
5. [Testing for Correlation between Characters]({{ base.url }}/tutorials/morph_ase/corr)
