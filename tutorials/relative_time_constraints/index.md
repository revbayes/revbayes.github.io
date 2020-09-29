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

Step 1: Inference of the posterior distributions of the branch lengths
--
{:.section}


Please execute the following command to perform Bayesian inference of the
posterior distributions of branch lengths using a Jukes-Cantor substitution
model on a single alignment with a fixed tree topology. The Markov chain Monte
Carlo (MCMC) algorithm will be run for 30000 iterations. It will use the
alignment `data/alignment.fasta`, and the substitution-like tree
`data/substitution.tree`. The output will be a file
`output/alignment.fasta.trees` containing the 30000 trees from the MCMC chain.

```bash
 rb ./scripts/1_mcmc_jc.rev
```

For more detailed explanations of the script file, please consult the
[continuous time Markov chain tutorial](../ctmc/).

Step 2: Summary of the posterior means and variances
--
{:.section}

In this step, we will compute the posterior means and variances of the branch
lengths using the 30000 trees obtained in the previous step. Please have a look
at the script file `scripts/2_summarize_branch_lengths.rev`.

First, we specify the name of the file containing the trees, and the amount of
thinning we apply:

```
# File including trees obtained in step 1.
tree_file="alignment.fasta.trees"
# Only use every nth tree to calculate the posterior means and variances.
thinning = 5
```

Then, the trees are loaded and thinned:

```
tre = readBranchLengthTrees(outdir+file_trees_only)

print("Number of trees before thinning: ")
print(tre.size())

# Perform thinning.
index = 1
for (i in 1:tre.size()) {
  if (i % thinning == 0) {
    trees[index] = tre[i]
    index = index + 1
  }
}
```

The posterior means and squared means (which will be used to calculate
variances) are then computed:

```
print("Compute the posterior means and squared means of the branch lengths.")
num_branches = trees[1].nnodes()-1
bl_means <- rep(0.0,num_branches)
bl_squaredmeans <- rep(0.0,num_branches)

# Extract the posterior branch lengths. The index `i` is traversing the trees,
# the index `j` is traversing the branches.
for (i in 1:(trees.size())) {
  for (j in 1:num_branches ) {
    bl_means[j] <- bl_means[j] + trees[i].branchLength(j)
    bl_squaredmeans[j] <- bl_squaredmeans[j] + trees[i].branchLength(j)^2
    }
}

# Compute the posterior means and squared means.
for (j in 1:num_branches ) {
  bl_means[j] <- bl_means[j] / (trees.size())
  bl_squaredmeans[j] <- bl_squaredmeans[j] / (trees.size())
}
```

Finally, the posterior means and variances are stored in two trees having the
same topology as used for inference, respectively. In this way we ensure that
the posterior means and variances for the specific branches are tracked in a
correct way.

```
################################################################################
# Save the posterior means in a separate tree.

print("Compute the tree with posterior means as branch lengths.")
meanTree = readBranchLengthTrees(outdir+file_trees_only)[1]

print("Original mean tree before changing branch lengths")
print(meanTree)

for (j in 1:num_branches ) {
  meanTree.setBranchLength(j, bl_means[j])
}

print("Tree with posterior means as branch lengths.")
print(meanTree)

writeNexus(outdir+tree_file+"_meanBL.nex", meanTree)
print("The tree with posterior mean branch lengths has been saved.")

################################################################################
# Save the posterior variances in a separate tree.

print ("Compute tree with posterior variances as branch lengths.")
varTree = readBranchLengthTrees(outdir+file_trees_only)[1]

print("Original variance tree before changing branch lengths")
print(varTree)

for (j in 1:num_branches ) {
  varTree.setBranchLength(j, abs ( bl_squaredmeans[j] - bl_means[j]^2) )
}

print("Tree with posterior variances as branch lengths.")
print(varTree)

writeNexus(outdir+tree_file+"_varBL.nex", varTree)
print("The tree with posterior variance branch lengths has been saved.")
```

To run the script, please execute
```bash
 rb ./scripts/2_summarize_branch_lengths.rev
```

The approximation of the phylogenetic likelihood using posterior means and
variances is optional but recommended for reasons of computational efficiency.


Step 3: Dating using calibrations and constraints
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
