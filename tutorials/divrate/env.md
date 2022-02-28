---
title: Environmental-dependent Speciation & Extinction Rates
subtitle: Estimating Correlation between Diversification Rates and Environmental Characters
authors:  Sebastian Höhna and Luis Palazzesi
level: 7
order: 3
prerequisites:
- intro
- mcmc
- divrate/simple
- divrate/ebd
index: true
software: true
title-old: RB_DiversificationRate_Environmental_Tutorial
redirect: false
include_all: false
include_files:
- data/primates.tre
- data/primates_tree.nex
- scripts/mcmc_EBD.Rev
- scripts/mcmc_EBD_Corr.Rev
- scripts/plot_EBD.R
---

{% include_relative modules/env_overview.md %}

{% include_relative modules/env_intro.md %}

{% include_relative modules/env_estimation.md %}
