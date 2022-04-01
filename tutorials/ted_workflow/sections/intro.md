{% section Introduction | intro %}

{% subsection The Total-Evidence Dating Model %}

The total-evidence dating analysis has five model components:
1. A _tree model_ that describes how lineages are distributed over time.
2. A _molecular clock model_ that describes how rates of molecular evolution vary over the branches of the phylogeny (if at all).
3. A _molecular substitution model_ that describes the process of evolution between different nucleotide states.
4. A _morphological clock model_ that describes how rates of morphological evolution vary over the branches of the phylogeny (if at all).
5. A _morphological transition model_ that describes the process of evolution between different morphological character states (e.g., between states 0 and 1 for a binary character).

For any one of these model components, we must choose one of several possible models.
For example, we may choose to use a uniform tree distribution or a fossilized birth-death process for the tree model.
If we choose to use a fossilized birth-death process, we have to decide whether rates of diversification and/or fossilization vary over time (or even among clades).
Because these assumptions can have strong effects on our ultimate inferences, we may wish to perform analyses under various different models and compare the relative and absolute fit of these models to our data.
To learn more about these different model components, see the [CTMC]({{site.baseurl}}{% link tutorials/ctmc/index.md %}), [molecular dating]({{site.baseurl}}{% link tutorials/dating/index.md %}), [FBD]({{site.baseurl}}{% link tutorials/fbd_simple/index.md %}), and [morphological phylogenetics]({{site.baseurl}}{% link tutorials/morph_tree/index.md %}) tutorials.

{% subsection Data and Script Files %}

The data and scripts for this tutorial have a special structure.
To download all the files in the appropriate structure, click [HERE]({{site.baseurl}}/tutorials/ted_workflow/files/TED_workflow.tar.gz), and then unpack the archive.
You will want to run all of the scripts from this tutorial in the top-level directory of `TED_workflow`.

The example dataset is a pruned down version of the marattialean fern dataset analyzed in {% citet May2021 %}.
We also provide scripts for most of the models we used for that study.
However, the workflow is intended to be adapted to other datasets, and you can even add new models or variants of the existing models for your own studies.
The archive also includes a `headers` directory, a `modules` directory, and a `posterior_summary` directory, all of which we explain below.

{% subsection Script Organization %}

When we run a single analysis, it is often most convenient to write a single script that specifies every part of our model.
However, when we run a potentially large number of analyses under different models, it can be helpful to adopt a different approach.
While there are many conceivable approaches, one that we find useful is to create _headers_, which define the models to be used for a particular analysis, a _template_, which stitches together the models provided by the header file, and _module_ files which implement the individual models ({% ref organization %}).

{% figure organization %}
<img src="files/figures/organization.png" width="100%" height="100%" />
{% figcaption %}
  **Structure of the analyses.** The _header_ file (left) defines which models a particular analysis will use. The header file sources the template file. The _template_ file (middle) uses the variables defined in the header file to find and source the appropriate module files. The _module_ files (right column) specify specific model components, for example the _Mk_ model or the constant-rate fossilized birth-death model.
{% endfigcaption %}
{% endfigure %}

This tutorial focuses on the structure of a total-evidence dating analysis, and on assessing different models, rather than on the specific details of any one model.
One thing to keep in mind is that it's critical that different modules for a given model component define a common set of variables, so that we can swap different modules in without having to change other parts of the code.
For example, all diversification models will have to define parameters $\lambda$ and $\mu$, to be used by the fossilized birth-death process.
The details of how the different diversification models fill in $\lambda$ and $\mu$ will, of course, depend on the model.
We'll hide details of particular models in folds, like so (in case you want to dig in):

{% aside Module: An example model module %}

Here's a Jukes-Cantor model of sequence evolution, partitioned by alignment:
```R
# the partitioned JC substitution model
# REQUIRED: mole_Q (one per partition), mole_site_rates (one per partition), and mole_relative_rates (one per partition)

# define the Q matrix and site rates per partition
for(i in 1:naln) {

  # the Q matrices
  mole_Q[i] <- fnJC(4)

  # the site rates
  # NOTE: this model doesn't have ASRV, but we have to define it anyway
  mole_site_rates[i] <- [1.0]

}


# relative-rate multipliers among partitions
mole_proportional_rates ~ dnDirichlet(rep(1, naln))
moves.append( mvBetaSimplex(mole_proportional_rates, weight = naln) )

# rescale the rates so the mean is 1
mole_relative_rates := abs(mole_proportional_rates * naln)
```

Note that the comments at the top of the module file list what variables _have_ to be defined in this module.
These are variables that will ultimately be used by other parts of the model, so all modules for a given model component must define those variables.
For example, all substitution models must define one $Q$ matrix per data partition, a set of site rates to accommodate site-rate variation within partitions, and a set of relative rates among partitions.



{% endaside %}

{% subsection A Simple Header File %}

We'll see how this works by starting with the header file for an MCMC analysis under a simple total-evidence model (located in `headers/MCMC/strict_Mk.Rev`).

The first thing we're going to do is specify which tree model to use.
In this tutorial, we'll assume we're always using a variant of the fossilized birth-death process as our tree model.
However, there are variants of the fossilized birth-death process that assume that rates are constant over time, or that they vary over time.
We create a variable, `diversification_model`, whose value is a string that refers to a specific diversification model (which defines speciation and extinction rates).
We create an analogous variable that defines which fossilization model to use, `fossilization_model`.
In this case, we'll assume that both all of the parameters are constant over time.
```R
# tree model
diversification_model = "constant"
fossilization_model   = "constant"
```

Next, we say which molecular model we want to use.
In this case, we are using a strict molecular clock model and an HKY substitition model.
```R
# molecular model
mole_clock_model = "strict"
substn_model     = "HKY"
```

Likewise, we'll use a strict morphological clock model, and a simple model of morphological evolution, the Mk model.
```R
# morphological model
morph_clock_model = "linked"
morph_model       = "Mk"
```

Next, we'll specify what type of analysis we want to do.
In this example, we're going to start with a standard MCMC analysis; later, we'll also do "power posterior" and "posterior-predictive simulation" analyses.
```R
# the type of analysis
analysis = "MCMC"
```

There's nothing more frustrating than running two (or more) analyses but forgetting to change the output files, so all your outputs get overwritten!
To prevent this from happening, we'll create some variable in the header file that define where the output should be stored, and also build the name of the output directory based on the variables defined above (so that different analyses will end up with different output filenames).
To achieve this, we start by defining the overall output directory:
```R
# the output directory
output_dir      = "output_MCMC"
```
We then create another variable, `output_extra` that you can use to append any additional information to the output file name.
```R
output_extra    = "_run_01"
```
(We're using `output_extra` to specify a given run of the same analyses.
This lets us quickly do multiple runs by duplicating the header and changing the run number.
However, in principle, you could use this variable to keep track of any additional information you want.)

Next, we use string concatenation (`+`) to programmatically create the output filename based on the `output_dir` and the analysis-specific variables.
```R
output_filename = output_dir + "/div_" + diversification_model + "_foss_" + fossilization_model + "_moleclock_" + mole_clock_model + "_moleQ_" + substn_model + "_morphclock_" + morph_clock_model + "_morphQ_" + morph_model + "_" + analysis + output_extra + "/"
```

Finally, the header file sources the `template.Rev` file.
You can think of this as the header file handing all of the relevant information we've just defined to the template file, which then puts together all the corresponding models into one analysis.
```R
# source the template file
source("modules/template.Rev")
```

{% subsection The Template File: Reading the Data %}

The job of the template file is to take the values specified in the header to put together an analysis.
The template file is located in `modules/template.Rev`.
Let's look at it line-by-line.

Like most `Rev` scripts, the first thing we'll do in the template is create a container for moves:
```R
# moves container
moves = VectorMoves()
```
as well as some useful constants (in this case, `H` is the standard deviation for a lognormal distribution that spans one order of magnitude, which we use for some prior distributions):
```R
# convenient constants
H = ln(10) / (qnorm(0.975) - qnorm(0.025))
```

Again like a normal `Rev` script, we'll load our data.
For your own datasets, you'll want to substitute your own data files for these variables.
We'll begin by reading in our molecular dataset:
```R
# read the sequence data
moledata = readDiscreteCharacterData("data/rbcL.nex", alwaysReturnAsVector = TRUE)
naln     = moledata.size() # the number of alignments
```
The argument `alwaysReturnAsVector = TRUE` enforces that the molecular data is always assumed to be a vector.
Whether you are reading in a nexus file with a single alignment or many alignments, the result will always be a vector of alignments.
If we read one alignment, we'd just end up with a vector of length one.
This means that `moledata.size()` returns the number of alignments in the vector, not the number of sites in the alignment.
(Also note that our example molecular data file contains three alignments, one per codon position.)

Next, we read our morphological data:
```R
# read the morphological data
morphdata = readDiscreteCharacterData("data/morpho.nex")
```

Now, we read in the taxon data (including the ages associated with each taxon, as described [here]({{site.baseurl}}{% link tutorials/fbd_simple/index.md %})):
```R
# read the taxon data
taxa = readTaxonData("data/taxa.tsv", delimiter=TAB)
ntax = taxa.size()
nbranch = 2 * ntax - 2
```

It will be handy to know the number of fossils in our dataset.
To do this, we count the number of taxa in our `taxa.tsv` file that aren't sampled at time 0:
```R
# count the number of fossils
num_fossils = 0
for(i in 1:taxa.size()) {
  if (taxa[i].getMinAge() != 0) {
    num_fossils = num_fossils + 1
  }
}
```

We also need to make sure all of our character data objects have the same species in them.
We add missing data to each data object for any species that aren't sampled for that dataset.
```R
# add missing taxa to the sequence data
for(i in 1:naln) {
  x = moledata[i]
  x.addMissingTaxa(taxa)
  moledata[i] = x
}

# add missing taxa to the morphological data
morphdata.addMissingTaxa(taxa)
```

Finally, some of our fossilized birth-death models will allow diversification and/or fossilization rates to vary among geological epochs.
We'll read in a file that encodes these epochs, `epoch_timescale.csv`, and define our breakpoints accordingly.
You may wish for rates to vary over ages, periods, or some other arbitrary way; this code should work for any arbitrary piecewise timescale, as long as it is formatted the same as `epoch_timescale.csv`.
```R
# read in the timescale
timescale = readDataDelimitedFile("data/epoch_timescale.csv", header = true, delimiter=",")
num_bins  = timescale.size()
for(i in 1:num_bins) {
    breakpoints[i] <- timescale[i][2]
}
```

{% subsection The Template File: Specifying the Models %}

Here is where the rubber meets the road!
We'll start using the variables defined in the header file to create our model.

{% subsubsection The Tree Model %}

The first object we will create is the tree.
We first need to define some dataset-specific variables, for example the number of extant taxa in the tree, and the total number of extant taxa (these values will be used to compute the sampling fraction):
```R
#############################
# specifying the tree model #
#############################

# first we specify some dataset-specific parameters
extant_taxa = 10    # total number of extant taxa in the tree
total_taxa  = 111   # total number of extant taxa in the group
```
We also need to specify the minimum and maximum age of the group (the age of the lineage ancestral to the root of the tree):
```R
origin_min  = 419.2 # latest origin is the beginning of the Devonian
origin_max  = 485.4 # earliest origin is the beginning of the Ordovician
```

We assume the ancestral lineage is uniformly distributed between this minimum and maximum age.
We therefore draw it from a uniform prior distribution and place MCMC proposals on it:
```R
# draw the origin time
origin_time ~ dnUniform(origin_min, origin_max)
moves.append( mvSlide(origin_time, weight = 1.0) )
```

Now we create the diversification model (that defines speciation and extinction rates) using the variables defined in the header.
Once again, we use string concatenation to look up the appropriate file:
```R
# specify the diversification model
source("modules/diversification_models/" + diversification_model + ".Rev")
```
In this case, the above code will evaluate to `source("modules/diversification_models/constant.Rev")`, because we defined `diversification_model = "constant"` in our header file!

{% aside Module: The Constant-Rate Diversification Model %}

In this model, (`modules/diversification_models/constant.Rev`) we assume speciation ($\lambda$) and extinction ($\mu$) rates are constant over time.
We parameterize the model using the net-diversification rate ($\lambda - \mu$) and the relative extinction rate ($\mu \div \lambda$).
We use an empirical prior on the diversification rate such that the prior mean diversification rate gives rise to the known number of taxa at the present (see below for details):
```R
# the constant-rate diversification model
# REQUIRED: lambda, mu (both one per time interval)

# empirical prior on the diversification rate
diversification_prior_mean <- ln(total_taxa) / origin_time
diversification_prior_sd   <- H

# the diversification rate
diversification ~ dnLognormal( ln(diversification_prior_mean) - diversification_prior_sd * diversification_prior_sd * 0.5, diversification_prior_sd)
moves.append( mvScale(diversification, weight = 1.0) )
```
The standard deviation of this distribution is `H`, which implies that the true diversification rate is within one order of magnitude of the prior mean.

We draw the relative-extinction rate from a uniform prior between 0 and 1 (if the relative extinction rate was greater than one, the process almost certainly would have died before reaching the present):
```R
# the relative extinction rate
relext ~ dnUniform(0, 1)
moves.append( mvSlide(relext, weight = 1.0) )
```

Finally, we transform the net-diversification and relative-extinction rates into the speciation and extinction rates:
```R
# transform to real parameters
lambda := rep(abs(diversification / (1 - relext)), num_bins + 1)
mu     := abs(lambda * relext)
```
Note that we replicate `lambda` one time per time interval (`num_bins + 1`).
We are doing this because some diversification models will actually let `lambda` vary among time intervals, and other parts of the code (for example, the FBD distribution) will not know whether we are using a constant or epochal model.
Replicating `lambda` lets us use downstream code that will work the same for constant or epochal models.
The `abs()` functions just guarantee that both of these rates are positive numbers.

Here's how the empirical prior works.
For simplicity, we imagine the process begins with at time 0 and diversifies forward in time, $t$, under a deterministic growth model with growth rate (diversification rate) $\lambda - mu$.
The number of species at time $t$ is then:

$$
\begin{equation*}
N(t) = N(0) \exp^{(\lambda - \mu)t}
\end{equation*}
$$

We can turn this into an empirical prior on the mean by plugging in the number of extant species into $N(t)$, the number of initial species (one) into $N(0)$ and solving for $\lambda - \mu$:

$$
\begin{equation*}
\lambda - \mu = \frac{ln[N(t)/N(0)]}{t} = \frac{ln[N(t)]}{t}
\end{equation*}
$$

which is reflected in the prior mean code:
```R
diversification_prior_mean <- ln(total_taxa) / origin_time
```

{% endaside %}

Next, we source the fossilization model:
```R
# specify the fossilization model
source("modules/fossilization_models/" + fossilization_model + ".Rev")
```

{% aside Module: The Constant-Rate Fossilization Model %}

This model is defined in `modules/fossilization_models/constant.Rev`.
As with the constant-rate diversification model, this model assumes that the fossilization rate is constant over time.
Here, we use an empirical prior that centers the fossilization rate such that, on average, we expect to see the number of fossils we observe in the empirical dataset (see below for details):
```R
# the constant-rate fossilization model
# REQUIRED: psi (one per time interval)

# empirical prior on the fossilization rate
fossilization_prior_mean <- num_fossils * diversification_prior_mean / (exp(diversification_prior_mean * origin_time) - 1)
fossilization_prior_sd   <- 2 * H
```

We then draw the fossilization rate from the corresponding Lognormal prior:
```R
# the fossilization rate
psi_global ~ dnLognormal( ln(fossilization_prior_mean) - fossilization_prior_sd * fossilization_prior_sd * 0.5, fossilization_prior_sd)
moves.append( mvScale(psi_global, weight = 1.0) )
```

As with the constant diversification model, we replicate the global fossilization rate so there is one per time interval:
```R
# define the timelines
psi := rep(psi_global, num_bins + 1)
```

Like the diversification parameter, we've used an empirical prior on the fossilization rate, $\psi$.
If there are $N(t)$ species at time $t$, each of which leaves a fossil with rate $\psi$, then the rate at which fossils are produced by the entire population at time $t$ is $\psi \times N(t)$.
Assuming deterministic population growth at rate $\lambda - \mu$, we can compute the total number of fossils produced by the population up to time $t$, $F(t)$, by integrating time up to $t$:

$$
\begin{equation*}
F(t) = \int_0^t \psi N(s) ds = \frac{\psi (\exp^{(\lambda - \mu)t} - 1)}{\lambda - \mu}
\end{equation*}
$$

(assuming we began with a single lineage at time $t = 0$).
To derive an empirical prior mean for the fossilization rate, we plug the observed number of fossils in our dataset into $F(t)$ and solve for $\psi$, which leads to:

$$
\begin{equation}
\psi = \frac{F(t) (\lambda  - \mu) }{ \exp^{(\lambda - \mu)t} - 1 }
\end{equation}
$$

which is reflected in the code as:
```R
fossilization_prior_mean <- num_fossils * diversification_prior_mean / (exp(diversification_prior_mean * origin_time) - 1)
```

{% endaside %}

Now that we have defined our `origin_time` and the diversification and fossilization models, we can draw the tree from a fossilized birth-death distribution:
```R
# make the FBD tree
timetree ~ dnFBDP(originAge = origin_time,
                  lambda    = lambda,
                  mu        = mu,
                  psi       = psi,
                  timeline  = breakpoints,
                  condition = "survival",
                  rho       = Probability(extant_taxa / total_taxa),
                  taxa      = taxa)
```
where `breakpoints` defines where the rate parameters change, if applicable, and we condition on the process surviving (leaving at least one extant descendant).

We have to place MCMC proposals on the tree topology and branch lengths:
```R
# MCMC proposals on the tree
moves.append( mvFNPR(timetree,                       weight = ntax                             ) )
moves.append( mvNarrow(timetree,                     weight = 5 * ntax                         ) )
moves.append( mvNodeTimeSlideBeta(timetree,          weight = 5 * ntax                         ) )
moves.append( mvRootTimeSlideUniform(timetree,       weight = ntax,        origin = origin_time) )
moves.append( mvCollapseExpandFossilBranch(timetree, weight = num_fossils, origin = origin_time) )
```

Next, we place proposals on the fossils: whether or not they are sampled ancestors, and also on their exact age (to accommodate stratigraphic uncertainty):

```R
# MCMC proposals on whether fossils are sampled ancestors
moves.append( mvCollapseExpandFossilBranch(timetree, weight = num_fossils, origin = origin_time) )
num_sampled_ancestors := timetree.numSampledAncestors()

# MCMC proposals on the fossil ages
fossils = timetree.getFossils()
for(i in 1:fossils.size()) {

  # get the fossil age
  t[i] := tmrca(timetree, clade(fossils[i]))

  # specify the age contraint
  a = fossils[i].getMinAge()
  b = fossils[i].getMaxAge()

  F[i] ~ dnUniform(t[i] - b, t[i] - a)
  F[i].clamp( 0 )

  # specify a proposal on the fossil age
  moves.append( mvFossilTimeSlideUniform(timetree, origin_time, fossils[i], weight = 1.0) )

}
```

Finally, we keep track of a tree for the extant species and the tree lengths.
```R
# keep track of the extant tree
extant_tree := fnPruneTree(timetree, fossils)

# keep track of the tree length
TL        := timetree.treeLength()
TL_extant := extant_tree.treeLength()
```
{% subsubsection The Molecular Clock Model %}

Now we specify the molecular clock model:
```R
########################################
# specifying the molecular clock model #
########################################

source("modules/mole_clock_models/" + mole_clock_model + ".Rev")
```
In this header file, we assumed a strict molecular clock.

{% aside Module: The Strict Molecular Clock %}

This simple model (defined in `modules/mole_clock_models/strict.Rev`) assumes that the rate of evolution is the same across branches of the tree.
It therefore has a single parameter, which we parameterize on the log scale:
```R
# the strict molecular clock model
# REQUIRED: mole_branch_rates (either one value, or one value per branch), mole_branch_rate_mean

# the strict clock model on the log scale
mole_clock_rate_log ~ dnUniform(-10, 1)
moves.append( mvSlide(mole_clock_rate_log) )
mole_clock_rate_log.setValue(-7)
```
We then exponentiate to get the clock rate on the real scale:
```R
# exponentiate
mole_clock_rate := exp(mole_clock_rate_log)
```
Our relaxed clock models will allow one rate per branch, defined by the variable `mole_branch_rates` (a vector with one element per branch).
To keep our code generic, we'll make sure we define `mole_branch_rates` for the constant model, but just set it equal to the strict clock rate:
```R
# the branch-specific rates
mole_branch_rates := mole_clock_rate
```
Finally, we compute the mean rate of evolution among branches (sometimes we will use this for relaxed clock models, but in this case it is again equal to the clock rate itself).
```R
# the mean of the branch rates
mole_branch_rate_mean := mole_branch_rates
```

{% endaside %}

{% subsubsection The Molecular Substitition Model %}

We source the molecular substitution model as so:
```R
#####################################
# specifying the substitution model #
#####################################

source("modules/substn_models/" + substn_model + ".Rev")
```
In this analyses, we're using the HYK substitution model, partitioned among alignments (which correspond to codon positions in the example rbcL dataset).

{% aside Module: The HKY Substitution Model %}

This model is defined in `modules/substn_models/HYK.Rev`.
It has a single parameter, $\kappa$, which defines the transition to transversion ratio, and a vector of stationary frequencies, $\pi$.
We allow each molecular partition to have different $\kappa$ and $\pi$ parameters.
```R
# the partitioned HKY substitution model
# REQUIRED: mole_Q (one per partition), mole_site_rates (one per partition), and mole_relative_rates (one per partition)

# define the Q matrix and site rates per partition
for(i in 1:naln) {

  # the transition/transversion ratio
  mole_kappa[i] ~ dnLognormal(ln(1) - H * H * 0.5, H)
  moves.append( mvScale(mole_kappa[i], weight = 1.0) )

  # the stationary frequency
  mole_pi[i] ~ dnDirichlet(rep(1,4))
  moves.append( mvBetaSimplex(mole_pi[i], weight = 1.0) )

  # the Q matrices
  mole_Q[i] := fnHKY(mole_kappa[i], mole_pi[i])

  # the site rates
  # NOTE: this model doesn't have ASRV
  mole_site_rates[i] <- [1.0]

}
```
Because this model doesn't allow rate variation among sites within a partition, we set `mole_site_rates[i] <- [1.0]`.

We also want each partition to have a different overall rate.
We specify a proportional rate per partition from a Dirichlet distribution (which has a sum of one), then multiply by the number of partitions (so that the mean rate is 1):
```R
# relative-rate multipliers
mole_proportional_rates ~ dnDirichlet(rep(1, naln))
moves.append( mvBetaSimplex(mole_proportional_rates, weight = naln) )

# rescale the rates so the mean is 1
mole_relative_rates := abs(mole_proportional_rates * naln)
```
(Once again, `abs` simply reassures RevBayes that these rates are positive numbers.)

{% endaside %}

We then specify the phylogenetic CTMC models for each alignment, which depend on the tree, substitution model and molecular clock model:
```R
# make the CTMC for molecular data
for(i in 1:naln) {
  seq[i] ~ dnPhyloCTMC(timetree, mole_Q[i], branchRates = mole_branch_rates, siteRates = mole_site_rates[i] * mole_relative_rates[i])
  seq[i].clamp( moledata[i] )
}
```

{% subsubsection The Morphological Clock Model %}

Our model must also specify how rates of morphological evolution vary among lineages (if at all).
We specify this model by sourcing the appropriate module file:
```R
############################################
# specifying the morphological clock model #
############################################

source("modules/morph_clock_models/" + morph_clock_model + ".Rev")
```

We're using a "linked" morphological clock model, which assumes rates of morphological evolution are proportional to rates of molecular evolution (per branch).
In this case, because we're using a strict _molecular_ clock, this implies that rates of molecular evolution also follow a strict clock (though the absolute rate will be different between molecular and morphological characters).

{% aside Module: The Linked Morphological Clock %}

Here, we use the linked morphological clock, specified in the `modules/morph_clock_models/linked.Rev` module file.
This model has a single parameter: the absolute rate of morphological evolution, which we parameterize on the log scale and then exponentiate onto the real scale:
```R
# the linked morphological clock model
# REQUIRED: morph_branch_rates (either one value, or one value per branch)

# draw the log of the rate from a uniform distribution
morph_clock_rate_log ~ dnUniform(-10, 1)
moves.append( mvSlide(morph_clock_rate_log) )
morph_clock_rate_log.setValue(-7)

# exponentiate
morph_clock_rate := exp(morph_clock_rate_log)
```

Now we compute the branch-specific rates of morphological evolution.
Because we're assuming these are proportional to the branch-specific rates of molecular evolution, we simply rescale the molecular branch rates like so:
```R
# the branch-specific rates
# in this model, these are a multiple of the molecular branch rates
# so, the morphological branch rate = morphological clock rate * molecular branch rate / morphological clock rate
morph_branch_rates := morph_clock_rate * mole_branch_rates / mole_branch_rate_mean
```

Because all molecular clock models will define a `mole_branch_rate_mean`, this module will work in combination with all molecular clock models.
In this example, we are effectively just rescaling the (global) molecular clock rate to get the (global) morphological clock rate.

{% endaside %}

{% subsubsection The Morphological Transition Model %}

This model component describes how morphological characters change among states.
(We'll assume for simplicity that the characters are binary.
These modules would have to be modified to accommodate multistate characters.
See the [multistate tutorial]({{site.baseurl}}{% link tutorials/morph_tree/V2.md %}) for ideas of how to achieve this.)

We source the morphological transition model:
```R
#################################################
# specifying the morphological transition model #
#################################################

source("modules/morph_models/" + morph_model + ".Rev")
```

In this analysis, we're using an Mk model {% cite Lewis2001 %}.
{% aside Module: The Mk Model %}

In this analysis we're assuming that rates of transition between character states are the same, i.e., that the $Q$ matrix is symmetrical.
Because the rate matrix is normalized to have an average rate of 1, this model has no free parameters:
```R
# the Mk model of morphological evolution
# REQUIRED: morph_Q (either one, or one per mixture category), morph_site_rates, site_matrices (TRUE or FALSE)

# the Mk model
morph_Q <- fnJC(2)

# relative rates among sites
morph_site_rates <- [1.0]

# make sure we don't use site matrices
site_matrices = FALSE
```
The rates of change among characters are the same, so we use `morph_site_rates <- [1.0]`, and the rate matrix $Q$ is the same for all characters, so we set `site_matrices = FALSE`.

{% endaside %}

Just as with molecular substitution models, we hand the tree, transition model, and morphological-clock model to a phylogenetic CTMC, and clamp our observed data:
```R
# make the CMTC for morphological data
morph ~ dnPhyloCTMC(timetree, morph_Q, branchRates = morph_branch_rates, siteRates = morph_site_rates, coding = "variable", type = "Standard", siteMatrices = site_matrices)
morph.clamp( morphdata )
```
You may notice some difference between this CTMC and the ones we used for the molecular data.
First, we're using `coding = "variable"` because we're assuming we only included characters that are variable within our focal group.
This corresponds to the $v$ correction proposed by {% citet Lewis2001 %}.
Second, we also supply a `siteMatrices` argument.
This argument (when `TRUE`) indicates that the Q matrix may vary among characters, which happens when we use mixtures of rate matrices among characters (e.g. as described by the [discrete morphology tutorial]( {{site.baseurl}}{% link tutorials/morph_tree/index.md %} )).


{% subsubsection The Analysis %}

Now that we've specified the entire model, we source the specified analysis file:
```R
####################
# running analysis #
####################

source("modules/analysis/" + analysis + ".Rev")
```
This code is responsible for running whathever analyses we provide, whether it is MCMC, stepping-stone analysis, posterior-predictive simulation, etc.

We'll begin by running a simple MCMC, which we will talk about in the next section.












<!--  -->
