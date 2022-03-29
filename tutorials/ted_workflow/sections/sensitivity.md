{% section Assessing model sensitivity | sensitivity %}

In this section, we'll discuss how to tell whether different models affect phylogenetic estimates.
We'll use two tools for assessing model sensitivity: lineage-through-time (LTT) plots to visualize the inferred number of lineages over time and multidimensional scaling (MDS) plots to visualize differences in posterior distributions of trees.
The code for plotting LTT curves and MDS plots can all be found in the `R` script `posterior_summary/sensitivity.R`

For these examples, we'll assume you've already estimated the posterior distribution of total-evidence trees for the five models we explored in the last exercise.
(If you have just skipped to this section, you can generate the necessary output by running the following header files: `strict_Mk.Rev`, `UCLN_Mk.Rev`, `UCE_Mk.Rev`, `UCLN_F81Mix.Rev`, and `epochal_Mk.Rev` in the `headers/MCMC` directory.)

{% subsection Lineage-Through-Time Plots %}

A lineage-through-time curve displays the number of branches in the inferred tree at any given time, so we can use LTTS to summarize overall differences in divergence-time estimates between different models.
We'll use `R` and `RevGadgets` to plot the LTT curves for our different models.

First, we load some required packages and code:
```R
library(RevGadgets)
library(phytools)
source("posterior_summary/utils.R")
```

Now, we read in the trees that were sampled by a set of analyses:
```R
# read the samples
strict_samples  <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
UCLN_samples    <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
UCE_samples     <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCE_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
epochal_samples <- readTrees("output_MCMC/div_epochal_foss_epochal_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
F81Mix_samples  <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_F81Mix_MCMC/tree.trees", tree_name = "timetree")
```
The `treename` argument tells `RevGadgets` what the tree variable was called in your `RevBayes` analyses.
Since we named our tree `timetree` in our template file, we use `tree_name = "timetree"`.

Next, we combine the trees into a single list:
```R
# combine the samples into one list
combined_samples <- list(strict  = strict_samples[[1]],
                         UCLN    = UCLN_samples[[1]],
                         UCE     = UCE_samples[[1]],
                         epochal = epochal_samples[[1]],
                         F81Mix  = F81Mix_samples[[1]])
```
Note that we've named each element of the list.
For example, `strict  = strict_samples[[1]]` indicates that the first element of the list will be named `strict`.
This lets us color our LTT curves by the model name.

Now, we compute the lineage through time curves for each model:
```R
# plot the LTTs
LTTs <- processLTT(combined_samples, num_bins = 1001)
```
We evaulate the number of lineages at a finite set of time points, defined by `num_bins`.
Turning up the value of `num_bins` may make the curves look smoother, but they will also take longer to compute and may exaggerate MCMC noise.

Finally, we plot the LTT curves with `plotLTT`.
```R
plotLTT(LTTs, plotCI = FALSE)
```
For ease of interpretation, we're omitting the 95% credible intervals around the number of lineages, but you may choose to turn them on with `plotCI = TRUE`.
(You can also adjust the size of the credible interval, e.g., you can use the 50% credible interval by specifying `CI = 0.5` in the `processLTT` function.)

We can save our LTT plot to a file like so:
```R
pdf("LTTs.pdf", height = 4)
print(plotLTT(LTTs, plotCI = FALSE))
dev.off()
```
which produces {% ref LTT %}:

{% figure LTT %}
<img src="files/figures/LTTs.png" width="75%" height="75%" />
{% figcaption %}
**Lineage-through-time curves for the five models we used.** The strict clock model appears to imply a quite different diversity trajectory, in particular, it predicts more species appeared earlier.
The effect of the remaining models appears to depend on time: the UCE and epochal models predict a smaller number of species in the earlier part of the history; the epochal model predicts the largest number of lineages at the end of the Pennsylvanian; and the UCE model predicts more recent divergence times near the present.
{% endfigcaption %}
{% endfigure %}

{% subsection Multidimensional Scaling Plots %}

The lineage-through-time curves lose some information, both because we just examined the posterior average number of lineages (at least in the above example; in principle we can also plot the LTT credible intervals), and because it obscured tree topology and branch lengths.

We can use multidimensional scaling (MDS) of tree-distance metrics to compare the tree topologies and branch lengths inferred under these models (see {% citet Hillis2005 Huang2016 %}).
This involves computing a "distance" between each pair of trees within and between the posterior distributions of trees for each model.
MDS then projects these pairwise distances into a lower dimensional---and therefore easier to visualize---representation of tree space.

Two convenient distance metrics are the Robinson-Foulds distance {% cite Robinson1981 %}, which measures the topological distance between two trees, and the Kühner-Felsenstein distance {% cite Kuhner1994 %}, which incorporates both topology and branch lengths.

We'll be using the `R` package `phangorn` {% cite Schliep2011 %} to compute the distances, and `RevGadgets` to create the plots.
We'll start by reading in the data (you don't have to repeat this step if you've already read in the trees to make LTT plots, above):
```R
# read the samples
strict_samples  <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_strict_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
UCLN_samples    <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
UCE_samples     <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCE_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
epochal_samples <- readTrees("output_MCMC/div_epochal_foss_epochal_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_Mk_MCMC/tree.trees", tree_name = "timetree")
F81Mix_samples  <- readTrees("output_MCMC/div_constant_foss_constant_moleclock_UCLN_moleQ_HKY_morphclock_linked_morphQ_F81Mix_MCMC/tree.trees", tree_name = "timetree")
```

Again, we combine the tree samples into a single named list:
```R
# combine the samples into one list
combined_samples <- list(strict  = strict_samples[[1]],
                         UCLN    = UCLN_samples[[1]],
                         UCE     = UCE_samples[[1]],
                         epochal = epochal_samples[[1]],
                         F81Mix  = F81Mix_samples[[1]])
```

Now we call the `processMDS` function with the argument `type = "RF"` to compute RF distances:
```R
# make the RF MDS plots
RF_MDS <- processMDS(combined_samples, n = 100, type = "RF")
```
The argument `n` determines how many trees to use from each posterior distribution.
In this case, we're using 100 trees from each of five analyses, so there will be a total of 500 trees.
Keep in mind that we have to compute the distance for each _pair_ of trees, so the total number of distances grows quickly as `n` increases.
Large values of `n` will provide better representations of tree space, but will also take a potentially very long time to compute!
Be wary of increasing `n` too much.

We then create the MDS plot:
```R
# plot the RF MDS
RF_plot <- plotMDS(RF_MDS)

# save the plot
pdf("figures/mds_RF.pdf")
print(RF_plot)
dev.off()
```

which produces {% ref RF_MDS %}

{% figure RF_MDS %}
<img src="files/figures/mds_RF.png" width="50%" height="50%" />
{% figcaption %}
**Multidimensional scaling of tree space sampled by different models using the Robinson-Foulds distance.**
The RF metric measures the topological distance between pairs of trees, so this MDS plot represents how different inferred tree topologies are among different models.
The strict clock model in particular appears to be sampling tree topologies in only a subset of the tree space explored by other models.
{% endfigcaption %}
{% endfigure %}

We can produce an MDS plot of Kühner-Felsenstein distance likewise:
```R
# make the KF MDS plots
KF_MDS <- processMDS(combined_samples, n = 100, type = "KF")

# plot the KF MDS
KF_plot <- plotMDS(KF_MDS)

# save the plot
pdf("figures/mds_KF.pdf")
print(KF_plot)
dev.off()
```
which produces {% ref KF_MDS %}

{% figure KF_MDS %}
<img src="files/figures/mds_KF.png" width="50%" height="50%" />
{% figcaption %}
**Multidimensional scaling of tree space sampled by different models using the Kühner-Felsenstein distance.**
The KF metric incorporates both tree topology and branch lengths.
Because this MDS plot looks very similar to the MDS plot for RF distances ({% ref RF_MDS %}; note that the directions of the axes are arbitrary, so rotations don't matter), we might conclude that the main differences between these models are in the inferred tree topologies.
(Of course, we don't expect this to be a general result, just a feature of the example dataset!)
{% endfigcaption %}
{% endfigure %}
