---
title: Model selection of partition models
subtitle: Comparing relative model fit with Bayes factors
authors:  Mike May and Sebastian Höhna
level: 2
order: 0.2
prerequisites:
- intro
- mcmc
- bf_intro
- bf_subst_model
exclude_files: 
- data/primates_and_galeopterus_cytb.nex
- data/primates_and_galeopterus_cox2.nex
- scripts/marginal_likelihood_GTR_Gamma_inv.Rev
- scripts/marginal_likelihood_JC.Rev
- scripts/model_average_primates_cytb.Rev
index: true
redirect: false
---



{% section Overview %}

You should read first the {% page_ref model_selection_bayes_factors/bf_intro %} tutorial, which explains the theory and 
standard algorithms for estimating marginal likelihoods and Bayes factors.
Additionally, you may want to work through the {% page_ref model_selection_bayes_factors/bf_subst_model %} tutorial,
which estimates marginal likelihoods for different substitution models for one locus, before attempting this tutorial.



{% section Comparing Partitioned Models Using Bayes Factors %}

For this tutorial you should download the sequence data, *ITS*, *matK*, and *rbcL*. 
These new sequence data are for the genus *Fagus*, the beeches. 

Data partitions allow us to apply different substitution models to different loci 
in order to accommodate process heterogeneity (variation in the substitution process among sequences). 
The substitution models may be of the same form (i.e., they may all be GTR models), 
or of entirely different forms (i.e, some may be HKY, while others are GTR). 
Just because two loci have the same form of substitution model does not necessarily mean 
they share the same substitution models; for example, we determined that the GTR model 
is preferred for each of the loci above, but it is possible that the stationary frequencies 
and relative rate parameters for these loci are different (i.e., they have different substitution models).

According to our previous analysis, we could partition our *Fagus* data so that each locus 
has the same or different substitution model parameters. 
Each of these choices imply different phylogenetic models, 
and thus we can choose among partitioned models using Bayes factors.

{% subsection The Uniform Partitioned Model %}
If we assigned the same GTR+G to each locus, we would be assuming that the process of evolution 
is the same among loci (we often call this the "uniform model"). 
We can specify this uniform partition model by using the same $Q$ matrix and ASRV model for each alignment. 
Open the file `marginal_likelihood_partition_1.Rev` and examine how we specify this model. 
In particular, note that `dnPhyloCTMC models` all use the same `Q` matrix and `site_rates`:

```
seq_ITS ~ dnPhyloCTMC(tree=phylogeny, Q=Q, type="DNA", siteRates=site_rates)
seq_ITS.clamp(data_ITS) # attach the observed data

seq_matK ~ dnPhyloCTMC(tree=phylogeny, Q=Q, type="DNA", siteRates=site_rates)
seq_matK.clamp(data_matK) # attach the observed data

seq_rbcL ~ dnPhyloCTMC(tree=phylogeny, Q=Q, type="DNA", siteRates=site_rates)
seq_rbcL.clamp(data_rbcL) # attach the observed data
```

{% subsection The Saturated Model %}
At the opposite end of the spectrum, the "saturated" model applies a different substitution model to each locus, and each locus receives its own subset-specific rate multiplier (with the contraint that the mean rate is 1!). 
Open the script `marginal_likelihood_partition_5.Rev` to see how this model is specified. 
Notice how the subset-specific rates are specified:
```
num_sites[1] = data_ITS.nchar()
num_sites[2] = data_matK.nchar()
num_sites[3] = data_rbcL.nchar()

relative_rates ~ dnDirichlet(v(1,1,1))
moves.append( mvBetaSimplex(relative_rates, weight=1.0) )

subset_rates := relative_rates * sum(num_sites) / num_sites
```
(The last line forces the `subset_rates` to have a mean of 1.)

Notice also that each `dnPhyloCTMC` is receiving a different `Q`, `subset_rates` `site_rates` argument:
```
seq_ITS ~ dnPhyloCTMC(tree=phylogeny, branchRates=subset_rates[1],
                      Q=Q_ITS, type="DNA", siteRates=site_rates_ITS)
seq_ITS.clamp(data_ITS) # attach the observed data

seq_matK ~ dnPhyloCTMC(tree=phylogeny, branchRates=subset_rates[2],
                       Q=Q_matK, type="DNA", siteRates=site_rates_matK)
seq_matK.clamp(data_matK) # attach the observed data

seq_rbcL ~ dnPhyloCTMC(tree=phylogeny, branchRates=subset_rates[3],
                       Q=Q_rbcL, type="DNA", siteRates=site_rates_rbcL)
seq_rbcL.clamp(data_rbcL) # attach the observed data
```

{% subsection In-Class Exercises %}

1. Download the `Rev` script associated with your assigned partition model. 
Note how this script implements the particular partition model and the power posterior analysis.
2. Execute your `Rev` script. This can take a long time; please be patient! 
Once your stepping-stone analysis is complete, record your result on the [Google spreadsheet](https://docs.google.com/spreadsheets/d/1m-hWOTHg3T5gP0XHPCB_m4jK5qaCfcTYM40svjew9Go/edit?usp=sharing).
