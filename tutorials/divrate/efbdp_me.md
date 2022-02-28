---
title: Mass Extinction Estimation
subtitle: Estimating Mass Extinctions from Phylogenies with Fossil and Extant Taxa
authors:  Andrew Magee and Sebastian Höhna
level: 7
order: 2
prerequisites:
- intro
- mcmc
- divrate/ebd
- fbd/fbd_specimen
index: true
redirect: false
include_all: false
include_files:
- data/crocs_T1.tre
- data/crocs_taxa.txt
- scripts/mcmc_EFBD_mass_extinctions.Rev
- scripts/mcmc_CRFBD.Rev
- scripts/plot_ME.R
- scripts/fit_gamma_distributions.R
---

{% include_relative modules/efbdp_me_overview.md %}

{% include_relative modules/efbdp_me_intro.md %}

{% include_relative modules/efbdp_me_estimation.md %}

{% include_relative modules/efbdp_me_exercise_1.md %}
