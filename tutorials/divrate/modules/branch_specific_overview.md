{% section Outline&#58; Estimating Branch-Specific Speciation & Extinction Rates %}

This tutorial describes how to specify a branch-specific
branching-process models in RevBayes; a birth-death process where
diversification rates vary among branches, similar to {% citet Rabosky2014a %}.
The probabilistic graphical model is given for each component of this
tutorial. The goal is to obtain estimate of branch-specific
diversification rates using Markov chain Monte Carlo (MCMC).


{% subsection The Birth-Death-Shift Process %}

{% figure fig_augmented %}
<img src="figures/augmented.png" width="800" /> 
{% figcaption %}
An example of a tree with a single event of diversification rate change, from
$(\lambda_1, \mu_1)$ to $(\lambda_2, \mu_2)$. a) A tree showing the complete cladogenetic process, including
extinct lineages. b) The reconstructed process for the tree shown in *a*.
{% endfigcaption %}
{% endfigure %}

{% ref fig_augmented %} shows an example in which speciation and extinction rates change among lineages.
The speciation and extinction rates at the root of the tree of {% ref fig_augmented %} are $(\lambda_1, \mu_1)$. 
There was one event of change to the speciation and extinction rates on the 
tree from $(\lambda_1, \mu_1)$ to $(\lambda_2, \mu_2)$.
From a casual inspection of the tree, it appears that the single change in speciation and/or extinction rate
in the tree of {% ref fig_augmented %} affected the diversity. Note that the clade above the event of speciation/extinction
rate change has fewer living species, and more extinct species, than the clade that maintained the ancestral
speciation and extinction rates.
This is exactly the type of situation we attempt to uncover. 

Here we will describe the birth-death-shift process.
The parameters in this model are: 

- $\lambda_i$: the rates of speciation of the $i^{\text{th}}$ lineage
- $\mu_i$: the rates of extinction of the $i^{\text{th}}$ lineage
- $\eta$: the rate at which speciation/extinction rates change

The process is described as follows. In a small interval of time, $\Delta t$, a lineage 
speciates with probability $\lambda \Delta t$, goes extinct with probability $\mu \Delta t$, 
or changes its rate with probability $\eta \Delta t$. 
When a speciation event occurs, both daughter lineages inherit the speciation and extinction rates of the parent
lineage. When an event of rate change occurs, new speciation and extinction rates are drawn from
the probability distributions, $f_{\lambda}(\cdot)$ and $f_{\mu}(\cdot)$. 
The affected lineage then continues, but with the modified speciation and extinction rates. 
When an extinction event occurs, the lineage is terminated at the event time.



{% figure fig_conditioning %}
<img src="figures/conditioning.png" width="800" /> 
{% figcaption %}
Samples of an MCMC analysis under a *Birth-Death-Shift* model. The colors
represent different classes of rates for the speciation and extinction rates ($\lambda$ and
$\mu$, respectively. Note that the speciation and extinction rates at the root of the tree
differ for the different MCMC samples: $(\lambda',\mu')$, $(\lambda'',\mu'')$, 
and $(\lambda''',\mu''')$.
{% endfigcaption %}
{% endfigure %}
