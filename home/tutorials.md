---
layout: home
permalink: /tutorials/
title: Tutorials
subtitle: Tutorial modules
---

This page is intended to guide users in assembling a set of tutorials that will help them learn 
how to use RevBayes for a given analysis. Each module lists the tutorials that focus on a particular 
topic, as well as those that will provide prerequisite knowledge or resources for deeper learning.    
We encourage users with no RevBayes experience to start with the **RevBayes fundamentals** module.

To see all available tutorials, including the ones for which modules are not currently written, 
go to the [full tutorials page]({{ base.url }}/all_tutorials).

{% aside RevBayes fundamentals %}

This module is for users who have no experience with RevBayes. The tutorials contained here walk
the user through the basics of installing and using RevBayes, and some of the theory behind
RevBayes analyses.

- Pre-requisites: Basic knowledge on Bayesian statistics.

1. [Getting started with RevBayes]({{ base.url }}/tutorials/intro/getting_started). This tutorial includes getting RevBayes working on your machine, and learning about the fundamentals of setting up models in the software.
2. MCMC fundamentals. Three tutorials lay out the basics of Markov Chain Monte Carlo analysis in RevBayes, using three different examples: [Airline fatalities]({{ base.url }}/tutorials/mcmc/poisson), [coin flips]({{ base.url }}/tutorials/mcmc/binomial), and [archery]({{ base.url }}/tutorials/mcmc/archery). It is recommended that absolute beginners go through all three.

By the end of this module, you should be able to build RevBayes, write simple Rev code, and build 
simple models on which to run MCMC analyses. From here, you can select the module(s) below that
best represent your interests and intended analyses.

{% endaside %}

{% aside MCMC assessment %}

This module is for users looking to debug or analyze their MCMC results deeper. The tutorials will walk the user through best practices when analyzing posterior samples, and tips on how to improve your analyses if your analysis has not converged.

- Pre-requisites: **RevBayes fundamentals**, and results from some analysis (e.g. from completion of one of the modules below).

1. Assessing convergence of your MCMC results: [Convergence assessment]({{ base.url }}/tutorials/convergence). This tutorial will walk you through theory and examples on how to assess the convergence of your MCMC chain.
2. Practical exercises on assessing convergence: [Debugging your MCMC]({{ base.url }}/tutorials/mcmc_troubleshooting). This tutorial contains more exercises on assessing convergence, and provides tips on how to improve convergence in your analysis.

- [Introduction to RevGadgets]({{ base.url }}/tutorials/intro/revgadgets) walks you through the use of RevGadgets, an R package that is an optional but convenient tool for postprocessing of RevBayes results.

{% endaside %}

{% aside Molecular phylogenetic inference %}

This module is intended for users looking to infer a phylogenetic tree using molecular (DNA) data.
Users will learn how to set up basic molecular evolution model, and be presented with more advanced
tutorials to tailor their learning to their desired analyses.

- Pre-requisites: **RevBayes fundamentals**.

1. Theoretical background: [Understanding continuous-time Markov models]({{ base.url }}/tutorials/dice). This tutorial will get you up to speed with the theory behind molecular evolution models.
2. Basic molecular phylogenetic inference: [Nucleotide substitution models]({{ base.url }}/tutorials/ctmc). This tutorial will walk you through a simple example of molecular phylogeny inference.

- If interested in partitioning molecular data: [Partitioned data analysis]({{ base.url }}/tutorials/partition). 
- If interested in choosing between models of molecular evolution:
    1. [General introduction to model selection]({{ base.url }}/tutorials/model_selection_bayes_factors/bf_intro).
    2. [Model selection for one locus]({{ base.url }}/tutorials/model_selection_bayes_factors/bf_subst_model).
    3. [Model selection for partition models]({{ base.url }}/tutorials/model_selection_bayes_factors/bf_partition_model).

By the end of this module, you should be able to infer a phylogenetic tree with a simple molecular 
evolution model. Depending on your interests, you will also have learned about how to set up
partitioned models, and choose the best models for your dataset.

{% endaside %}

{% aside Polymorphism-aware molecular phylogenetics %}

This module is intended for users looking to infer a phylogenetic tree using molecular data including polymorphisms. Users will learn how to modify their molecular evolution models to account for the presence of polymorphisms in the dataset, including, if desired, balanced selection. Note that the tutorials in this module use code on a separate RevBayes branch, requiring users to run `git checkout dev_PoMo_SNP` within their local RevBayes repo before running analyses.

- Pre-requisites: **RevBayes fundamentals**, **Molecular phylogenetic inference**.

1. [Polymorphism-aware phylogenetic models]({{ base.url }}/tutorials/pomos).
- If interested in including balancing selection in your model: [Polymorphism-aware phylogenetic models with balancing selection]({{ base.url }}/tutorials/pomobalance).

{% endaside %}

{% aside Morphological phylogenetic inference %}

This module is intended for users looking to infer a phylogenetic tree using morphological data.
Users will learn how to set up basic morphological evolution models, including for characters
with more than two states.

- Pre-requisites: **RevBayes fundamentals**.

1. Theoretical background: [Understanding continuous-time Markov models]({{ base.url }}/tutorials/dice). This tutorial will get you up to speed with the theory behind morphological evolution models.
2. Morphological phylogenetics with binary traits: [Tree inference with discrete morphology]({{ base.url }}/tutorials/morph_tree). This tutorial will walk you through a simple example of morphological phylogeny inference, using only binary (i.e. two-state) characters.
3. Expanding your dataset: [Multistate characters]({{ base.url }}/tutorials/morph_tree/V2). This tutorial will teach you how to accommodate characters with more than two states in your morphological phylogenetics analyses.

{% endaside %}

{% aside Dating a phylogeny %}

This module is intended for users looking to date a time-calibrated phylogenetic tree. Users will learn how to set up analyses using both molecular clocks and fossil data for node dating.

- Pre-requisites: **RevBayes fundamentals**, and either **Molecular phylogenetic inference** or **Morphological phylogenetic inference**. Note that while the tutorials below use molecular models, it is straightforward to adapt the clock model to a morphological analysis.

1. Master dating tutorial: [Dating trees]({{ base.url }}/tutorials/dating). This tutorial includes:
- [Global molecular clocks]({{ base.url }}/tutorials/dating/global): The basics of molecular clocks.
- [Uncorrelated relaxed clocks]({{ base.url }}/tutorials/dating/relaxed): More complex (and biologically realistic) molecular clocks.
- [Node dating with fossils]({{ base.url }}/tutorials/dating/nodedate): Including fossil data for node dating. The master dating tutorial also links to a more advanced tip-dating tutorial (see the **Total-evidence analysis with tip-dating** module).
2. Bringing it all together: [Relaxed clocks & time trees]({{ base.url }}/tutorials/clocks). This tutorial walks the user through a full analysis, including performing model selection between multiple clock models.

- If interested in enforcing the relative order of nodes in your analysis: [Dating with relative constraints]({{ base.url }}/tutorials/relative_time_constraints).

{% endaside %} 

{% aside Estimating diversification rates %}

This module is intended for users looking to infer rates of speciation and extinction. Users will learn how to set up analyses using models in the birth-death model family, including the use of fossil data. While most of the tutorials here assume a fixed phylogenetic tree, some recommendations are made to point the user towards the direction of joint estimation as well.

- Pre-requisites: **RevBayes fundamentals**.

1. Theoretical background: [Introduction to diversification rate estimation]({{ base.url }}/tutorials/divrate/div_rate_intro). This tutorial will walk you through the theory behind the birth-death models used in the following tutorials.
2. Constant-rate models: [Simple diversification-rate estimation]({{ base.url }}/tutorials/divrate/simple). This tutorial will walk you through the basics of setting up a birth-death model for estimating rates of speciation and extinction from a fixed phylogenetic tree.

The following tutorials are to be picked based on your intended analyses, as they lay out different hypotheses regarding diversification dynamics and how to set up a BD model to test those.
- If interested in time-heterogeneous (or environmentally-dependent) diversification dynamics: [Episodic diversification rate estimation]({{ base.url }}/tutorials/divrate/ebd), [Environmental-dependent speciation and extinction rates]({{ base.url }}/tutorials/divrate/env).
- If interested in mass-extinction estimation, including fossil taxa: [Mass-extinction estimation]({{ base.url }}/tutorials/divrate/efbdp_me).
- If interested in jointly estimating topology and diversification rates: [Relaxed clocks & time-trees]({{ base.url }}/tutorials/clocks) (consider completing the **Molecular phylogenetic inference** and **Dating a phylogeny** modules).

{% endaside %}

{% aside Total-evidence analysis with tip-dating %}

This module is intended for users looking to infer a time-calibrated phylogenetic tree with both molecular and fossil data, and fossil ages. 

- Pre-requisites: **Dating a phylogeny** (and both **Molecular phylogenetic inference** and **Morphological phylogenetic inference**), and **Estimating diversification rates**.

1. [The fossilized birth-death model]({{ base.url }}/tutorials/fbd/fbd_specimen). This tutorial will push you to put together the skills learned in many previous tutorials, including setting up molecular and morphological evolution, clock, and birth-death models.

- If interested in more complex diversification dynamics, explore the advanced tutorials in **Estimating diversification rates**. Note that `dnFBDP` should be used instead of `dnBDP`/`dnEBDP`.

{% endaside %}

{% aside State-dependent diversification-rate estimation %}

This module is intended for users looking to infer trait-dependent diversification rates using the state-dependent speciation and extinction (SSE) model family. As with **Estimating diversification rates**, the tutorials assume a fixed tree, but tips are included for joint estimation.

- Pre-requisites: **RevBayes fundamentals**, and **Estimating diversification rates**.

1. Theoretical background: [Background on state-dependent diversification-rate estimation]({{ base.url }}/tutorials/sse/bisse-intro). This tutorial will introduce you to the theory behind the SSE model family, building from the fundamentals on BD models you learned on the **Estimating diversification rates** module.
2. Testing the effects of discrete traits on diversification: [State-dependent diversification with BiSSE and MuSSE]({{ base.url }}/tutorials/sse/bisse). This tutorial will walk you through the setup of the simplest SSE models: binary and multiple SSE (BiSSE and MuSSE), which are used to test the effects of binary and multiple state discrete traits on diversification, respectively.

- If interested in testing whether unobserved effects might impact diversification for your data: [State-dependent diversification with hidden SSE (HiSSE)]({{ base.url }}/tutorials/sse/hisse).
- If interested in the presence of cladogenetic state transitions: [State-dependent diversification with cladogenetic SSE (ClaSSE)]({{ base.url }}/tutorials/sse/classe).
- If interested in the effect of chromosome number on diversification: [Chromosome evolution]({{ base.url }}/tutorials/chromo).
- If interested in jointly estimating topology and state-dependent diversification rates, adapt [Relaxed clocks & time-trees]({{ base.url }}/tutorials/clocks) to use `dnCDBDP` or `dnGLHBDSP` instead of `dnBDP` (consider completing the **Molecular phylogenetic inference** and **Dating a phylogeny** modules).

{% endaside %}

{% aside Ancestral-state estimation %}

This module is intended for users looking to estimate the ancestral state of species in a fixed phylogenetic tree. Tutorials assume a fixed tree, and no diversification-rate estimation, but tips in that direction are provided.

- Pre-requisites: **RevBayes fundamentals**.

1. Theoretical background: [Introduction to Discrete Morphology Evolution]({{ base.url }}/tutorials/morph_ase). This tutorial will introduce you to the ancestral-state estimation (ASE) exercises in RevBayes.
2. [Simple ASE]({{ base.url }}/tutorials/morph_ase/ase). This tutorial will walk you through the set up and analysis of a simple ASE model, with equal transition rates between all states.
3. Independent rates: [ASE with the independent-rates model]({{ base.url }}/tutorials/morph_ase/ase_free). This tutorial builds on the previous one by including the possibility that rates are independent, providing more biological realism to your model. You can easily modify this model to allow only a subset of the rates to be free to vary.
4. Irreversibility: [ASE and irreversibility]({{ base.url }}/tutorials/morph_ase/ase_irreversible). This tutorial adds one more piece of complexity that is often useful in ASE models--irreversibility, _i.e._ ensuring some state transitions are not reversible. 
5. Worked example: [Mammals and placenta type]({{ base.url }}/tutorials/morph_ase/ase_mammals). This tutorial provides an example of ASE with irreversibility for the estimation of placenta types in mammals. As an exercise, try modifying the script to allow to make the free-rates model into an independent-rates model.

- If interested in testing for hidden effects in your model and/or estimating the timing of transitions: [Stochastic character mapping and hidden rates]({{ base.url }}/tutorials/morph_ase/scm_hrm).
- If interested in testing for correlations between characters: [Correlations among characters]({{ base.url }}/tutorials/morph_ase/corr).
- If interested in jointly estimating diversification rates and ancestral states, see the **State-dependent diversification-rate estimation** module. If interested in jointly estimating the topology, see the last bullet point in that module.

{% endaside %}

{% aside Continuous trait evolution %}

This module is intended for users looking to estimate rates of evolution for continuous traits. The tutorials assume a fixed phylogenetic tree. While ways to jointly estimate diversification-rates and/or topology with evolutionary rates are possible, there is no current tutorial that applies that in a straightforward manner. If you are interested in setting up such an analysis, please start a discussion at our [GitHub Discussions](https://github.com/revbayes/revbayes/discussions) page for guidance. 

- Pre-requisites: **RevBayes fundamentals**.

1. Theoretical background: [Introduction to Models of Continuous-Character Evolution]({{ base.url }}/tutorials/cont_traits/cont_trait_intro). This tutorial will introduce you to the continuous-trait evolutionary-rate estimation exercises in RevBayes.
2. [Simple Brownian rate estimation]({{ base.url }}/tutorials/cont_traits/simple_bm). This tutorial will walk you through a simple analysis of continuous-trait rate estimation assuming Brownian motion, _i.e._ assuming the trait is evolving randomly, with no directional trend.
3. [Ornstein-Uhlenbeck models]({{ base.url }}/tutorials/cont_traits/simple_ou). This tutorial will walk you through a slightly more complicated example, using an Ornstein-Uhlenbeck (OU) model instead of a Brownian motion model. OU models expand Brownian motion models in assuming an optimal trait value, such that evolution towards that optimum is more likely than evolution away from it.

- If interested in relaxed clock models, with different branches of the phylogeny having different evolutionary rates: [Relaxed Brownian rate estimation]({{ base.url }}/tutorials/cont_traits/relaxed_bm) and [Relaxed OU models]({{ base.url }}/tutorials/cont_traits/relaxed_ou).
- If interested in multiple continuous traits: [Multivariate Brownian motion]({{ base.url }}/tutorials/cont_traits/multivariate_bm). 
- If interested in making Brownian rates state-dependent: [State-dependent Brownian rate estimation]({{ base.url }}/tutorials/cont_traits/state_dependent_bm).

{% endaside %}
