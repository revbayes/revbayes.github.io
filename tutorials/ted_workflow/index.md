---
title: Total-evidence dating, model sensitivity, and model comparison
subtitle: An example analysis workflow for total-evidence dating analyses
authors: Michael R. May
level: 1
order: 1
prerequisites:
- intro
- mcmc
- ctmc
- bf_intro
- pps_data
- dating
- fbd_specimen
- morph_tree
exclude_files:
index: false
redirect: false
---

{% section Overview | overview %}

Total-evidence (or combined-evidence) dating allows us to estimate time-calibrated phylogenies for extinct and extant species in one coherent statistical framework.
In this framework, fossils are treated as tips in the phylogeny, and their phylogenetic position and branch lengths are inferred directly from morphological data rather than specified a priori.
While this relieves us from the difficult (sometimes impossible) task of deriving reliable fossil-calibration densities for use in node-dating, it requires us to specify a model that (in addition to the standard components of a phylogenetic model) describes how morphological characters evolve, and how lineages diversify and produce fossils over time.

As with all phylogenetic analyses (and divergence-time estimation in particular), inferences using total-evidence dating may be sensitive to the models we use.
Therefore, when applying total-evidence dating, it's a good idea to use different models to assess whether they affect your inferences, and if they do, to assess the relative and absolute performance of the different models.
The purpose of this tutorial is to help you manage the task of using a potentially large number of total-evidence dating models and assessing their performance, similar to the workflow we use for our own work {% cite May2021 %}.
It is intended to be adapted to new datasets, and to allow you to add or modify models as appropriate for your own analyses.

This tutorial is structured as follows.
In the first section ({% ref intro %}), we discuss the general structure of the total-evidence-dating model, and the organizational scheme of the analysis scripts we provide.
In the second section ({% ref MCMC %}), we show how to estimate the posterior distribution under a given model using Markov-chain Monte Carlo.
In the third section ({% ref sensitivity %}), we present some tools for assessing how much different modeling assumptions affect tree topologies and divergence-time estimates.
In the fourth section ({% ref bayes_factors %}), we show how to compare the relative fit of competing models using Bayes factors, which can be useful if posterior estimates are sensitive to different models.
In the final section ({% ref posterior_prediction %}), we show how to use posterior-predictive simulation to assess whether our models provide a good absolute (rather than relative) description of morphological evolution.


&#9888; **_This tutorial involves running many analyses and comparing many models. Be aware that it can take several hours to complete! We will also presume some familiarity with many aspects of phylogenetic modeling; be sure to refer to the prerequisites if you are not already familiar with the models we are using._**

{% subsubsection A note about `R` dependencies %}

Many of the post-processing steps in this tutorial require you to use `R`, especially the package `RevGadgets`.
Before you begin, you should make sure you have the following `R` package dependencies installed:
- `RevGadgets`
- `ggplot2`
- `ape`
- `phytools`
- `phangorn`
- `smacof`
- `gtools`
- `gridExtra`

You can install these packages in `R` using `install.packages(library name)`.
Consider doing the [RevGadgets tutorial]({{site.baseurl}}{% link tutorials/intro/revgadgets.md %}) if you're not comfortable working in `R`.

<!-- {% subsection Some comments on terminology %}

**Node dating**: This refers to calibrating trees using calibration densities assigned to particular nodes in the phylogeny. The calibration densities are often based on fossils that the researcher presumes belong to the clade in question, and the researcher must specify their belief about how long the clade could have existed before the appearance of the fossil.

**Tip dating**: Compared to node dating, tip dating involves treating fossils as tips in a phylogeny. The position of the fossils may either be constrained based on a researcher's belief about where the fossil belongs (see e.g. {% citet Heath2014 %}), or inferred from data (typically morphological characters).

**Total-evidence (or combined-evidence) dating**: Total-evidence dating refers to tip dating, where the phylogenetic position and branch lengths for fossils are inferred from morphological data (see e.g. {% citet Ronquist2012a %}).

**Fossilized birth-death process**: This is a stochastic process that models how lineages diversify (speciate and go extinct) and produce fossils over time. It is often used as part of a tip-dating analysis. {% citet Heath2014 %} introduced the fossilized birth-death process as a better way to specify to include temporal information for molecular (not total-evidence) divergence-time estimation. In contrast, {% citet Zhang2016 %} and {% citet Gavryushkina2016 %} used the fossilized birth-death process as a tree model for total-evidence dating. -->

{% include_relative sections/intro.md %}

{% include_relative sections/mcmc.md %}

{% include_relative sections/sensitivity.md %}

{% include_relative sections/bayes_factors.md %}

{% include_relative sections/pps.md %}

{% section Conclusion %}

This concludes the total-evidence-dating workflow tutorial!
We've shown you how to specify complex analyses in a generic way, that hopefully you can extend and modify to accommodate your own dataset.
We've also shown provided some examples of how to assess model sensitivity---the degree to which phylogenetic divergence-time estimates are sensitive to modeling choices---and how to compare models on both relative (Bayes factor) and absolute (posterior-predictive simulation) scales.
We encourage you to try this workflow out with your own dataset, and let us know how it goes!
For a more complete set of models and analyses, you can check out the supplemental archive of our Marattiales study, which explored a larger number of models and model combinations that we presented here at our [GitHub supplemental repository](https://github.com/mikeryanmay/marattiales_supplemental).



<!--  -->
