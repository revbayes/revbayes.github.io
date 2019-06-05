{% section Overview: Models of Continuous-Character Evolution | continuous_char_overview %}

In these tutorials we will focus on a few types of models that are commonly used to study how continuous characters evolve over a phylogeny.

{% subsection Types of Questions for Continuous-Character Analyses %}

Models of continuous-character evolution are used to understand many interesting evolutionary phenomena, including: the _rate_ of character evolution, the _mode_ of character evolution, how these vary over time or among lineages, and understanding the biotic and abiotic factors that contribute to this variation.

{% subsubsection (1) Brownian Motion models %}

The simplest models of continuous-character evolution assume that the character evolves under a Brownian motion model {% cite Felsenstein1973 Felsenstein1985a %}. Under this model, the expected amount of character change along a branch is zero, and the _variance_ in character change is proportional to time and a rate parameter, $\sigma^2$.
These tutorials focus on estimating the rate parameter, $\sigma^2$, as well as how it varies over time and among lineages.



{% subsubsection (1a) Estimating rates of evolution %}

*What is the (global) rate of evolution for my continuous character?*

The simplest Brownian-motion model assumes that the continuous character evolves at a constant rate over time and among lineages. While this model is limited in terms of the evolutionary questions it is able to address, it provides a useful introduction to modeling continuous-character evolution in `RevBayes`.

You can find examples and more information in the {% page_ref cont_traits/simple_bm %} tutorial.

{% subsubsection (1b) Detecting variation in rates of evolution through time %}

*Do rates of evolution vary over time?*

Many hypotheses can naturally be addressed by asking whether rates of evolution vary over time, for example: are rates of evolution increased early in an adaptive radiation {% cite Harmon2010 %}, do rates of evolution increase over time {% cite Blomberg2003 %}, or do rates vary in less predictable ways?

__WIP__

<!-- You can find examples of these models and more information in the {% page_ref cont_traits/time_varying_bm %} tutorial. -->



{% subsubsection (1c) Detecting variation in rates of evolution among lineages %}

*Is there evidence for variation in the rate of evolution across the branches of my phylogeny?*

Identifying the number, location, and magnitude of shifts in rates of continuous character evolution can illuminate many evolutionary questions. Relaxing the assumption that rates are constant requires specifying a model that describes how rates vary (a ''relaxed morphological clock''). Many such models have been proposed {% cite Lemey2010 Eastman2011 Venditti2011 %}; we provide an example of relaxing the morphological clock using a ''random local clock'' model, as described in {% citet Eastman2011 %}, in the {% page_ref cont_traits/relaxed_bm %} tutorial.

{% subsubsection (1d) Detecting state-dependent rates of evolution %}

*Are rates of evolution correlated with a discrete variable on my phylogeny?*

If rates of evolution are found to vary across branches, a natural question to ask is if some focal variable is associated with the rate variation. For example, we can test whether changes in rates are associated with habitat type in reef and non-reef dwelling fishes {% cite Price2013 May2019 %}.

We provide an example of fitting the state-dependent model to discrete- and continuous-character data in the {% page_ref cont_traits/state_dependent_bm %} tutorial.


{% subsubsection (1e) Detecting correlated evolution %}

__WIP__

{% subsubsection (2) Ornstein-Uhlenbeck models %}

__WIP__

{% subsubsection (2a) Estimating evolutionary optima %}

__WIP__

{% subsubsection (2a) Detecting shifts in evolutionary optima %}

__WIP__
