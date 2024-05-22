---
title: Tutorial series for phylogenetic biogeography using the FIG model
subtitle: Using the feature-informed geographic state-dependent speciation-extinction (FIG) model for phylogenetic biogeography
authors:  Michael Landis, Sarah Swiston, Isaac Lichter Marck, Fábio Mendes, Felipe Zapata
level: 8
order: 8
index: true
include_all: false
prerequisites:
- intro/getting_started
- intro/rev
- intro/graph_models

---

{% subsection Introduction %}

Models of phylogenetic biogeography are used to estimate how historical processes have shaped the distribution of species in space over time. This page provides an overview for using the FIG model to study phylogenetic biogeography in RevBayes. Briefly, the FIG model builds upon the geographic state-dependent speciation-extinction (GeoSSE) model {% cite Goldberg2011 %}, a member of the larger SSE model family {% cite Maddison2007 %}. The FIG model extends the GeoSSE model by allowing regional features to shape biogeographic rates {% cite Landis2022 Swiston2023 %}. The purpose of FIG is to allow biologists to test new hypotheses that involve the timing and location of phylogenetic, biogeographic, and paleogeographic events.

{% subsection Tutorials %}

The FIG tutorial series targets biologists who are familiar with phylogenetic models and are interested in the following topics in phylogenetic biogeography: phylogenetic and biogeographic model design, ancestral range estimation, testing associations between regional features with biogeographic rates, estimating regional biogeographic rates through time, and biogeographic dating of speciation times.

Tutorials in this series are:
- [Molecular phylogenetics](timefig_dating.html#molecular-phylogenetics)
- [GeoSSE model](geosse_model.html)
- [FIG model](fig_model.html)
- [TimeFIG model](timefig_model.html)
- [Biogeographic dating with node age priors](timefig_dating.html#biogeographic-dating-with-node-calibration)
- [Biogeographic dating with TimeFIG](timefig_dating.html#biogeographic-dating-with-timefig)

{% subsection Software setup %}

The FIG tutorials are designed to be run with [RevBayes](https://github.com/revbayes/revbayes) using the TensorPhylo plugin. Developed by Mike May and Xavier Meyer, TensorPhylo is a high-performance library for rapidly computing state-dependent diversification model likelihoods.
 
Researchers can run pre-installed versions of RevBayes and TensorPhylo using the Docker image developed by Sarah Swiston: [link](https://revbayes.github.io/tutorials/docker.html).

*Note:* as of 2024-05-21, the current FIG tutorials require specialized versions of RevBayes (branch stochmap_tp_dirty_merge, commit 55c8174) and TensorPhylo (branch tree-inference, commit daa0aed) that are not yet integrated into the main RevBayes codebase. We expect this will happen by the end of 2024.

{% subsection Empirical system: Hawaiian *Kadua* %}

The Hawaiian Archipelago is a Pacific volcanic island chain with many remarkable properties that fascinate biogeographers.

Hawaiian *Kadua* (Rubiaceae) is a clade of X flowering plant taxa.

*Isaac plans to write this section.*

{% subsection Acknowledgements %}

This tutorial series was written for the 2024 Phylogenetic Biogeography Workshop in St. Louis. The workshop was made possible through an NSF-funded project entitled *Modeling the Origin and Evolution of Hawaiian Plants*. The botanical and biogeographical context of these tutorials was enriched through ongoing interactions with our project collaborators, Warren Wagner, Nina Rønsted, Bruce Baldwin, and Ken Wood. We also thank Mike May for his indispensable help adapting TensorPhylo for use with TimeFIG analyses for biogeographic dating. 
