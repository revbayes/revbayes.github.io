---
title: Introduction to RevGadgets
subtitle: Plotting the output of RevBayes analyses in the R package RevGadgets.
authors: Carrie M. Tribble and Michael R. May
level: 0
order: 1.0
prerequisites: 
- intro
index: true
include_all: false
include_files:
- data/primates_cytb_GTR.log
- data/freeK_RJ.log
- data/primates_cytb_GTR_MAP.tre
- data/bears.mcc.tre
- data/relaxed_OU_MAP.tre
- data/ase_freeK.tree
- data/simple.ase.tre
- scripts/parameter_estimates.R
- scripts/visualize_trees.R
- scripts/mcmc_relaxed_OU.Rev
- scripts/anc_states.R
redirect: false
---

Overview
==============
{:.section}

{% figure %}
<img src="figures/RevGadgets_logo.png" height="50%" width="50%" />
{% endfigure %}

Through user-friendly data pipelines, `RevGadgets` guides users through importing RevBayes output into `R`, processing the output, and producing figures or other summaries of the results. 
`RevGadgets` provide paired processing and plotting functions built around commonly implemented analyses, such as tree building and divergence-time estimation, diversification-rate estimation, ancestral-state reconstruction and biogeographic range reconstruction, and posterior predictive simulations.
Using the general framework of `ggplot2`, the tidyverse, and associated packages {% cite wickham2011ggplot2 wickham2019welcome %}, plotting functions return plot objects with default aesthetics that users may customize. Below, we walk you through installation and several case studies to illustrate primary functionalities.

Installation
============
{:.section} 

`RevGadgets` is available to download from GitHub using `devtools`: 

```{R}
install.packages("devtools")
devtools::install_github("cmt2/RevGadgets")
```

{% aside Note about `magick` dependency %}

`RevGadgets` depends on the `R` package `magick`, which in turn depends on external software `ImageMagick`. If `RevGadgets` installation fails, you may need to install `ImageMagick`. On a mac or Linux machine, this can be done using homebrew on terminal or your Linux shell:

```
brew install imagemagick
```
Alternatively, visit the [ImageMagick website](https://imagemagick.org/script/download.php) for more download options.

{% endaside %}

Getting Started
===============
{:.section} 
To run this tutorial, download the associated files from the `Data files and scripts` menu. 
Open `R` and make sure your working directory is set to the directory with the downloaded files. 
For more information on how to customize these plots, see the associated documentation for each function (e.g., `?readTrace`)).
Submit feature requests or bug reports with Issues on [GitHub](https://github.com/cmt2/RevGadgets). 


Visualizing Parameter Estimates 
==============
{:.section} 

`RevGadgets` provides several tools that facilitate the visualization of posterior distributions of parameters. 
The output of most `RevBayes` analyses is a is a tab-delimited file where rows correspond to samples of an MCMC algorithm and columns correspond to parameters in the model. 
Most information of interest to researchers, such as the most probable parameter values and the 95% credible interval or set (CI/CS), require processing raw MCMC output.  
Visualizing MCMC output is critical for evaluating and troubleshooting analyses, especially for diagnosing bizarre pathologies in MCMC convergence and model results. 

The following code demonstrates how to process and visualize the MCMC trace file of a general time-reversible (GTR) substitution model analysis {% cite Tavare1986 %}, in which we have estimated the substitution rate and stationary frequency parameters for a single gene in a sample of 23 primates {% cite springer2012 %}. This analysis is covered in the {% page_ref ctmc %} tutorial.

&#8680; To reproduce this section, see: `parameter_estimates.R`

First, load the `RevGadgets` package: 

```{R}
library(`RevGadgets`)
```

Then, read in and process the trace file.
Burnin (the samples taken before the Markov chain reached stationarity) may be removed at this stage or after examining the trace file further.

```{R}
file <- "primates_cytb_GTR.log"

trace_quant <- readTrace(path = file, burnin = 0.1)

# or 

trace_quant <- readTrace(path = file)
trace_quant <- removeBurnin(trace = trace_quant, burnin = 0.1)

```

The output of `readTrace()` may be passed to `R` packages specializing in MCMC diagnoses such as `coda` {% cite plummer2006coda %}. Note that `RevGadgets` does not require `coda`, so you will have to install it separately. 


```{R}
trace_quant_MCMC <- coda::as.mcmc(trace_quant[[1]])

coda::effectiveSize(trace_quant_MCMC)

coda::traceplot(trace_quant_MCMC)
```

Alternatively, use the `R` package `convenience` (described here: {% page_ref convergence %}) to assess convergence before processing the data with `RevGadgets`. 

`RevGadgets` provides its own core functions for summarizing and visualizing traces of specific parameters. 
`SummarizeTrace()` calculates the mean and 95% credible interval for quantitative variables and the 95% credible set for qualitative variables.
To examine the stationary frequency (pi) parameter values in our trace file, summarize their distributions:

```{R}
summarizeTrace(trace = trace_quant, 
               vars =  c("pi[1]","pi[2]",
                           "pi[3]","pi[4]"))
```
```{R}
$`pi[1]`
$`pi[1]`$trace_1
        mean        median        MAP  
        0.3280593   0.3282250     0.3265728      
        quantile_2.5  quantile_97.5 
        
        0.3080363     0.3481651
        
...

$`pi[4]`
$`pi[4]`$trace_1
        mean        median        MAP  
        0.2152190   0.2145595     0.2144797
        
        quantile_2.5  quantile_97.5
        0.2020019     0.2278689

```

Then plot these distributions:
```{R}
plotTrace(trace = trace_quant, 
          vars = c("pi[1]","pi[2]",
                     "pi[3]","pi[4]"))
```
Colored areas under the curve indicate the 95% credible interval. 

![image](figures/traceQuant.png)

These functions may also process and plot posterior estimates of qualitative (discrete) variables, such as the the binary character indicating if certain transition rates among character states exist (i.e. if the corresponding transitions are possible), from a reversible jump MCMC (rjMCMC) ancestral-state reconstruction analysis. See the {% page_ref morph/morph_more %} tutorial for information on performing this RevBayes analysis. 

First, read and summarize the data: 
```{R}
file <- "freeK_RJ.log"
trace_qual <- readTrace(path = file)
summarizeTrace(trace_qual, 
			vars = c("prob_rate_12", "prob_rate_13", "prob_rate_21",
			"prob_rate_23", "prob_rate_31", "prob_rate_32"))
```
```{R}
$prob_rate_12
$prob_rate_12$trace_1
credible_set
        1         0 
0.6440396 0.3559604 
...
$prob_rate_32
$prob_rate_32$trace_1
        0 
0.9724475
```
Then plot the distributions as histograms:
```{R}
plotTrace(trace = trace_qual, 
		vars = c("prob_rate_12", "prob_rate_13", 
				"prob_rate_31", "prob_rate_32"))
```
![image](figures/traceQual.png)
Colored areas within bars indicate the credible set.

Visualizing Phylogenies
=======================
{:.section} 

Phylogenies are central to all analyses in `RevBayes`, and accurate and information-rich visualizations of evolutionary trees are thus critical.
`RevGadgets` contains methods to visualize phylogenies and their associated posterior probabilities, divergence time estimates, geological time scales, and branch rates.
Additionally, text annotation may be added to specify associated data, such as posterior probabilities of nodes or node ages. 
Users may modify aesthetics such as colors, sizes, branch thickness, and tip label formatting through specific function arguments or by adding layers to the resulting ggplot object.

&#8680; To reproduce this section, see: `visualize_trees.R`

Basic tree plots
----------------
{:.subsection} 

RevGadgets reads and processes single trees, such as those produced by the {% page_ref ctmc %} tutorial, and tree traces with `readTrees()`:

```{R}
file <- "primates_cytb_GTR_MAP.tre"
tree <- readTrees(paths = file)
```
`rerootPhylo()` roots the tree and `plotTree()` produces a basic tree plot, which may be modified by changing the formatting of tip labels, adjusting tree line width, and adding posterior probabilities of nodes as internal node labels. This plot object is modifiable in the same way as `ggplot`. Here, we add a scale bar: 
```{R}
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Galeopterus_variegatus")

plot <- plotTree(tree = tree_rooted, node_labels = "posterior", 
				 node_labels_offset = 0.005, node_labels_size = 3, 
				 line_width = 0.5, tip_labels_italics = T)

plot + ggtree::geom_treescale(x = -0.35, y = -1)
```
![image](figures/basic_tree.png)

Fossilized birth-death trees
----------------------------
{:.subsection} 

RevGadgets elaborates on the `plotTree` to plot fossilized birth death analyses, such as those described in the {% page_ref fbd_simple %} tutorial. This plot includes a geological timescale, labeled sampled ancestors along branches and their species names as annotated text in the top left corner, and node and tip age bars colored by their corresponding posterior probabilities.

```{R}
file <- "bears.mcc.tre"
tree <- readTrees(paths = file)
plot <- plotFBDTree(tree = tree, 
					timeline = T, 
					geo_units = "epochs",
					tip_labels_italics = T,
					tip_labels_remove_underscore = T,
					tip_labels_size = 3, 
					tip_age_bars = T,
					node_age_bars = T, 
					age_bars_colored_by = "posterior",
					label_sampled_ancs = TRUE) + 
      		theme(legend.position=c(.05, .6))
```
![image](figures/FBDTree.png)


Branch rates 
-------------
{:.subsection} 

The `plotTree()` function can color the branches of the tree, which is useful for indicating branch rates, or other continuous parameters. For example, `plotTree()` here colors the branches by branch-specific optima (thetas) from a relaxed Ornstein_Uhlenbeck model of body size evolution in whales. The {% page_ref cont_traits/relaxed_ou %} tutorial covers this type of analysis. 

```{R}
file <- "relaxed_OU_MAP.tre"
tree <- readTrees(paths = file)
plotTree(tree = tree, 
         tip_labels_italics = FALSE,
         color_branch_by = "branch_thetas", 
         line_width = 1.7) + 
 theme(legend.position=c(.1, .9))
```
![image](figures/treeOU.png)

To produce the imput file for this plot `relaxed_OU_MAP.tre`, you will need to run a slightly modified script from the tutorial. See `mcmc_relaxed_OU.Rev` for this modification. 

Ancestral-State Reconstruction
==============================
{:.section} 

Ancestral state reconstruction methods allow users to model how heritable characters, such as phenotypes or geographical distributions, have evolved across a phylogeny, producing probability distributions of states for each node of the phylogeny.
This aspect of `RevGadgets` functionality allows users to plot the maximum \emph{a posteriori} (MAP) estimate of ancestral states via `plotAncStatesMAP()` or a pie chart showing the most probable states via `plotAncStatesPie()`.
Ancestral-state plotting functions in `RevGadgets` allow users to demarcate character states and their posterior probabilities by modifying the colors, shapes, and sizes of node and shoulder symbols. 
Text annotations may be added to specify states, state posterior probabilities, and the posterior probabilities of nodes. 

&#8680; To reproduce this section, see: `anc_states.R`

To plot the output of an ancestral state estimation of placenta type across models, `RevGadgets` first summarizes the `RevBayes` output file and then creates the plot object. The analysis that produced this output file is describe in the  {% page_ref morph/morph_more %} tutorial.

```{R}
file <- "ase_freeK.tree"
freeK <- processAncStates(file, 
						  state_labels = c("1" = "Epitheliochorial", 
										   "2" = "Endotheliochorial", 
										   "3" = "Hemochorial"))
plot <- plotAncStatesMAP(t = freeK, 
              tree_layout = "circular") + 
  theme(legend.position = c(0.57,0.41))
```
![image](figures/ancStatesMAP_trimmed.png)

Here, the color of node circles indicates the estimated ancestral states and the size of the circles corresponds to the posterior probability of that state. 

For standard evolutionary models of anagenetic (within-lineage) change such as demonstrated above, states are plotted at the nodes. 
However, cladogenetic models allow for two ways that character states can change on the phylogeny: shifts can occur along branches of the tree (anagenetic change) or happen precisely at the moment of speciation (cladogenetic change) {% cite Ree2008 Goldberg2012 %}. 
To remedy this problem `RevGadgets` plots the results of inferences using cladogenetic models on "shoulders" as well as the nodes.

For example, many biogeographic models, including the popular Dispersal-Extirpation-Cladogenesis model described in {% page_ref biogeo/biogeo_intro %}, include cladogenetic change. 
`plotAncStatesPie()` is a special case of `plotAncStatesMAP()` where the symbols at nodes are pie charts of the most probable states for that node plus an "other" category of any remaining probability.
We demonstrate this functionality with a visualization of the ancestral ranges of Hawaiian silverswords estimated using a DEC biogeographic analysis and include shoulder states to indicate cladogenetic as well as anagenetic changes. 
Because of the large number of states in this analysis (15 possible ranges and one "other" category), more pre-plotting processing is necessary.
We pass the appropriate ancestral area names to`processAncStates()` and specify custom colors in a named vector.
To plot the ancestral states, we provide the processed data, specify that the data are "cladogenetic", add text labels to the tips specifying the character state, and modify sizes and horizontal positions for aesthetics.
We also modify the order at which states appear in the legend and the legend position.

```{R}
file <- simple.ase.tre"
labs <- c("1" = "K", "2" = "O", 
          "3" = "M",  "4" = "H", 
          "5" = "KO", "6" = "KM", 
          "7" = "OM", "8" = "KH", 
          "9" = "OH", "10" = "MH", 
          "11" = "KOM", "12" = "KOH", 
          "13" = "KMH", "14" = "OMH", 
          "15" = "KOMH")
dec_example <- processAncStatesDiscrete(file, 
										state_labels = labs)
ncol <- length(dec_example@state_labels)
colors <- colorRampPalette(colFun(12))(ncol)
names(colors) <- dec_example@state_labels
ordered_labels <- names(colors)[c(6,1,4,3,
								  9,5,2,7,
								  10,13,12,
								  14,11,8,15)]
plotAncStatesPie(t = dec_example,
          		 cladogenetic = TRUE, 
          		 tip_labels_states = TRUE,
          		 pie_colors = colors, 
          		 tip_labels_offset = .2, 
          		 tip_pie_nudge_x = -.15, 
          		 node_pie_size = 1.2, 
          		 tip_pie_size = 0.12, 
          		 tip_labels_states_offset = .05) +
      theme(legend.position = c(0.1, 0.75)) +
      scale_color_manual(values = c(colors, "grey"), 
                         breaks = ordered_labels)
```
![image](figures/ancStatesPie.png)

While these examples demonstrate cladogenetic change for `plotAncStatesPie()` only, `plotAncStatesMAP()` can also plot cladogenetic change, and `plotAncStatesPie()` can also plot the results of anagenetic models. 
These functionsprovide plotting tools for any discrete ancestral-state estimation including the results of chromosome count reconstructions (as in {% page_ref chromo %}) and discrete state-dependent speciation and extinction (SSE) models (as in {% page_ref sse/bisse %}, among others). 

Diversification Analysis
========================
{:.section} 

Episodic Diversification Analysis
---------------------------------
{:.subsection} 

State-Dependendent Diversification Analysis
-------------------------------------------
{:.subsection} 

Lineage-Specific Diversification Analysis
------------------------------------------
{:.subsection} 

Posterior-Predictive Analysis 
==============
{:.section} 
