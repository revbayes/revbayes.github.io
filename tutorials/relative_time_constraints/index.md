---
title:  Dating with relative constraints
subtitle: Synchronization of molecular clocks between co-existing species
authors:
- Dominik Schrempf
level: 3
prerequisites:
- intro
- mcmc
- ctmc
index: true
---

Introduction
--------------
{:.section}

Dating the phylogenies is central to understanding the evolution of life on
Earth. However, evolutionary sequences evolve with different rates (molecular
clocks), and it is difficult to map distances measured in average number of
substitutions per site to distances measured in actual units of time. For this
reason, molecular clocks are calibrated with information gained from fossils,
which can be accurately dated (node calibrations).

Further, horizontal gene transfers and ancient evolutionary relationships such
as symbioses are informative about the order of nodes on the phylogeny of
interest (relative node constraints). Relative node constraints can be
particularly helpful when the geological record is sparse, for example, for
microorganisms, which represent the vast majority of extant and extinct
biodiversity. Combination of node calibrations with relative node constraints
can significantly improve both the accuracy and resolution of molecular clock
estimates {% cite Szollosi2020 %}.

Here, we infer a timetree (tree with branches measured in units of time) guided
by node calibrations and relative node constraints.

Getting Started
------------------
{:.section}

This tutorial was tested against RevBayes version 1.1.0 released on May
13, 2020. Similar to other RevBayes tutorials, we suggest using the following
directory structure:
```
.
├── data
├── scripts
└── output
```

The following data files are available:
```
data
├── alignment.fasta    -- The alignment file simulated with the Jukes-Cantor (JC) model.
├── substitution.tree  -- The substitution-like tree used to simulate the alignment.
└── time.tree          -- The original timetree to be recovered.
```

TODO: The following RevBayes script files are available:

TODO: Create figures with calibrations and constraints.

TODO: Describe two-step process.

First step: Inference of posterior distribution of branch lengths using the
Jukes-Cantor model. When analyzing real data, a more complicated substitution
model should be used.

TODO: Discuss, tree not available, has to be inferred.

```bash
 rb ./scripts/1_mcmc_jc.rev

```

TODO: State that the approximation of the likelihood using posterior means and
variances is optional (but recommended for reasons of computational efficiency).

Computation of posterior mean and variance of branch lengths:
```
 rb ./scripts/1_summarize_branch_lengths.rev
```

TODO: Mean and variance at the root have to be split up (or the sum has to be
taken). This was bugged when combining the scripts of Bastien and Gergely.

Finally, we can estimate the time tree using relative constraints.
```
rb ./scripts/2_mcmc_dating.rev
```

Branch score distances between master tree and inferred trees:

alignment.fasta.approx.dating_cons.tree
Branch score               Right 0.14207812275294182
alignment.fasta.approx.dating.tree
Branch score               Right 0.1592917560202034