---
title: Tutorial series for phylogenetic biogeography using the FIG model
subtitle: Using the feature-informed geographic state-dependent speciation-extinction (FIG) model for phylogenetic biogeography
authors:  Michael Landis, Sarah Swiston, Isaac Lichter Marck, Fábio Mendes, Felipe Zapata
level: 8
order: 8
index: true
include_all: false
prerequisites:
---

{% section Introduction | introduction %}

Models of phylogenetic biogeography are used to estimate how historical processes have shaped the distribution of species in space over time. This page provides an overview for using the FIG model to study phylogenetic biogeography in RevBayes. Briefly, the FIG model builds upon the geographic state-dependent speciation-extinction (GeoSSE) model {% cite Goldberg2011 %}, a member of the larger SSE model family {% cite Maddison2007 %}. The FIG model extends the GeoSSE model by allowing regional features to shape biogeographic rates {% cite Landis2022, Swiston2023 %}.

The purpose of FIG is to allow biologists to test new hypotheses that involve the timing and location of phylogenetic, biogeographic, and paleogeographic events. The FIG tutorial series targets biologists who are familiar with phylogenetic models and are interested in the following topics in phylogenetic biogeography:

- phylogenetic and biogeographic model design
- ancestral range estimation
- detecting relationships between regional features and biogeographic rates
- modeling biogeographic rates through time
- divergence time estimation using paleogeography (biogeographic dating)


Tutorials in this series are:
- GeoSSE model: {% page_ref fig/geosse_model %}
- FIG model: {% page_ref fig/fig_model %}
- TimeFIG model: {% page_ref fig/timefig_model %}
- Biogeographic dating with TimeFIG: {% page_ref fig/timefig_dating %}

The FIG tutorials are designed to be run in RevBayes using the Tensorphylo plugin. Developed by Mike May and Xavier Meyer, Tensorphylo is a high-performance library for rapidly computing state-dependent diversification model likelihoods. We thank Mike May for his indispensible help optimizing and reconfiguring Tensorphylo for use with TimeFIG analyses for biogeographic dating. Researchers not interested in compiling and installing Tensorphylo and RevBayes can use the Docker image developed by Sarah Swiston.

This tutorial series was written for the 2024 Phylogenetic Biogeography Workshop in St. Louis as part of an NSF-funded project entitled *Modeling the Origin and Evolution of Hawaiian Plants* (DEB 2040347). The *Kadua* dataset featured in this tutorial series was generated with our project collaborators: Nina Rønsted, Warren Wagner, Bruce Baldwin, and Ken Wood. 
