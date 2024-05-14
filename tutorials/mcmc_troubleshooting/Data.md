Data Quality Issues
========
{:.section}

While increasing the amount of data you use to generate a phylogenetic tree is generally a good thing, it can also make convergence more difficult. Increasing the amount of data increases the computational cost of estimating a phylogenetic tree, and therefore, can negatively impact inference performance. This is especially true in situations where the data are highly uncertain, have lots of missing data, or are in conflict with other sources of data. Below, we will examine a few common sources of MCMC difficulties that relate to data quality issues. 


Conflict 
========
{:.subsection}

Conflict occurs when multiple sources of data disagree with one another about the topology, branch lengths or other parameters. Examples of this can include if two genes favor different topologies, or if morphological data and molecular data favor different trees. It is advisable to run different data sources independently to assess if this issue is at play in your dataset. 


Sparsity 
========
{:.subsection}

In general, assembling more data leads to more precise and more accurate inferences. Previous research has shown that total-evidence studies require $\sim$300 morphological characters to obtain reliable estimates of tree topology and divergence times in extinct clades \citep{Barido-Sottani2020}. 

However, it is important to note that additional data is not necessarily better for the convergence of an MCMC inference. Adding more data comes with added computational costs, and thus can have a net-negative impact on the performance, especially if the added data is very uncertain or conflicts with the rest of the data or with the chosen models and priors. 
For instance, \citet{portik2023} built phylogenies using either a complete alignment of nuclear markers, a supersparse matrix of $\sim$300 genes with large amounts of missing data, or the combination of both. They found that trees obtained using the combined dataset did not significantly differ from the trees obtained using the complete alignment alone. One possible avenue for resolving convergence issues is thus to remove genes or partitions which contain low amounts of information. Software such as [genesortR](https://github.com/mongiardino/genesortR) can be used to choose subsets of genetic datasets that provide solid phylogenetic information, thus elimiinating the need to have complete datasets.

Similarly, while increasing taon sampling has been shown to be important for phylogenetic accuracy \citep{heath2008}, increasing the number of extant or fossil samples in the tree leads to an exponential increase in the number of possible topologies. This increases compute time and decreases efficiency. For size-related convergence issues, one may choose a subset of their taxa to include. Many methods assume assume extant taxa are sampled uniformly at random; but in many cases, they are sampled sparsely by keeping only one living representative per genus or subclade.
The diversified sampling scheme has been implemented in the FBD model \citep{Zhang2016} to accommodate such a case.


