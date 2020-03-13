{% section Overview: Models of Continuous-Character Evolution | continuous_char_overview %}

In these tutorials we will focus on a few types of models that are commonly used to study how continuous characters evolve over a phylogeny. All of the models we describe are _Gaussian_ models, meaning that character evolution follows a normal distribution, as in the Brownian motion and Ornstein-Uhlenbeck models. Models that include stochastic jumps {% cite Landis2012 %} are not covered here.

Models of continuous-character evolution are used to understand many interesting evolutionary phenomena, including: the _rate_ of character evolution, the _mode_ of character evolution, how these vary over time or among lineages, and understanding the biotic and abiotic factors that contribute to this variation.

{% subsection Brownian Motion models %}

The simplest models of continuous-character evolution assume that the character evolves under a Brownian motion model {% cite Felsenstein1973 Felsenstein1985a %}. Under this model, the expected amount of character change along a branch is zero, and the _variance_ in character change is proportional to time and a rate parameter, $\sigma^2$. These tutorials focus on estimating the rate parameter, $\sigma^2$, as well as how it varies over time and among lineages.

{% subsubsection (1) Estimating rates of evolution %}

*What is the (global) rate of evolution for my continuous character?*

The simplest Brownian-motion model assumes that the continuous character evolves at a constant rate over time and among lineages. While this model is limited in terms of the evolutionary questions it is able to address, it provides a useful introduction to modeling continuous-character evolution in `RevBayes`.

You can find examples and more information in the {% page_ref cont_traits/simple_bm %} tutorial.

{% subsubsection (2) Detecting variation in rates of evolution through time %}

*Do rates of evolution vary over time?*

Many hypotheses can naturally be addressed by asking whether rates of evolution vary over time, for example: are rates of evolution increased early in an adaptive radiation {% cite Harmon2010 %}, do rates of evolution increase over time {% cite Blomberg2003 %}, or do rates vary in less predictable ways?

__Work in Progress__

<!-- You can find examples of these models and more information in the {% page_ref cont_traits/time_varying_bm %} tutorial. -->

{% subsubsection (3) Detecting variation in rates of evolution among lineages %}

*Is there evidence for variation in the rate of evolution across the branches of my phylogeny?*

Identifying the number, location, and magnitude of shifts in rates of continuous character evolution can illuminate many evolutionary questions. Relaxing the assumption that rates are constant requires specifying a model that describes how rates vary (a ''relaxed morphological clock''). Many such models have been proposed {% cite Lemey2010 Eastman2011 Venditti2011 %}; we provide an example of relaxing the morphological clock using a ''random local clock'' model, as described in {% citet Eastman2011 %}, in the {% page_ref cont_traits/relaxed_bm %} tutorial.

{% subsubsection (4) Detecting state-dependent rates of evolution %}

*Are rates of evolution correlated with a discrete variable on my phylogeny?*

If rates of evolution are found to vary across branches, a natural question to ask is if some focal variable is associated with the rate variation. For example, we can test whether changes in rates are associated with habitat type in reef and non-reef dwelling fishes {% cite Price2013 May2019 %}.

We provide an example of fitting the state-dependent model to discrete- and continuous-character data in the {% page_ref cont_traits/state_dependent_bm %} tutorial.

{% subsubsection (5) Detecting correlated evolution %}

*Are characters X and Y evolutionarily correlated?*

Often we would like to know whether two (or more) continuous characters are correlated, and if they are, how strongly {% cite Felsenstein1985a %}. Additionally, we may view correlations among continuous characters as _nuisance parameters_: perhaps we are interested in estimating how rates of evolution vary among lineages or over time from multiple characters, and are concerned that failing to model correlations among characters will mislead us {% cite Adams2017 %}.

In the {% page_ref cont_traits/multivariate_bm %} tutorial, we will provide examples for working with _multivariate_ Brownian motion models to test hypotheses about correlations, and to estimate the strength of correlations among many continuous characters.


{% subsection Ornstein-Uhlenbeck models %}

Another major class of Gaussian models are the Ornstein-Uhlenbeck models, sometimes referred to as the Hansen models {% cite Hansen1997 Butler2004 %}. These models can describe the evolution of a continuous character under stabilizing selection. These tutorials focus on estimating the optimum parameter, $\theta$, as well as how it varies among lineages.

{% subsubsection (1) Estimating evolutionary optima %}

*What is the optimal value for the continuous character?*

The simplest Ornstein-Uhlenbeck model assumes that the continuous character evolves at a constant rate, and is drawn toward an optimal value, $\theta$, that is assumed to be the same over time and across branches.

You can find examples and more information in the {% page_ref cont_traits/simple_ou %} tutorial.


{% subsubsection (2) Detecting shifts in evolutionary optima %}

*Have optimal phenotypes changed over evolutionary history?*

Optimal traits may change as species evolve over the adaptive landscape. Relaxing the assumption that the optimal value is fixed across the tree requires specifying a model that describes how theta varies.

In the {% page_ref cont_traits/relaxed_ou %} tutorial, we provide an example of relaxing the assumption that optima are homogeneously across branches using a ''random local clock'' model, which is spiritually similar to the one described in {% citet Uyeda2014 %}.
