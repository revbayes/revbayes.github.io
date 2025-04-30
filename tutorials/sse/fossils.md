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
- scripts/mcmc_fMuSSE.Rev
index: true
---

{% assign musse_script = "mcmc_fMuSSE.Rev" %}

{% section Introduction | introduction %}

This tutorial describes how to apply state-dependent diversification models to trees including fossil data.
To that end, `dnCDBDP` includes the option of a serial sampling rate, combining SSE models with the fossilized birth-death (FBD) process {% cite Stadler2010 Heath2014 %}.
For more details on the theory behind these models, please see [the SSE theory tutorial]({{ base.url }}/tutorials/sse/bisse-intro), 
[the FBD tutorial]({{ base.url }}/tutorials/fbd/fbd_specimen), or {% Beaulieu2023 %} for a full mathematical derivation.

The tutorial will explain how to build both a MuSSE {% cite Maddison2007 %} and HiSSE {% cite Beaulieu2016 %} models to investigate the effect of hipercarnivory on canid extinction rates.
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
    A file with the coded character states for canid diet. This character has three states: 
    `0` = hypercarnivorous, `1` = mesocarnivorous, and `2` = hypocarnivorous. These categories
    signify the percentage of vertebrate in an animal's diet, correspoding to >70%, between 30 and
    70%, and less than 30%, respectively (though sources differ on the exact percentages).
-   [canidae_diet_binary.nex](data/canidae_diet_binary.nex):
    The same file as [canidae_diet.nex](data/canidae_diet.nex), but with meso- and hypocarnivorous
    as the same state (`1`). This is used here to setup a HiSSE analysis (to avoid setting up too
    paramater-rich an analysis for a 94 species tree), but could also be used for a an analogous
    BiSSE model.

> Create a new directory on your computer called `RB_fmusse_tutorial`.
>
> Within the `RB_fmusse_tutorial` directory, create a subdirectory called `data`.
> Then, download the provided files and place them in the `data` folder.
{:.instruction}


{% section Setting up a serially-sampled MuSSE model | fMuSSE %}

To investigate the effect of diet on the diversification of Canidae, we will start by setting up a MuSSE model, which
assumes 3 rate categories for speciation, extinction, and fossil sampling, depending on a species' diet.
If you open the data file [canidae_diet.nex](data/canidae_diet.nex) in your text editor, you will see the coded
characters for each species in our tree. For example, the dire wolves ([*Canis dirus*](https://https://en.wikipedia.org/wiki/Dire_wolf)) were
hypercarnivorous, so they are set to state `0`. Coyotes (*Canis latrans*), on the other hand, are mesocarnivores (state `1`), while
the extinct *Archaeocyon pavidus* (a member of the extinct [Borophaginae subfamily](https://https://en.wikipedia.org/wiki/Borophaginae)) 
and living grey foxes (*Urocyon cinereoargenteus*) are hypocarnivores (state `2`).
Longstanding hypotheses on the effects of extreme specialization would lead to an _a priori_ hypothesis that
hypercarnivorous canids have higher extinction rates, which we can then test by comparing the posterior distributions of
$\mu_0$, $\mu_1$, and $\mu_2$ under MuSSE.

Note that this analysis, like most tutorials, should be seen as illustrative only. The tree used here is generally too
small to achieve reliable SSE estimates, and the lack of sampled ancestors likely means our estimates will be
biased ({%cite Beaulieu2023 %}). Work is already underway to estimate a more complete canid tree, which will then
allow for more reliable SSE analyses. For the moment, consider this as merely illustrative as to how you can
set up your own serially-sampled SSE analyses.

{% subsection Read in the Data | subsec_readdata %}

Here, since we are using a fixed tree, it is considered _data_. So we first read our dated phylogeny.

{{ musse_script | snippet:"block#", "1" }}

Then, we read the diet data for our canids.

{{ musse_script | snippet:"block#", "2" }}

We then create a helper variable to record the number of states used here. In this case, 3 (hypo-, meso-, and
hypercarnivorous).

{{ musse_script | snippet:"block#", "3" }}

We also create a helper variable to hold the value of the root age of the tree.

{{ musse_script | snippet:"block#", "4" }}

Finally, we initialize a variable for our vector of moves and monitors.

{{ musse_script | snippet:"block#", "5" }}

{% subsection Specify the Model | subsec_specifymodel %}

#### **Priors on the Rates**

The first step for specifying our MuSSE model is creating variables to hold the priors on diversification and
fossil-sampling rate. To keep things simple, we will set speciation and extinction priors to a log-uniform distribution,
representing a relatively agnostic prior belief about these rates. For fossil-sampling rate, we will set an exponential
prior, a slightly more informative distribution, since fossil-sampling is often a more difficult rate for the model
to estimate. We will set these priors using a `for` loop on `num_states` (making the code easy to modify for a
different character with different numbers of states), and also create nodes for the `diversification` rates.

{{ musse_script | snippet:"block#", "6-10" }}

&#8680; If RevBayes has trouble finding good starting values, then you can initialize the speciation and extinction rate as follows:

{{ musse_script | snippet:"line", "61-62" }}

You can print the current values of the speciation rate vector to your screen:
```
speciation
```
```
[ 0.267, 0.160 ]
```
{:.Rev-output}

Of course, your screen output will be different from the values shown above if your
stochastic nodes were initialized with different values drawn from the log-uniform prior.

Next we specify the transition rates between the states `0` and `1`:
$q_{01}$ and $q_{10}$. As a prior, we choose that each transition rate
is drawn from an exponential distribution with a mean of 10 character
state transitions over the entire tree. This is reasonable because we
use this kind of model for traits that transition not-infrequently, and
it leaves a fair bit of uncertainty.
Note that we will actually use a `for`-loop to instantiate the transition rates
so that our script will also work for non-binary characters.

{{ musse_script | snippet:"line", "73-77" }}

Here, `rate[1]` is the rate of transition from state `0` (diurnal) to state `1` (nocturnal),
and `rate[2]` is the rate of going from nocturnal to diurnal.

Finally, we put the rates into a matrix, because this is what's needed
by the function for the state-dependent birth-death process.

{{ musse_script | snippet:"line", "84" }}

Note that we do not "rescale" the rate matrix. Rate matrices for
molecular evolution are rescaled to have an average rate of 1.0, but for
this model we want estimates of the transition rates with the same time
scale as the diversification rates.

#### **Prior on the Root State**

Create a variable for the root state frequencies. We are using a flat [Dirichlet distribution](https://en.wikipedia.org/wiki/Dirichlet_distribution) as the prior on
each state. There has been some discussion about this in {% cite FitzJohn2009 %}.
You could also fix the prior probabilities for the root states to be equal
(generally not recommended), or use empirical state frequencies.

{{ musse_script | snippet:"line", "92" }}

Note that we use the `rep()` function which generates a vector of length `NUM_STATES`
with each position in the vector set to `1`. Using this function and the `NUM_STATES`
variable allows us to easily use this Rev script as a template for a different analysis
using a character with more than two states.

We will use a special move for objects that are drawn from a Dirichlet distribution:

{{ musse_script | snippet:"line", "93" }}

#### **The Probability of Sampling an Extant Species**

All birth-death processes are conditioned on the probability a taxon is sampled in the present.
We can get an approximation for this parameter by calculating the _proportion_ of sampled
species in our analysis.

We know that we have sampled 233 out of 367 living described primate species. To
account for this we can set the sampling probability as a constant node
with a value of 233/367.

{{ musse_script | snippet:"line", "102" }}

#### **Root Age**

The birth-death process also depends on time to the most-recent-common ancestor--*i.e.*,
the root. In this
exercise we use a fixed tree and thus we know the age of the tree.

{{ musse_script | snippet:"line", "97" }}

#### **The Time Tree**

Now we have all of the parameters we need to specify the full character
state-dependent birth-death model. We initialize the stochastic node
representing the time tree and we create this node using the `dnCDBDP()` function.

{{ musse_script | snippet:"line", "106-113" }}

Now, we will fix the BiSSE time-tree to the observed values from our data files. We use
the standard `.clamp()` method to give the observed tree and branch times:

{{ musse_script | snippet:"line", "116" }}

And then we use the `.clampCharData()` method to set the observed states at the tips of the tree:

{{ musse_script | snippet:"line", "117" }}

Finally, we create a workspace object of our whole model. The `model()`
function traverses all of the connections and finds all of the nodes we
specified.

{{ musse_script | snippet:"line", "127" }}

You can use the `.graph()` method of the model object to visualize the graphical model you
have just constructed . This function writes the model DAG to a file
that can be viewed using the  program [Graphviz](https://www.graphviz.org/) ({% ref graphviz %}).

{% figure graphviz %}
<img src="figures/bisse_dag.svg" width="95%">
{% figcaption %}
The probabilistic graphical model of the character-state-dependent diversification model.
This image was generated by executing the `mymodel.graph("bisse.dot")` in RevBayes after specifying the full model DAG.
Then, the resulting file can be opened in the program [Graphviz](https://www.graphviz.org/).
{% endfigcaption %}
{% endfigure %}


{% subsection Running an MCMC analysis | subsec_runningmcmc %}


#### **Specifying Monitors**

For our MCMC analysis, we set up a vector of *monitors* to record the
states of our Markov chain. The first monitor will model all numerical
variables; we are particularly interested in the rates of speciation,
extinction, and transition.

{{ musse_script | snippet:"line", "130" }}

Optionally, we can sample ancestral states during the MCMC analysis.
We need to add an additional monitor to record the state of each internal node in the tree.
The file produced by this monitor can be summarized so that we can visualize the estimates of ancestral states.

{{ musse_script | snippet:"line", "133-139" }}

Similarly, you may want to add a stochastic character map.

{{ musse_script | snippet:"line", "142-144" }}

Then, we add a screen monitor showing some updates during the MCMC
run.

{{ musse_script | snippet:"line", "146" }}


#### **Initializing and Running the MCMC Simulation**

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The `mcmc()` function will
create our MCMC object:

{{ musse_script | snippet:"line", "154" }}

Now, run the MCMC:

{{ musse_script | snippet:"line", "157" }}

## **Summarize Sampled Ancestral States**

If we sampled ancestral states during the MCMC analysis, we can use the `RevGadgets` {% cite Tribble2022 %} R package
to plot the ancestral state reconstruction.
First, though, we must summarize the sampled values in RevBayes.

To do this, we first have to read in the ancestral state log file. This uses a specific function called `readAncestralStateTrace()`.

{{ musse_script | snippet:"line", "166" }}

Now, we can write an annotated tree to a file. This function will write a tree with each
node labeled with the maximum a posteriori (MAP) state and the posterior probabilities for each
state.

{{ musse_script | snippet:"line", "169-175" }}

Similarly, we compute the maximum a posteriori (MAP) stochastic character map.

{{ musse_script | snippet:"line", "178-184" }}

{% subsection Visualize Estimated Ancestral States | subsec_ancviz %}

To visualize the posterior probabilities of ancestral states, we will use the `RevGadgets` {% cite Tribble2022 %} R package.


>Open R.
{:.instruction}


`RevGadgets` requires the `ggtree` package {% cite Yu2017ggtree %}.
First, install the `ggtree` and `RevGadgets` packages:

<pre>
install.packages("devtools")
library(devtools)
install_github("GuangchuangYu/ggtree")
install_github("revbayes/RevGadgets")
</pre>

Run this code (or use the script `plot_anc_states_BiSSE.R`):

```{R}
library(ggplot2)
library(RevGadgets)

# read in and process the ancestral states
bisse_file <- paste0("output/primates_BiSSE_activity_period_anc_states_results.tree")
p_anc <- processAncStates(bisse_file)

# plot the ancestral states
plot <- plotAncStatesMAP(p_anc,
        tree_layout = "rect",
        tip_labels_size = 1) +
        # modify legend location using ggplot2
        theme(legend.position = c(0.1,0.85),
              legend.key.size = unit(0.3, 'cm'), #change legend key size
              legend.title = element_text(size=6), #change legend title font size
              legend.text = element_text(size=4))

ggsave(paste0("BiSSE_anc_states_activity_period.png"),plot, width=8, height=8)
```


{% figure BiSSE_anc_states %}
<img src="figures/BiSSE_anc_states_activity_period.png" width="75%">
{% figcaption %}
A visualization of the ancestral states estimated under the BiSSE model. We used the script `plot_anc_states_BiSSE.R`.
{% endfigcaption %}
{% endfigure %}




Next, we also want to plot the stochastic character map.
Use the script `plot_simmap_BiSSE.R`.

{% figure BiSSE_simmap %}
<img src="figures/BiSSE_simmap_activity_period.png" width="75%">
{% figcaption %}
A visualization of the stochastic character map estimated under the BiSSE model. We used the script `plot_simmap_BiSSE.R`.
{% endfigcaption %}
{% endfigure %}




{% subsection Summarizing Parameter Estimates | subsec_summary %}

Our MCMC analysis generated a tab-delimited file called `primates_BiSSE_activity_period.log` that contains
the samples of all the numerical parameters in our model.
Again, we will use the `RevGadgets` {% cite Tribble2022 %} R package, which allow you to generate plots and
visually explore the posterior distributions of sampled parameters.

>Open R.
{:.instruction}

Run this code:
```{R}
library(RevGadgets)
library(ggplot2)

# read in and process the log file
bisse_file <- paste0("output/primates_BiSSE_activity_period.log")
pdata <- processSSE(bisse_file)

# plot the rates
plot <- plotMuSSE(pdata) +
        theme(legend.position = c(0.875,0.915),
              legend.key.size = unit(0.4, 'cm'), #change legend key size
              legend.title = element_text(size=8), #change legend title font size
              legend.text = element_text(size=6))

ggsave(paste0("BiSSE_div_rates_activity_period.png"),plot, width=5, height=5)
```

{% figure BiSSE_rates %}
<img src="figures/BiSSE_div_rates_activity_period.png" width="95%">
{% figcaption %}
Visualizing posterior samples of the speciation rates associated with daily activity time with the `RevGadgets` {% cite Tribble2022 %} R package. We used the script `plot_div_rates_BiSSE.R`.
{% endfigcaption %}
{% endfigure %}



{% section Evaluate Social System under the BiSSE Model | exercise2 %}

Now that you have completed the BiSSE analysis for the timing of activity for all primates,
perform the same analysis using a different character. Your `data` directory should
contain the file [`primates_solitariness.nex`](data/primates_solitariness.nex), which has the
coded states for each species habitat type. This is also a _binary_ character, where the states
are `0` = forest and `1` = savanna.

> Complete the BiSSE analysis for habitat type using the same commands given above.
> Remember it is useful to _clear_ the RevBayes console before starting another analysis. Do this
> using the `clear()` function.
>
> While you are setting up your new analysis, substitute the character data file name so that you read in
> `data/primates_solitariness.nex` instead of `primates_activity_period.nex`.
>
> It is **important** that you remember to also change the output file names.
>
> View the parameter log file in Tracer after your MCMC is complete.
>
> What is the rate of speciation associated with group living (`speciation[1]`)? What about
> for solitary lineages (`speciation[2]`)?
{:.instruction}

{% aside Compare the rate estimates %}
Compare the rates estimated when the activity time is the focal character versus when solitariness is the dependent character.
You can do this by opening _both_ files in the same tracer window. If you managed to give all the parameters the same name,
it is possible to compare the estimates in the Tracer window by highlighting both files.

Explore the estimates of the various parameters. Are any different? Are any the same?

Why do you think you might be seeing this pattern?
{% endaside %}

{% section Evaluate Mating System under the MuSSE Model | exercise3 %}

In RevBayes it is trivial to change the BiSSE analysis you did in the exercises above to a multi-state model that is not limited to just
binary characters. That is because the model is effectively the same, just with the variable `NUM_STATES` changed.
For this final exercise, we will use the MuSSE model {% cite FitzJohn2012 %} to estimate the rates of speciation and extinction
associated with the mating system state for each primate lineage.

Your `data` directory should contain a file called [`primates_mating_system.nex`](/data/primates_mating_system.nex). This is a four-state
character where the states are: `0` = monogamy, `1` = polygyny, `2` = polygynandry, and `3` = polyandry.

> Modify the analysis you completed for the binary state characters in the [BiSSE Exercise](#sec_CDBDP) to accommodate a 4-state character.
> This means that you must not only change the input data file (`primates_mating_system.nex`),
> but you also need to specify `NUM_STATES = 4`. The `rate_matrix` must also be modified to accommodate 4 states.
>
> It is **important** that you remember to also change the output file names.
>
> View the parameter log file in Tracer after your MCMC is complete.
>
> What is the diversification rate associated with each state (`diversification`)?
{:.instruction}





>Click below to begin the next exercise!
{:.instruction}

* [Testing for state-dependent diversification with unobserved rate variation (HiSSE)]({{ base.url }}/tutorials/sse/hisse)
