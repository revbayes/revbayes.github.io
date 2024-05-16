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

This introduces a tutorial series for using the FIG model for phylogenetic biogeography in RevBayes. The FIG model builds upon the geographic state-dependent speciation-extinction (GeoSSE) model {% cite Goldberg2011 %}. The FIG model extends the GeoSSE model by allowing regional features to shape biogeographic rates {% cite Landis2022, Swiston2023 %}.

The FIG tutorial series targets biologists who are familiar with phylogenetic models and are interested in the following topics in phylogenetic biogeography:

- phylogenetic and biogeographic model design
- divergence time estimation using paleogeography (biogeographic dating)
- detecting relationships between regional features and biogeographic rates
- modeling biogeographic rates through time
- ancestral range estimation

Tutorials in this series are:
- GeoSSE model: {% page_ref fig/geosse_model %}
- FIG model: {% page_ref fig/fig_model %}
- TimeFIG model: {% page_ref fig/timefig_model %}
- Biogeographic dating with TimeFIG: {% page_ref fig/timefig_dating %}

All tutorials in this series will focus on Hawaiian plant radiation, *Kadua*. We thank our collaborators Nina Rønsted, Warren Wagner, Ken Wood, and Bruce Baldwin for help generating the biological dataset (Kadua) showcased in this tutorial.

The FIG tutorials are designed to be run in RevBayes with the Tensorphylo plugin, developed by Mike May and Xavier Meyer. Tensorphylo is a high-performance library for rapidly computing state-dependent diversification model likelihoods. We thank Mike May for his indispensible help optimizing and reconfiguring Tensorphylo for use with TimeFIG analyses for biogeographic dating. Researchers not interested in compiling and installing Tensorphylo and RevBayes can use the Docker image developed by Sarah Swiston.

This tutorial series was written for the 2024 Phylogenetic Biogeography Workshop in St. Louis as part of an NSF-funded project on Modeling the Origin and Evolution of Hawaiian Plants.
