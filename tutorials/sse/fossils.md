---
title: State-dependent diversification with fossils 
subtitle: Applying state-dependent speciation and extinction (SSE) models to trees with fossil tips 
authors:  Bruno do Rosario Petrucci
level: 7
order: 3.5
prerequisites:
- intro
- mcmc
- divrate/simple
- sse/bisse-intro
- sse/bisse
include_all: false
include_files:
- data/canidae_diet.nex
- data/canidae_tree.nex
- scripts/mcmc_fBiSSE.Rev
- scripts/mcmc_fBiSSE_tp.Rev
index: true
---

{% assign bisse_script = "mcmc_fBiSSE.Rev" %}
{% assign bisse_tp_script = "mcmc_fBiSSE_tp.Rev" %}

{% section Introduction | introduction %}

This tutorial describes how to apply state-dependent diversification models to trees including fossil data.
To that end, `dnCDBDP` includes the option of a serial sampling rate, combining SSE models with the fossilized birth-death (FBD) process {% cite Stadler2010 Heath2014 %}.
For more details on the theory behind these models, please see [the SSE theory tutorial]({{ base.url }}/tutorials/sse/bisse-intro), 
[the FBD tutorial]({{ base.url }}/tutorials/fbd/fbd_specimen), or {% cite Beaulieu2023 %} for a full mathematical derivation.

The tutorial will explain how to build both a BiSSE {% cite Maddison2007 %} and HiSSE {% cite Beaulieu2016 %} 
models to investigate the effect of hipercarnivory on canid extinction rates.
It was heavily based on [the BiSSE tutorial]({{ base.url }}/tutorials/sse/bisse), and users are highly encouraged to 
complete that tutorial before this one.

{% section Getting Set Up | thedata %}

We provide the data files which we will use in this tutorial:

-   [canidae_tree.nex](data/canidae_tree.nex):
    Dated canid phylogeny including 94 species. This tree is from {% cite Slater2015 %},
    and it includes many representatives of the two extinct canid subfamilies (Hesperocyoninae
    and Borophaginae), as well as extinct species of the extant subfamily (Caninae), and 
    four extant species: *Canis lupus* (grey wolf), *Canis latrans* (coyote), *Cuon alpinus*
    (dhole), and *Urocyon cinereoargenteus* (grey fox).
-   [canidae_diet.nex](data/canidae_diet.nex):
    A file with the coded character states for canid diet. This character has two states: 
    `0` = hypercarnivorous, `1` = non-hypercarnivorous, which can mean either meso- or 
    hypocarnivorous. These categories signify the percentage of vertebrates in an animal's diet, 
    correspoding to >70%, between 30 and 70%, and less than 30%, respectively (though sources 
    differ on the exact percentages). We could use the MuSSE model {% cite FitzJohn 2012 %} to
    analyze the rates for meso- and hypocarnivores separately, but given the relatively small size
    of the tree, and our main interest on the effects of hypercarnivory specifically, we simplified
    the dataset.

> Create a new directory on your computer called `RB_fsse_tutorial`.
>
> Within the `RB_fsse_tutorial` directory, create a subdirectory called `data`.
> Then, download the provided files and place them in the `data` folder.
> You can then start a `scripts` folder to hold the script for this analysis, or use RevBayes interactively by running `rb` and adding the code described below one block at a time.
{:.instruction}

{% section Setting up a serially-sampled BiSSE model | sec_fBiSSE %}

To investigate the effect of diet on the diversification of Canidae, we will start by setting up a BiSSE model, which
assumes two rate categories for speciation, extinction, and fossil sampling, depending on a species' diet.
If you open the data file [canidae_diet.nex](data/canidae_diet.nex) in your text editor, you will see the coded
characters for each species in our tree. For example, the dire wolf ([*Canis dirus*](https://en.wikipedia.org/wiki/Dire_wolf)) was
hypercarnivorous, so it is set to state `0`. Coyotes (*Canis latrans*), on the other hand, are mesocarnivores, while
the extinct *Archaeocyon pavidus* (a member of the extinct [Borophaginae subfamily](https://en.wikipedia.org/wiki/Borophaginae)) 
and living grey foxes (*Urocyon cinereoargenteus*) are hypocarnivores (all of these set to state `1`).
Longstanding hypotheses on the effects of extreme specialization would lead to an _a priori_ hypothesis that
hypercarnivorous canids have higher extinction rates, which we can then test by comparing the posterior distributions of
the extinction rate for each state, $\mu_0$ and $\mu_1$, under BiSSE.

Note that this analysis, like most tutorials, should be seen as illustrative only. The tree used here is generally too
small to achieve reliable SSE estimates, and the lack of sampled ancestors likely means our estimates will be
biased {%cite Beaulieu2023 %}. Work is already underway to estimate a more complete canid tree, which will then
allow for more reliable SSE analyses. For the moment, consider this as merely illustrative as to how you can
set up your own serially-sampled SSE analyses.

{% subsection Read in the Data | subsec_readdata %}

Here, since we are using a fixed tree, it is considered _data_. So we first read our dated phylogeny.

{{ bisse_script | snippet:"block#", "1" }}

Then, we read the diet data for our canids.

{{ bisse_script | snippet:"block#", "2" }}

We then create a helper variable to record the number of states used here. In this case, 2 (hypercarnivorous and
non-hypercarnivorous).

{{ bisse_script | snippet:"block#", "3" }}

We also create a helper variable to hold the value of the root age of the tree.

{{ bisse_script | snippet:"block#", "4" }}

Finally, we initialize a variable for our vector of moves and monitors.

{{ bisse_script | snippet:"block#", "5" }}

{% subsection Specify the Model | subsec_specifymodel %}

#### **Diversification, sampling, and transition rates**

The first step for specifying our BiSSE model is creating variables to hold the priors on diversification and
fossil-sampling rate. To keep things simple, we will set speciation and extinction priors to a log-uniform distribution,
representing a relatively agnostic prior belief about these rates. For fossil-sampling rate, we will set an exponential
prior, a slightly more informative distribution, since fossil-sampling is often a more difficult rate for the model
to estimate. We will set these priors using a `for` loop on `num_states` (making the code easy to modify for a
different character with a different number of states), and also create nodes for the `diversification` rates, for
easy comparisons later.

{{ bisse_script | snippet:"block#", "6-10" }}

Note that we are using `mvSlice` instead of the more popular `mvScale` move. `mvSlice` is a relatively new addition
to RevBayes that functions as an `mvScale` move that searches for an optimal jump size to improve mixing. This allows,
on average, faster convergence with a lower number of moves.

Next we will specify the transition rates, $q_{01}$ and $q_{10}$. These represent the rate with which species
transition anagenetically between hypercarnivorous and non-hypercarnivorous lifestyles. We could set up uninformative
priors like we did for speciation and extinction, but to again keep things simple we will specify an exponential prior
on each rate, with a mean representing 10 character state transitions throughout the tree, on average. This allows for
reasonably frequent transitions, while also leaving a good amount of uncertainty. We will once again use a `for` loop
in this case over `num_states * (num_states - 1)`, so that the code can be easily modified for analyses with non-binary
characters.

{{ bisse_script | snippet:"block#", "11-13" }}

Here, `q[1]` is equivalent to $q_{01}$, the rate with which hypercarnivorous species transition to non-hypercarnivorous
lifestyles. `q[2]` is equivalent to $q_{10}$, the rate of the opposite transition.

To use these rates with `dnCDBDP`, we need to make a rate matrix, which we do using `fnFreeK`. Since the character in
this case is binary, we could instead use `fnFreeBinary`, but in this way we again allow the script to be modified
for use with other characters with minimal modifications.

{{ bisse_script | snippet:"block#", "14" }}

The `rescaled` argument is there to be used with DNA evolution matrices, where we want the total transition rates
to be normalized to 1. Here, we want the rates in the same units as the diversification and sampling rates, so
we set `rescaled = false`.

#### **Root State**

Next, we need to create a variable to hold the root frequency for each state, `pi` ($\pi$). `pi` is a vector of size
`num_states`, with `pi[1]` being the probability that the root (_i.e._ the common ancestor of all species in
the dataset) was at state `0` (hypercarnivorous), and respectively for `pi[2]` and state `1`. In this step, we
could make use of past studies about the ancestral state of canid diets, and _e.g._ set a higher prior probability 
for state `1` than state `0`, because it is likely that the first canids were not hypercarnivorous. However,
to illustrate a useful prior for the case where we have no prior knowledge on the root state, we will assume
that is the case. The [Dirichlet distribution](https://en.wikipedia.org/wiki/Dirichlet_distribution) is a
multi-dimensional generalization of the Beta distribution. We will set the prior to a Dirichlet with parameters
all equal to 1, which is equivalent to setting a uniform distribution on the probability of each state at the root.

{{ bisse_script | snippet:"block#", "15" }}

Once again, we set the number of states for our Dirichlet prior in the way to make it the most straightforward to
modify for a character with more states, by making use of the `rep` function. In the case of our binary diet data,
this would be equivalent to setting `dnDirichlet( v(1, 1) )`.

We will use a special move for objects that are drawn from a Dirichlet distribution

{{ bisse_script | snippet:"block#", "16" }}

#### **Extant Sampling**

All birth-death processes are conditioned on the probability a taxon is sampled at the present, usually termed
the extant sampling rate `rho` ($\rho$). While `dnCDBDP` allows for `rho` to be dependent on states, we have no
reason to expect it to be in this case. Furthermore, since we know the exact number of canid species alive
today (barring some discussion on species delimitation), we know that our dataset has exactly 4 out of 36 canid
species. We can therefore set a constant node for `rho`, equal to that proportion.

{{ bisse_script | snippet:"block#", "17" }}

If you are unsure on the proportion of extant species present in your dataset, or if you have reason to believe
the trait of focus in your analysis could affect `rho`, you could create stochastic nodes for it, just as we did
for the fossil-sampling rate.

#### **The Time Tree**

We now have all the parameters necessary for our BiSSE model. We can initialize our time tree using the `dnCDBDP`
function.

{{ bisse_script | snippet:"block#", "18" }}

Since we are treating the tree as fixed, we need to attach this time tree node to our observed phylogeny. We do so
using the `clamp` method.

{{ bisse_script | snippet:"block#", "19" }}

The tree is not our only data, however, and we also need to attach the observed character states. We can do so
using the `clampCharData` method.

{{ bisse_script | snippet:"block#", "20" }}

This completes the model setup.

{% subsection Running the MCMC analysis | subsec_runningmcmc %}

#### **The model object**

First, we need to create a workspace object that represents our entire model. The `model` function can be used,
taking any node in your model and traversing the entire model by finding the connections between that node and
the others. We give it the `timetree` node for simplicity.

{{ bisse_script | snippet:"block#", "21" }}

#### **Monitors**

We need to create monitors to record the important steps in our Markov Chain. First, we set up a monitor to store
all numerical variables in our model, _e.g._ `lambda` and `mu`.

{{ bisse_script | snippet:"block#", "22" }}

If we are interested on the evolution of diet throughout our canid tree, we can set an ancestral state estimation
monitor. This will then allow us to analyze the estimated state at each node of the tree, and provide information
on how canids have transitioned in and out of a hypercarnivorous lifestyle throughout the tree. This monitor is
also particularly useful for HiSSE analyses (see below), since it allows us to check the estimated hidden state for
each species in the dataset.

{{ bisse_script | snippet:"block#", "23" }}

Finally, we add a screen monitor to monitor the progress of the MCMC run.

{{ bisse_script | snippet:"block#", "24" }}

#### **Creating and Running the MCMC**

Armed with our full model, and vectors of monitors and moves, we can use the `mcmc` function to create our MCMC
object.

{{ bisse_script | snippet:"block#", "25" }}

In most RevBayes tutorials, we set the MCMC to run for a certain number of generations, using the `generations`
argument. This often requires users to have a prior idea of how long convergence will take, which could be
challenging. 

Here we present an alternative, where one can instead set the MCMC to run until a certain set of stopping rules
have been met. Specifically, we use `srMinESS` to ensure the MCMC will run until all numerical parameters have
reached an effective sample size of 250 (see 
[the MCMC convergence assessment tutorial]({{ base.url }}/tutorials/convergence) for more background on ESS and
other measures of convergence).

{{ bisse_script | snippet:"block#", "29" }}

SSE models are time-consuming, and time-constraints when using institutional super-computers often mean you might
need to restart analyses. To that end, we can make use of checkpointing by specifying a `checkpointFile` argument
in the `run` method. 

{{ bisse_script | snippet:"block#", "30" }}

The MCMC can then be restarted from the checkpoint file by adding

{{ bisse_script | snippet:"block#", "27" }}

before the `run` method.

#### **Summarize Sampled Ancestral States**

To make use of the ancestral states sampled using `mnJointConditionalAncestralState`, we first need to summarize
the sampled values using the `readAncestralStateTrace` function.

{{ bisse_script | snippet:"block#", "31" }}

Then, `ancestralStateTree` can be used to summarize the ancestral state trace as a tree with the maximum a
posteriori (MAP) state and the posterior probabilities for each state at a given node.

{{ bisse_script | snippet:"block#", "32" }}

{% aside Using TensorPhylo %}

TensorPhylo {% cite May2022 %} is a plugin that introduced an alternative general SSE function, the generalized
lineage-heterogeneous birth-death-sampling process (`dnGLHBDSP`). `dnGLHBDSP` provides much of the same utility
as `dnCDBDP` and other birth-death functions in RevBayes, being a generalization of BiSSE, HiSSE, and other
SSE models, including serial-sampling. It allows for more homogeneous scripts, using the same function for
multiple models, and it often leads to faster likelihood calculations than `dnCDBDP`. For more information on
`dnGLHBDSP` and instructions on how to install TensorPhylo, see the Tensorphylo tutorial (need to add a link here
when we have one).

Only minor modifications are needed to use `dnGLHBDSP` in our analysis. Throughout the rest of this box, we will
only mention lines that must be changed compared to our `dnCDBDP` script. First, we need to load the TensorPhylo
plugin

```
loadPlugin("TensorPhylo", "/path/to/tensorphylo/build/installer/lib")
```

Then, we need an extra helper variable representing the taxa in our tree.

{{ bisse_tp_script | snippet:"block#", "5" }}

All variables defined above will be used, and we will then pass them, together with `taxa` and `num_states`, to
`dnGLHBDSP`.

{{ bisse_tp_script | snippet:"block#", "19" }}

And we're done! This should run, and achieve similar results to `dnCDBDP`, while being slightly faster. Make sure
to change the output, checkpointing, and ancestral state filenames if you run both analyses!

{% endaside %}

{% section Summarizing and interpreting results | secanalysis %}

To visualize our rate and ancestral state estimates, we will make use of RevGadgets {% cite Tribble2022 %}, similar
to the [BiSSE tutorial]({{ base.url }}/tutorials/sse/bisse). We will not copy that code here to avoid redundancy,
since the procedure is the same. 

First, let us take a look at our ancestral state results

{% figure fBiSSE_anc_states %}
<img src="figures/fBiSSE_anc_states_diet.png" width="75%">
{% figcaption %}
A visualization of the ancestral states estimated under the BiSSE model. Code for this plot can be found in [the BiSSE tutorial]({{ base.url }}/tutorials/sse/bisse).
{% endfigcaption %}
{% endfigure %}

These ancestral states largely agree with the ancestral state estimation in {% cite Slater2015 %}, which is a good
sign. The clusters of hypercarnivory are sensible considering the tree in question, and there are not a lot of
internal nodes with uncertain states. 

Note that there are reasonably few transitions to and from hypercarnivory (state 0), which should spell caution
when interpreting the results of the model. This illustrates an important point about the signal for state-dependent
diversification: the sample size for these analyses is not the number of species in a tree, but the number of state
transitions present in that group's history {% cite Maddison2006 %}. This should be considered, together with our 
remarks on sampled ancestors in the introduction, by any researcher hoping to implement a serially-sampled SSE
analysis for their data. We reiterate that this tutorial should be seen as illustrative only, and the conclusions
drawn herein about the history of diet (or the effect of diet on diversification) in Canidae should not be considered
conclusive.

All that said, let us take a look at our rate estimates. Note that given the naming convention in our tutorial,
and our desire to also plot fossil sampling rate `psi`, the call to `processSSE` should be something like

```
pdata <- processSSE(bisse_file,
                    speciation = "lambda",
                    extinction = "mu",
                    rates = c("lambda", "mu", "diversification", "psi"))
```

Using the `plotMuSSE` function, we then get our posterior density plots.

{% figure fBiSSE_rates %}
<img src="figures/fBiSSE_div_rates_diet.png" width="75%">
{% figcaption %}
Visualizing posterior samples of diversification and sampling rates associated with diet in Canidae. Code for this plot can be found in [the BiSSE tutorial]({{ base.url }}/tutorials/sse/bisse).
{% endfigcaption %}
{% endfigure %}

We do not recover a strong signal of trait-dependent diversification, but the diversification rate for
non-hypercarnivorous canids (state $1$) seems to be slightly higher (posterior probability of
$\lambda_1 - \mu_1 > \lambda_2 - \mu_2$ is around 0.65). So there is no support one way or the other for
the hypothesis that hypercarnivorous canids have higher extinction and speciation rates. A more complete
dataset is likely to provide better grounds for testing this and other complex patterns.

In this tutorial, you learned how to set up, run, and visualize the results of a serially-sampled BiSSE
analysis. While we only explored the BiSSE model, you can make use of the many SSE functions in RevBayes
to apply any SSE model to your dataset by modifying the code in the appropriate tutorial to reflect the
addition of fossil sampling rates. 
