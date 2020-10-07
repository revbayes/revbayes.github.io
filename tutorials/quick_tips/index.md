---
title: Quick Tips for Analyses in RevBayes
subtitle:  
authors:  Heath Lab folks
level: 3
order: 15
prerequisites:
- intro
- mcmc
exclude_files:
index: false
redirect: false
---

{% section Overview | overview %}



{% section Moves  | moves %}


{% subsection Diagnosing Issues with Moves %}

Talk about things like:

- ESS / ESS per generation
- Convergence stats - link to the convergence tutorial
- Trace looking like a fuzzy catapillar
- Acceptance ratios and how bad ratios can affect the fuzzy catapillar
- OperatorSummary method on mcmc objects



{% subsection Choosing and Optimizing Moves %}

{% subsubsection Move Schedule %}

{% subsubsubsection Weights %}

{% subsubsection Move Size %}

{% subsubsubsection Tuning %}

{% subsubsubsection Different Moves for Different Scales %}

{% aside Examples of Different Sized Moves on Trees %}
{% endaside %}

{% aside Examples of Different Size Moves on Continuous Parameters %}
{% endaside %}

{% subsubsection Multiple Moves on the Same Node %}




{% section Clade Constraints  | Clade Constraints %}



{% section Checkpointing  | Checkpointing %}
