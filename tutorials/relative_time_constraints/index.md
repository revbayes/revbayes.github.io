---
title:  Dating with relative constraints
subtitle: Synchronization of molecular clocks between co-existing species
authors: Dominik Schrempf, and Bastien Boussau
level: 3
prerequisites:
- intro
- mcmc
- ctmc
index: true
---

TODO Bastien
--
{:.section}

Check citation (I believe the order of authors has changed).

Check RevBayes version. Merge changes into master, and don't use development branch?

Are you satisfied with the structure?

Let me know, if you think that something is not clear!

Introduction
--
{:.section}

In phylogenetics, the term __dating__ denotes the inference of node ages of
phylogenies. For example, dating a species tree involves inference of the times
when the species split. Dating phylogenies is central to understanding the
evolution of life on Earth. However, evolutionary sequences evolve with
different rates, an observation that has been termed __relaxed molecular
clock__. In general, it is difficult to map a phylogeny obtained from a multiple
sequence alignment, and with branch lengths measured in average number of
substitutions per site, to a phylogeny with branch lengths measured in actual
units of time. For this reason, the molecular clocks are calibrated with
information gained from __fossils__, which can be accurately dated.
Incorporating fossil information enables __calibration__ of node ages of a
phylogeny.

In this tutorial, we explore another possibility to improve on the accuracy of
dating a phylogeny. Namely, horizontal gene transfers and ancient evolutionary
relationships such as symbioses are informative about the order of nodes of a
phylogeny of interest. That is, __horizontal gene transfers__ define __relative
node constraints__. Relative node constraints can be particularly helpful when
the geological record is sparse, for example, for microorganisms, which
represent the vast majority of extant and extinct biodiversity. Combination of
node calibrations with relative node constraints can significantly improve both
accuracy and resolution of molecular clock estimates {% cite Szollosi2020 %}.

Definitions
-------------
{:.section}

__Alignment__: Multiple sequence alignment.

__Time-like tree__: Phylogeny with branch lengths measured in units of time. If
the leaves have been sampled at the same time, for example, at the present, a
time-tree is ultrametric.

__Substitution-like tree__: Phylogeny with branch lengths measured in units of
substitutions. Usually, substitution-like trees are obtained from a phylogenetic
analyses of alignments.

__Calibration__: Absolute node calibration; an interval of time that specifies
the possible age of a node of a time-like tree.

__Constraint__: Relative node order constraint; a specification restricting the
order in time of two nodes of a tree.

Getting Started
------------------
{:.section}

This tutorial was tested against the development branch of Bastien Boussau,
available at [development branch of Bastien Boussau, commit
9a2ce50](https://github.com/revbayes/revbayes/tree/9a2ce50da007876bb5d6cf2f274b4f799a9cc0b8).
Similar to other RevBayes tutorials, we suggest using the following
directory structure:
```
.
├── data
├── scripts
└── output
```

The following data files are available:
```
data/
├── alignment.fasta    -- Alignment file simulated with the Jukes-Cantor (JC) model.
├── constraints.txt    -- File containing constraints.
├── substitution.tree  -- Substitution-like tree used to simulate the alignment.
└── time.tree          -- Original time-like tree to be recovered.
```

The following RevBayes script files are available:
```
scripts/
├── 1_mcmc_jc.rev                   -- Infer substition-like trees using the JC model.
├── 2_summarize_branch_lengths.rev  -- Extract posterior means and variances of branch lengths.
└── 3_mcmc_dating.rev               -- Date with calibrations and constraints.
```

Simulated data will be used, so that the inferred time-like trees can be tested
for accuracy against the correct time-like topology stored in the file
`time.tree`. Inference will be done twice: (1) using calibrations only, and (2)
using calibrations and constraints. We will work with the correct, fixed tree
topology obtained from the file `substitution.tree`. Usually, one would use the
maximum-likelihood (ML) or the maximum a posteriori (MAP) topology obtained from
the alignment.

Statement of the problem
--
{:.section}

We are interested in inferring the following time-like tree using calibrations
and constraints:

{% figure time-tree %}
<img src="figures/time-tree.png" width="600" />  
{% figcaption %}

*Time-like, ultrametric tree with 25 leaves (T0 to T24) to be inferred. The tree
was simulated using a birth process (Yule process) with a birth rate of 1.0 per
unit of time. The tree was conditioned on having height 0.3, and 25 leaves.*

{% endfigcaption %}
{% endfigure %}

However, the only information we get is an alignment simulated along the
following substitution-like tree:

{% figure substitution-tree %}
<img src="figures/substitution-tree.png" width="600" />  
{% figcaption %}

*Substitution-like tree obtained from the time-like tree by altering the branch
lengths with randomly chosen rate modifiers. The rate modifiers are sampled from
two log-normal distributions introducing frequent minor, and sparse major rate
modifications, respectively. The alignment used for inference was simulated
along this tree using the JC model.*

{% endfigcaption %}
{% endfigure %}

For reasons of computational efficiency, the inference of the time-like tree is
done in three steps. First, the posterior distributions of the branch lengths of
the substitution-like tree are inferred using the JC model (`1_mcmc_jc.rev`).
Second, the inferred posterior distributions of the branch lengths are
summarized into the posterior means and variances of the branch lengths
(`2_summarize_branch_lengths.rev`). Third, calibrations and constraints are used
to improve the accuracy of dating the phylogeny (`3_mcmc_dating.rev`). The
posterior means and variances of the branch lengths obtained in the second step
are used to approximate the phylogenetic likelihood using normal distributions.

1. Inference of the posterior distributions of the branch lengths
--
{:.section}

```bash
 rb ./scripts/1_mcmc_jc.rev

```

2. Summary of the posterior means and variances
--
{:.section}

TODO: State that the approximation of the likelihood using posterior means and
variances is optional (but recommended for reasons of computational efficiency).

Computation of posterior mean and variance of branch lengths:
```
 rb ./scripts/2_summarize_branch_lengths.rev
```

3. Dating using calibrations and constraints
--
{:.section}

TODO: Create figures with calibrations and constraints.

TODO: Mean and variance at the root have to be split up (or the sum has to be
taken).

Finally, we can estimate the time tree using relative constraints.
```
rb ./scripts/3_mcmc_dating.rev
```

Analysis of results
--
{:.section}

Branch score distances between master tree and inferred trees:

alignment.fasta.approx.dating_cons.tree
Branch score               Right 0.14207812275294182
alignment.fasta.approx.dating.tree
Branch score               Right 0.1592917560202034

Concluding remarks
--
{:.section}

Real data:
- When analyzing real data, a more appropriate substitution model should be used.
- Discuss, tree not available, has to be inferred.

Simulation scripts:
- Link to ELynx.
