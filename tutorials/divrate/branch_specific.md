---
title: Branch-Specific Diversification Rate Estimation
subtitle: How to estimate branch-specific shifts in diversification rates 
authors:  Sebastian Höhna and Michael R. May
level: 4
order: 4
prerequisites:
- intro
- intro_rev
- mcmc_archery
- mcmc_binomial
- divrate/simple
index: true
title-old: RB_DiversificationRate_BranchSpecific_Tutorial
redirect: false
exclude_files:
- data/primates.tre
- scripts/mcmc_BD.Rev
- scripts/mcmc_EBD_Corr_RJ.Rev
- scripts/mcmc_EBD_Corr.Rev
- scripts/mcmc_EBD.Rev
- scripts/mcmc_MRBD.Rev
- scripts/mcmc_Yule.Rev
- scripts/mcmc_Yule_prior.Rev
- scripts/ml_BD.Rev
- scripts/ml_Yule.Rev
- scripts/plot.R
---

{% include_relative modules/branch_specific_overview.md %}

{% include_relative modules/branch_specific_bds.md %}

{% include_relative modules/branch_specific_exercise_1.md %}
