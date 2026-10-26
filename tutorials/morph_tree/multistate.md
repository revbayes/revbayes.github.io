---
title: Discrete morphology - Multistate characters
subtitle: Partitioning characters by their number of states
authors:  April M. Wright and Basanta Khakurel
level: 3
order: 2
prerequisites:
- intro
- mcmc
- ctmc
- morph_tree
- morph_tree/rates
include_all: false
include_files:
- data/Cinctans.nex
- scripts/model_tree.Rev
- scripts/model_multistate_partition.Rev
- scripts/mcmc_multistate.Rev
index: false
redirect: false
---


{% section Introduction %}

So far in this tutorial series we have only worked with binary
characters. Real morphological matrices very often mix characters with
different numbers of observed states in the same matrix: some characters
are simple presence/absence codings, while others (like "shape of
element X: round / oval / triangular") have three, four, or more states.
This tutorial shows how to combine the Mk model and ACRV
({% page_ref morph_tree/rates %}) with a dataset like this.

We will use a dataset of 27 extinct echinoderm (cinctan) taxa and 60
binary and multistate characters, from {% citet zamora2013 %}.


{% subsection The Key Idea: Partitioning by Number of States %}

A single Q matrix has a fixed number of rows and columns, matching the
number of states of the characters it describes. This means we cannot
use one Q matrix for a matrix that mixes 2-state and 4-state characters.
Instead, RevBayes lets us split ("partition") the data matrix into
blocks that each contain only characters with the same number of
observed states, and give each block its own, appropriately-sized Q
matrix {% cite Khakurel2024 %}. All of the blocks still share the same tree and, if we want,
the same ACRV hyperparameters — only the
dimension of the Q matrix changes from block to block.


{% section Example: Inferring a Phylogeny of Extinct Cinctans | sec_multistate_analysis %}

{% subsection Data and Files | subsec_data_files %}

>Download the data file called [`Cinctans.nex`](data/Cinctans.nex) and save
>it to your `data` directory.
{:.instruction}

{% subsection Creating Rev Files | subsec_creating_files %}

>Create the Rev-script files **model_multistate_partition.Rev** and
>**mcmc_multistate.Rev** in your `scripts` directory.
{:.instruction}

We continue to reuse `model_tree.Rev`, unchanged, from
{% page_ref morph_tree %}.


{% subsection Load Data Matrices | subsec_load_data %}

Loading the data matrix works exactly as before.
{% snippet scripts/mcmc_multistate.Rev %}
morpho <- readDiscreteCharacterData("data/Cinctans.nex")
{% endsnippet %}
{% snippet scripts/mcmc_multistate.Rev %}
taxa <- morpho.names()
num_taxa <- taxa.size()
num_branches <- 2 * num_taxa - 2
{% endsnippet %}
{% snippet scripts/mcmc_multistate.Rev %}
moves    = VectorMoves()
monitors = VectorMonitors()
{% endsnippet %}
{% snippet scripts/mcmc_multistate.Rev %}
source("scripts/model_tree.Rev")
{% endsnippet %}


{% subsection Partitioning by Number of States | subsec_partition %}

In `model_multistate_partition.Rev`, we again start with Gamma-distributed
ACRV, exactly as in {% page_ref morph_tree/rates %}.
{% snippet scripts/model_multistate_partition.Rev %}
alpha_morpho ~ dnUniform( 0.0, 1E6 )
rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )
moves.append( mvScale(alpha_morpho, lambda=1, weight=2.0) )
{% endsnippet %}

We do not know in advance how many states the most variable character in
our matrix has, so we pick a generous upper bound (`n_max_states`) and
loop over every possible number of states from 2 up to that bound. For
each candidate state count `i`, we make a local copy of the data,
restrict it to only the characters that actually have `i` states using
`setNumStatesPartition()`, and skip the block entirely if it turns out
to be empty.
{% snippet scripts/model_multistate_partition.Rev %}
n_max_states <- 7
idx = 1
morpho_bystate[1] <- morpho
for (i in 2:n_max_states) {
{% endsnippet %}
{% snippet scripts/model_multistate_partition.Rev %}
    morpho_bystate[i] <- morpho
    morpho_bystate[i].setNumStatesPartition(i)
{% endsnippet %}
{% snippet scripts/model_multistate_partition.Rev %}
    nc = morpho_bystate[i].nchar()
{% endsnippet %}
For every non-empty block, we build an `i`-by-`i` Jukes-Cantor matrix
with `fnJC(i)`, and give it its own `dnPhyloCTMC`, sharing the same tree
and the same discretized rates across all blocks:
{% snippet scripts/model_multistate_partition.Rev %}
    if (nc > 0) {

        # make an i-by-i rate matrix
        q[idx] <- fnJC(i)

        # create the model of evolution for the character block
        m_morph[idx] ~ dnPhyloCTMC( tree=phylogeny,
                                    Q=q[idx],
                                    nSites=nc,
                                    siteRates=rates_morpho,
                                    type="Standard")

        # attach the data
        m_morph[idx].clamp(morpho_bystate[i])

        # increment counter
        idx = idx + 1
        idx
    }
}
{% endsnippet %}
It would not make sense to model a 5-state character using a 2-state Q
matrix (or vice versa), which is exactly what this partitioning scheme
avoids.

Back in `mcmc_multistate.Rev`, source this file, build the model, and
run the MCMC exactly as before.
{% snippet scripts/mcmc_multistate.Rev %}
source("scripts/model_multistate_partition.Rev")
{% endsnippet %}
{% snippet scripts/mcmc_multistate.Rev %}
mymodel = model(phylogeny)
{% endsnippet %}
{% snippet scripts/mcmc_multistate.Rev %}
monitors.append( mnModel(filename="output/multistate.log", printgen=10) )
monitors.append( mnFile(filename="output/multistate.trees", printgen=10, phylogeny) )
monitors.append( mnScreen(printgen=100) )
{% endsnippet %}
{% snippet scripts/mcmc_multistate.Rev %}
mymcmc = mcmc(mymodel, monitors, moves, nruns=2, combine="mixed")
mymcmc.run(generations=50000, tuningInterval=200)
{% endsnippet %}
Once the analysis is complete, we can compute several different types of
summary trees:
{% snippet scripts/mcmc_multistate.Rev %}
trace = readTreeTrace("output/multistate.trees", treetype="non-clock")
trace.setBurnin(0.25)

# maximum clade credibility tree
mccTree(trace, file="output/multistate.mcc.tre")
# maximum a posteriori tree
mapTree(trace, file="output/multistate.map.tre")
# majority rule consensus tree
consensusTree(trace, file="output/multistate.majrule.tre")
{% endsnippet %}


{% section Choose Your Own Adventure %}

For this next portion of the tutorial, we will edit some pieces of the
model. Feel free to add your own innovations. Make copies of the
relevant scripts and modify them; make sure to change the output
filenames accordingly before running the MCMC!

{% subsection Ascertainment Bias %}

As discussed in {% page_ref morph_tree %}, we should correct for
ascertainment bias whenever our matrix has no invariant characters — as
is typical of morphological data assembled under parsimony. Because our
substitution model is now split across several `dnPhyloCTMC` calls (one
per state-count partition), the fix is to add `coding="variable"` to
*each* of them. Try adding it to
`model_multistate_partition.Rev` yourself, and compare the resulting
tree-length estimates to your original, uncorrected run — you should see
the same inflation-without-correction pattern we saw for the binary
bears dataset in {% page_ref morph_tree %}.

{% subsection A Lognormal Alternative %}

As in {% page_ref morph_tree/rates %}, you can also try substituting a
discretized lognormal distribution for the Gamma distribution in
`model_multistate_partition.Rev`:
{% snippet scripts/model_ACRV_lognormal.Rev %}
rates_morpho := fnDiscretizeDistribution( dnLognormal(ln(alpha_morpho), 0.01), 4 )
{% endsnippet %}

Have each person at your table try a different one of these variants,
load all of the resulting log files into `Tracer`, and see how they
differ.

When you are ready, move on to {% page_ref morph_tree/ordered %}, where
we use the same partitioning scheme for a matrix in which some characters
are ordered, so that they can only change between adjacent states.
