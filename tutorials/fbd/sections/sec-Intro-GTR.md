{% subsection Nucleotide Sequence Evolution | Intro-GTR %}

The model component for the molecular data uses a general
time-reversible model of nucleotide evolution and gamma-distributed rate
heterogeneity across sites (the *Substitution Model* and *Sites Model* in {% ref fig_module_gm %}). This
model of sequence evolution is covered thoroughly in the
{% page_ref ctmc %}
tutorial.

{% subsubsection Lineage-Specific Rates of Sequence Evolution | Intro-GTR-UExp %}

Rates of nucleotide sequence evolution can vary widely among lineages,
and so models that account for this variation by relaxing the assumption
of a strict molecular clock {% cite Zuckerkandl1962 %} can allow for more
accurate estimates of substitution rates and divergence times
{% cite Drummond2006 %}. The simplest type of relaxed clock model assumes that
lineage-specific substitution rates are independent or "uncorrelated".
One example of such an uncorrelated relaxed model is the uncorrelated
*exponential* relaxed clock, in which the substitution rate for each
lineage is assumed to be independent and identically distributed
according to an exponential density ({% ref fig_uexp_gm %}). This is *Branch Rates Model* 
for the *Molecular Data* ({% ref fig_module_gm %}) that we will use in this tutorial. 
Another possible uncorrelated relaxed
clock model is the uncorrelated lognormal model, described in the
{% page_ref clocks %}
tutorial [also see {% citet Thorne2002 %}].

{% figure fig_uexp_gm %}
<img src="figures/tikz/uexp_gm.png" width="400" /> 
{% figcaption %} 
A graphical model of the
uncorrelated exponential relaxed clock model. In this model, the clock
rate on each branch is independent and identically distributed according
to an exponential density with mean drawn from an exponential hyperprior
distribution.
{% endfigcaption %}
{% endfigure %}