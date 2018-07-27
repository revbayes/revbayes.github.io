{% subsection Morphological Character Evolution | Intro-Morpho %}

For the vast majority of extinct species, fossil morphology is the
primary source of phylogenetically informative characters. Therefore, an
appropriate model of morphological character evolution is needed to
reliably infer the positions of these species in a phylogenetic
analysis. The Mk model {% cite Lewis2001 %} uses a generalized Jukes-Cantor
matrix to allow for the incorporation of morphology into likelihood and
Bayesian analyses. In its simplest form, this model assumes that
characters change states symmetrically—that a given character is as
likely to transition from a one state to another as it is to reverse. In
this tutorial we will consider only binary morphological characters,
*i.e.* characters that are observed in one of
two states, 0 or 1. For example, the assumption of the single-rate Mk
model applied to our binary character would mean that a change from a 0
state to a 1 state is as likely as a change from a 1 state to a 0 state.
This assumption is equivalent to assuming that the stationary
probability of being in a 1 state is equal to $1/2$.

In this tutorial, we will apply a single-rate Mk model as a prior on
binary morphological character change. If you are interested extensions
of the Mk model that relax the assumptions of symmetric state change,
please see {% page_ref morph %}.

Because of the way morphological data are collected, we need to exercise
caution in how we model the data. Traditionally, phylogenetic trees were
built from morphological data using parsimony. Therefore, only parsimony
informative characters were collected—that is, characters that are
useful for discriminating between phylogenetic hypotheses under the
maximum parsimony criterion. This means that many morphological datasets
do not contain invariant characters or
[autapomorphies](https://en.wikipedia.org/wiki/Autapomorphy), as these
are not parsimony informative. However, by excluding these slow-evolving
characters, estimates of the branch lengths can be inflated
{% cite Felsenstein1992 Lewis2001 %}. Therefore, it is important to use models
that can condition on this data-acquisition bias. RevBayes has two
ways of doing this: one is used for datasets in which only parsimony
informative characters are observed; the other is for datasets in which
parsimony informative characters and parsimony uninformative variable
characters (such as autapomorphies) are observed.

{% subsubsection The Morphological Clock | Intro-MorphClock %}

Just like with the molecular data {% ref Intro-GTR-UExp %},
our observations of discrete morphological characters are conditional on
the rate of change along each branch in the tree. This model component
defines the of the in the generalized graphical model shown in 
{% ref fig_module_gm %}. The relaxed clock model we described for the
molecular data in {% ref Intro-GTR-UExp %} it allows the
substitution rate to vary through time and among lineages. For the
morphological data, we will instead use a "strict clock" model
{% cite Zuckerkandl1962 %}, in which the rate of discrete character change is
assumed to be constant throughout the tree. The strict clock is the
simplest morphological branch rate model we can construct (graphical
model shown in {% ref fig_morph_clock_gm %}).

{% figure fig_morph_clock_gm %}
<img src="figures/tikz/morph_clock_gm.png" width="300" /> 
{% figcaption %} 
The graphical-model
representation of the branch-rate model governing the evolution of
morphological characters. This model is consistent with a strict
morphological clock, where every branch has the same rate of change
($c$) and that rate is drawn from an exponential distribution with a
rate parameter of $\delta_c$.
{% endfigcaption %}
{% endfigure %}