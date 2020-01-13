---
title: A simple FBD analysis
subtitle: Joint inference of divergence times and phylogenetic relationships of fossil and extant taxa from morphological data
authors:  Tracy A. Heath, Josh Justison, Joëlle Barido-Sottani, and Walker Pett
level: 1
order: 15
prerequisites:
- intro
- mcmc
exclude_files:
index: true
redirect: false
---


{% section Overview | overview %}

This tutorial shows a simple phylogenetic analysis of extant and fossil bear species (family Ursidae), using morphological data as well as fossil occurrence data from the fossil record. 

{% section Introduction | introduction %}

In this section we will describe and build the model we use for the phylogenetic analysis.

First to get an overview of the model, it can be useful to first think of the model as a generating process for our data. Suppose we were trying to simulate our fossil and morphological data; we would consider two components:

- **Time tree model**: This is the diversification process that describes the how a phylogeny is generated as well as when fossils are sampled along each lineage on the phylogeny.  This component generates the phylogeny, the fossil occurrence data, and is used downstream in the trait evolution model.
- **Morphological trait evolution model**: The trait evolution model describes how the morphological characters change over time on the phylogeny. This component is used along with the time tree component to generate morphological data for both the extant taxa and fossils. 

These two components, or modules, will create the backbone of our inference model and reflect our prior beliefs on how the tree, fossil data, and morphological trait data occur. There are numerous specific processes that can be used in both of the components. We will provide a brief overview of the specific models used within each component while pointing to other tutorials that implement different models. 

{% subsection Time Tree Model: The Fossilized Birth-Death Process %}

The fossilized birth death process (FBD) provides a joint distribution on the divergence times of living and extinct species, the tree topology, and the sampling of fossils. The FBD can be broken into two sub processes, the birth-death process and the fossilization process.

{% subsubsection Birth-Death Process %}

We will consider a constant-rate birth-death process. Every lineage has the same constant rate of speciation lambda and rate of extinction mu at any moment in time. Speciation and extinction events along a lineage follow a Poisson process with parameters $\lambda$ and $\mu$ respectively. This means that the time between either speciation or extinction events along a given lineage is exponentially distributed with parameter ($\lambda$ + $\mu$). Then given an event occurred, the probability of the event being a speciation is ($\lambda$ / ($\lambda$+$\mu$)) while the probability of the event being an extinction is ($\mu$ / ($\lambda$+$\mu$)). 

The birth-death process depends on two other parameters as well, the root age and the sampling probability. The root age or origin time, denoted $\phi$, represents the starting time of the stem lineage. The sampling probability, denoted $\rho$, gives the probability that an extant species is sampled.

The assumption that, at any given time, each lineage has the same speciation rate and extinction rate may not be realistic or valid in some systems. RevBayes currently allows for this assumption to be violated in numerous ways such as, episodic diversification rates, environmental-dependent diversification rates, branch-specific diversification rates, or having diversification rates tied to an evolving species trait. 

{% subsubsection Fossilization Process %}

Given a phylogeny, in this case a phylogeny from the birth-death process, the fossilization process provides a distribution for the fossil sampling on the phylogenetic tree. Much like speciation and extinction, fossil sampling is modeled Poisson process with rate parameter $\psi$. This means that each lineage has the same constant rate of producing a fossil. As a result, along a given lineage, the time between fossilization events is exponentially distributed with rate $\psi$.

**Talk about how uncertainty in the fossil occurrence data is modeled!**

One key assumption of the FBD model is that each fossil sample is taken to be a different taxonomic entity. However, if certain taxa persist thru time and fossilize particularly well then the same taxa may be sampled at different stratigraphic ages. In this case one might want to consider the fossilized birth-death range process in RevBayes to model the stratigraphic ranges of fossil occurrences. 

{% subsection Morphological Trait Evolution Model %}

Given a phylogeny, the morphological trait evolution model will model how traits change along each lineage, resulting in the observed morphologies of fossils and living species. In our case the phylogeny and fossil occurrences are generated from the FBD process and we will be modelling the evolution of discrete traits with two states. There are three main components to consider with modeling morphological traits: the substitution model, the branch rate model, and the site rate model. 

{% subsubsection Substitution Model %}

 The substitution model describes how traits transition from one character to another. We will be using the Mk model, a generalization of the Jukes-Cantor model. However, since our characters have only two states we specifically using the Mk2 model. The Mk models assume that each trait has an equal rate of transitioning from one to any other state, in our case a transition from 0 to 1 is equally as likely as a transition from 1 to 0.

It is known that when some traits transition into a certain state that it is rare for it to transition back, this likely means that the assumption of symmetric rates is broken. Alternatively, asymmetric transition rates for each state can be specified in RevBayes. Traits can also be partitioned into if different substitution models better describe each group.

{% subsubsection Branch Rate Model %}

This component models quickly each branch evolves relative to one another. Each tree branch can be given a non-negative real value that acts as a scalar for the rate of trait evolution. In our case we assume each branch has the same rate of evolution, this is known as the strict clock.

The assumption of a strict clock can be relaxed. Usage of an uncorrelated clock is shown here. 

{% Site Rate Model %}

The site rate model describes how quickly each trait evolves relative to one another. Similar to the branch rate model in that scalars are used to modulate rates of change, however, instead of giving a scalar to each branch, a scalar is given to each trait to model the disparity between their rates of evolution. In our case we will assume that each trait will belong to one of four rate categories of the discretized gamma distribution. In our case, the discretized gamma distribution is parameterized by shape parameter $\alpha$ and number of rate categories **n**. Normally a gamma distribution requires a shape $\alpha$ and rate $\beta$ parameters, however, we want our site rates to have a mean of one and this occurs only when $\alpha$**=**$\beta$, thus eliminating the rate parameter. The parameter **n** breaks the gamma distribution into **n** equiprobable groups where the value mass of each group is equal to the mean value within that group. 

**Talk about what a low/high alpha does as well as discuss how people justified their chosen n value **

{% subsection Putting the model together %}

We have outlined the specific processes used to model the time tree component and morphological trait evolution component of our model along with their affiliated parameters. Fig _A shows our model as a probabilistic graph that we can use for inference. If we knew all of the associated parameters all we would need to do is fit our data to the model to estimate the reconstructed phylogeny of sampled living and fossilized taxa. However, in practice these parameters are not known and must be estimated with the phylogeny. We need to model each parameter from a prior distribution that reflects our beliefs about how that parameter value was generated (model with priors shown in Fig_ B). 

{% subsection Creating other models %}

Although our model choices were relatively simplistic, the modular design of RevBayes allows for certain model choices to easy be swapped out with perhaps more biologically relevant processes for a given system. RevBayes also allows for other modules to describe other types of data (e.g. nucleotide sequences, historical biogeographic ranges) and can integrate different modules together for a “combined- evidence” approach. Ultimately, the design of the model should reflect the data and which processes are believed to generate the model. 

{% section Setting up the analysis | analysis %}

In this section, we will create the RevLanguage script which will be used to run our phylogenetic analysis in RevBayes.

{% subsection Data and files %}

>On your own computer or your remote machine, create a directory called `RB_FBD_Tutorial`
>(or any name you like).
>
>Then, navigate to the folder you created and make a new one called `data`.
>
>Download the files listed below into the `data` folder, by clicking on the hyperlinked file names below (these files are also listed in the "Data files and scripts" box at the top of this page).
{:.instruction}

In the `data` folder, add the following files:

-   [`bears_taxa.tsv`](data/bears_taxa.tsv): a tab-separated table listing the 18 bear species in our analysis (both fossil and extant) and their occurrence age ranges (minimum and maximum ages). For extant taxa, the minimum age is 0.0 (*i.e.* the present).

-   [`bears_morphology.nex`](data/bears_morphology.nex): a matrix of 62 discrete, binary (coded `0` or `1`) morphological characters for our 18 species of fossil and extant bears.
    
> In the main directory created above, create a blank file called `FBD_tutorial.Rev` and open it in a text editor.
{:.instruction}

This file will be our main script, and will contain all the instructions required to load the data, assemble the different models used in the analysis, and finally configure and run the MCMC. Note that it is possible to split instructions between different Rev scripts, however in this tutorial we will use only one file to keep things simple.

{% assign mcmc_script = "FBD_tutorial.Rev" %}

{% subsection Importing the data into RevBayes %}

We will begin the Rev script by loading the two data files that were downloaded previously.

{{ mcmc_script | snippet:"block#","1" }}

The function `readTaxonData` reads a tab-delimited file. This command creates a variable called `taxa` which contains a table with all of the fossil and extant bear species names in the first column, their minimum age in the second column and their maximum age in the third column.

Next, we will import the morphological character matrix and assign it to the variable `morpho`.

{{ mcmc_script | snippet:"block#","2" }}

RevBayes uses the function `readDiscreteCharacterData` to load a data matrix to the workspace from a formatted file. This function can be used for both molecular sequences and discrete morphological characters.

{% subsection Helper variables %}

Before we begin writing the Rev scripts for each of the model components, we need to instantiate a couple "helper variables" that will be used by downstream parts of our model specification.

We will create a new constant node called `n_taxa` that is equal to the number of species in our analysis (18).

{{ mcmc_script | snippet:"line","22" }}

Next, we will create a workspace variable called `moves`, which is a vector that will contain all of the MCMC moves used to propose new states for every stochastic node in the model graph. Each time a new stochastic node is created in the model, we can append the move to this vector.

{{ mcmc_script | snippet:"line","23" }}

One important distinction here is that `moves` is part of the RevBayes workspace and not the hierarchical model. Thus, we use the workspace assignment operator `=` instead of the constant node assignment `<-`.

{% subsection The Fossilized Birth-Death process %}

{% subsubsection Speciation and extinction rates | FBD-SpeciationExtinction %}

Two key parameters of the FBD process are the speciation rate (the rate at which lineages are added to the tree, denoted by $\lambda$ in {% ref fig_fbd_gm %}) and the extinction rate (the rate at which lineages are removed from the tree, $\mu$ in {% ref fig_fbd_gm %}).
We will place exponential priors on both of these values, meaning each parameter will be assumed to be drawn independently from a different exponential distribution with rates $\delta_{\lambda} = 10$ and $\delta_{\mu} = 10$ respectively. Note that an exponential
distribution with $\delta = 10$ has an expected value (mean) of $1/10$.

We will create the exponentially distributed stochastic nodes for the `speciation_rate` and `extinction_rate` using the `~` stochastic assignment operator.

{{ mcmc_script | snippet:"block#","4" }}

For every stochastic node we declare, we must also specify proposal algorithms (called *moves*) to sample the value of the parameter in proportion to its posterior probability. If a move is not specified for a stochastic node, then it will not be estimated, but fixed to its initial value.

The extinction rate and speciation rate are both positive, real numbers (*i.e.* non-negative floating point variables). For both of these nodes, we will use a scaling move (`mvScale`), which proposes multiplicative changes to a parameter.
Many moves also require us to set a *tuning value*, called `lambda` for `mvScale`, which determine the size of the proposed change. Here, we will use three scale moves for each parameter with different values of lambda. Using multiple moves for a single parameter will improve the mixing of the Markov chain.

{{ mcmc_script | snippet:"block#","5-6" }}

You will also notice that each move has a specified `weight`. This option indicates at which frequency a given move will be performed in each MCMC cycle. In RevBayes, the MCMC is executed by default with a *schedule* of moves at each step of the chain, instead of just one move per step, as is done in MrBayes {% cite Ronquist2003 %} or BEAST {% cite Drummond2012 Bouckaert2014 %}. 
Here, if we were to run our MCMC with our current vector of 6 moves, then our move schedule would perform 6 moves at each cycle. Within a cycle, an individual move is chosen from the move list in proportion to its weight. Therefore, with all six moves assigned `weight=1`, each has an equal probability of being executed and will be performed on average one time per MCMC cycle. 
For more information on moves and how they are performed in RevBayes, please refer to the {% page_ref mcmc %} and {% page_ref ctmc %} tutorials.

In addition to the speciation ($\lambda$) and extinction ($\mu$) rates, we may also be interested in inferring the diversification rate ($\lambda - \mu$) and the turnover ($\mu/\lambda$). Since these parameters can be expressed as a deterministic transformation of the speciation and extinction rates, we can monitor their values (i.e. track their values and print them to a file) by creating two deterministic nodes using the `:=` deterministic assignment operator.

{{ mcmc_script | snippet:"block#","7" }}


{% subsubsection The extant sampling probability | FBD-Rho %}

All extant bears are represented in this dataset. Therefore, we will fix the probability of sampling an extant lineage ($\rho$ in {% ref fig_fbd_gm %}) to 1. The parameter `rho` will be specified as a constant node using the `<-` constant assignment operator.

{{  mcmc_script | snippet:"block#","8" }}

Because $\rho$ is a constant node, we do not have to assign a move to this parameter.

{% subsubsection The fossil sampling rate | FBD-Psi %}

Since our data set includes serially sampled lineages, we must also account for the rate of sampling through time. This is the fossil sampling (or recovery) rate ($\psi$ in {% ref fig_fbd_gm %}), which we will instantiate as a stochastic node (named `psi`). As with the speciation and extinction rates (see {% ref FBD-SpeciationExtinction %}), we will use an exponential prior on this parameter and use scale moves to sample values from the posterior distribution.

{{  mcmc_script | snippet:"block#","9-10" }}

{% subsubsection The origin time | FBD-Origin %}

The FBD process is conditioned on the origin time ($\phi$ in {% ref fig_fbd_gm %}), so we need to specify the origin of the bears clade. We will set a uniform distribution on the origin age, with the lower bound set at the age of the oldest bear fossil and the higher bound set to **justification for the higher bound ?**. 
For the move, we will use a sliding window move (`mvSlide`), which samples a parameter uniformly within an interval (defined by the half-width `delta`). Sliding window moves can be problematic for small values, as the window may overlap zero. However, our prior on the origin age excludes values $\leq 37.0$, so this is not an issue.

{{  mcmc_script | snippet:"block#","11-12" }}

Note that we specified a higher move `weight` for each of the proposals operating on `origin_time` than we did for the three previous stochastic nodes. This means that our move schedule will propose five times as many updates to `origin_time` as it will to `speciation_rate`, `extinction_rate`, or `psi`. **Missing: justification for the higher weight**

{% subsubsection The FBD distribution | FBD-dnFBD %}

All the parameters of the FBD process have now been specified. The next step is to use these parameters to define the FBD tree prior distribution, which we will call `fbd_dist`.

{{  mcmc_script | snippet:"block#","13" }}

Next, in order to sample from the posterior distribution of trees, we need to specify moves that propose changes to the topology (e.g. `mvFNPR`) and node times (e.g. `mvNodeTimeSlideUniform`). We also include a proposal that will collapse or expand a fossil branch (`mvCollapseExpandFossilBranch`), i.e. change a fossil that is a sampled ancestor (see {% ref fig_example_tree %} and {% ref Intro-FBD %}) to a sampled tip, and vice-versa. In addition, when conditioning on the origin time, we also need to explicitly sample the root age (`mvRootTimeSlideUniform`).

{{  mcmc_script | snippet:"block#","14-15" }}

{% subsubsection Sampling fossil occurrence Ages | FBD-TipSampling %}

Next, we need to account for uncertainty in the age estimates of our fossils using the observed minimum and maximum stratigraphic ages. Remember, we can represent the fossil likelihood using any uniform distribution that is non-zero when the likelihood is equal to one (see {% ref Intro-TipSampling %}). For example, if $t_i$ is the inferred fossil age and $(a_i,b_i)$ is the observed stratigraphic interval, we know the likelihood is equal to one when $a_i < t_i < b_i$, or equivalently $t_i - b_i < 0 < t_i - a_i$. So we can represent this likelihood using a uniform random variable,  uniformly distributed in $(t_i - b_i, t_i - a_i)$ and clamped at zero.

To do this, we will get all the fossils from the tree and use a `for` loop to iterate over them. For each fossil observation, we will create a uniform random variable representing the likelihood, based on the minimum and maximum ages specified in the file [`bears_taxa.tsv`]. 

{{  mcmc_script | snippet:"block#","16-18" }}

Finally, we will add a move that samples the ages of all the fossils on the tree.

{{  mcmc_script | snippet:"block#","19" }}

{% subsubsection Monitoring parameters of interest | FBD-DetNodes %}

There are additional parameters that may be of particular interest to us that are not directly sampled as part of the graphical model defined here. As with the diversification and turnover nodes specified in {% ref FBD-SpeciationExtinction %}, we can create deterministic nodes to sample the posterior distributions of these parameters. Here we will create a deterministic node called `num_samp_anc` that will compute the number of sampled ancestors in our `fbd_tree`.

{{  mcmc_script | snippet:"block#","20" }}

We are also interested in the age of the most-recent-common ancestor (MRCA) of all living bears. To monitor this age in our MCMC sample, we must use the `clade` function to identify the node corresponding to the MRCA. Once this clade is defined we can instantiate a deterministic node called `age_extant` that will record the age of the MRCA of all living bears, using the `tmrca` function.

{{  mcmc_script | snippet:"block#","21" }}

In the same way we monitored the MRCA of the extant bears, we can also monitor the age of a fossil taxon that we may be interested in recording. We will monitor the marginal distribution of the age of *Kretzoiarctos beatrix*, which is sampled between 11.2–11.8 My.

{{  mcmc_script | snippet:"block#","22" }}

{% subsection Modeling the Evolution of Binary Morphological Characters | Exercise-ModelMorph %}

In this section we will define the model of morphological character evolution.

As stated in the introduction we will
use Mk to model our data. Because the Mk model is a generalization of
the Jukes-Cantor model, we will initialize our Q matrix from a Jukes-Cantor
matrix.

{{ mcmc_script | snippet:"block#","23" }}

As in the molecular data partition, we will allow gamma-distributed rate
heterogeneity among sites.

{{ mcmc_script | snippet:"block#","24-25" }}

The phylogenetic model also assumes that each branch has a rate of
morphological character change. For simplicity, we will assume a strict
exponential clock—meaning that every branch has the same rate drawn from
an exponential distribution (see ).

{{ mcmc_script | snippet:"block#","26-27" }}

As in our molecular data partition, we now combine our data and our
model in the phylogenetic CTMC distribution. There are some unique
aspects to doing this for morphology.

You will notice that we have an option called `coding`. This option
allows us to condition on biases in the way the morphological data were
collected (ascertainment bias). The option `coding=variable` specifies
that we should correct for coding only variable characters (discussed in
).

{{ mcmc_script | snippet:"block#","28" }}

{% subsection Monitoring variables %}

{% subsection MCMC %}

{% section Results %}

{% subsection Evaluating convergence %}

{% subsection Summarizing the tree %}