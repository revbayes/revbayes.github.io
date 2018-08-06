---
title: Environmental-dependent Speciation & Extinction Rates
subtitle: Estimating Correlation between Diversification Rates and Environmental Characters
authors:  Sebastian Höhna and Luis Palazzesi
level: 4
order: 3
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
- divrate/simple
- divrate/ebd
index: true
software: true
title-old: RB_DiversificationRate_Environmental_Tutorial
redirect: false
exclude_files:
- scripts/mcmc_BD.Rev
- scripts/mcmc_CBDSP.Rev
- scripts/mcmc_EBD.Rev
- scripts/mcmc_IRC_BDSP.Rev
- scripts/mcmc_MRBD.Rev
- scripts/mcmc_Yule.Rev
- scripts/mcmc_Yule_prior.Rev
- scripts/ml_BD.Rev
- scripts/ml_MRBD.Rev
- scripts/ml_Yule.Rev
- scripts/plot.R
---

{% include_relative modules/env_overview.md %}

{% include_relative modules/env_intro.md %}

{% include_relative modules/env_estimation.md %}
