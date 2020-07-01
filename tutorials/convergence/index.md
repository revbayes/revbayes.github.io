---
title: Convergence assessment
subtitle: Phylogenetic convergence assessment using R package Convenience
authors:  Luiza Fabreti, Sebastian Höhna and Tracy Heath
level: 1
prerequisites:
- intro
- mcmc
- ctmc
- fbd
index: true
redirect: false
---

{% section Overview %}

This tutorial covers convergence assessment of Bayesian phylogenetics analysis using the R package Convenience.
Convergence of MCMC analysis is crucial to assure that the chain had sampled from the stationary distribution. This is done by analyzing the output from the MCMC for lack of convergence, since analytical solutions are yet to be developed.
In the phylogenetics field the output to be analyzed consists of two types of parameters:
1. Continuous parameters: the evolutionary model parameters and the tree length;
2. Discrete parameters: the phylogenetic tree.

To assess convergence for these parameters, the Convenience package evaluates:
1. The Effective Sample Size (ESS);
2. Comparison between windows of the same run;
3. Comparison between different runs.

For the continuous parameters, the comparison is made with the Kolmogorov-Smirnov (KS) test, a non-parametric statistical test for equality of probability distributions. Two distributions will be equal when the KS value is below a given threshold.
The phylogenetic tree is evaluated regarding the bipartitions or splits. Therefore, the comparisons are made using the frequency of a given split between intervals of the same run or between different runs.

{% subsection Thresholds %}

The threshold for the ESS value is based on the precision of the mean of a normal distribution. If we set up the precision to be a percentage of the 95% interval of the distribution, we can calculate the ESS with:

$$ ESS > \frac{1}{(4 \times x)^2} $$

where x is the choosen precision. For x = 1%, the ESS threshold is 625. That is the default value for the convenience package.

For the KS test, the threshold is the critical value for $\alpha$ = 0.001.

The threshold for the split frequencies is the mean absolute difference between two variables drawn independently from the same binomial distribution.

$$ {E}[\Delta^{sf}_{p}] = \sum\limits_{i=0}^N \left(|\frac{i}{N} - p| \times P_{binom}(i|N,p) \right) $$


{% section Install %}

To install Convenience, we need first to install the package devtools.
In R, type the commands:

  > `install.packages("devtools")` <br />
  > `library(devtools)` <br />
  > `install_github("lfabreti/convenience")` <br />
  > `library(convenience)` <br />

{% section Example %}

First, download the files listed as data files on the top of this page. Save them in a folder called data.
These files are the output from a phylogenetic analysis performed with a datset from bears. The nucleotide substitution model was GTR+$\Gamma$+I and the MCMC was set to run 2 independent runs.
The function `checkConvergence` takes the output from a folder and performs the convergence assessment pipeline.
Let's run this function with our example output (this step may take a few minutes):

  > `check_bears <- checkConvergence("data/")` <br />

Now, let's see what is the output:

{% figure output_example.png %}
<img src="figures/output_example.png" /> 
{% figcaption %} 
The output stored in check_bears
{% endfigcaption %}
{% endfigure %}

We can see that `check_bears` has 4 elements: `message`, `converged`, `continuous_parameters` and `tree_parameters`.

1. `message`: a string with a message if the analysis has converged or not;
2. `converged`: a boolean that has TRUE if the analysis converged and FALSE if it did not converge;
3. `continuous_parameters`: a list with ESS, KS-scores between windows of the same run and KS-scores between runs;
4. `tree_parameters`: a list with ESS, split frequencies between windows of the same run and split frequencies between runs.

In case the analysis has failed to converge, another element will be on the output list: `failed` with the parameters that failed the criteria for convergence.

We can check `continuous_parameters`and `tree_parameters` with the commands:

  > `check_bears$continuous_parameters` <br />
  > `check_bears$tree_parameters` <br />

{% figure list_parameters.png %}
<img src="figures/list_parameters.png" /> 
{% figcaption %} 
The lists of what is stored in the `check_bears$continuous_parameters` and `check_bears$tree_parameters`
{% endfigcaption %}
{% endfigure %}

Both lists have 3 elements: ESS, comparison of windows and comparison of runs. Let's see each component:

1. Continuous parameters

  > `check_bears$continuous_parameters$ess` <br />
  > `check_bears$continuous_parameters$compare_windows` <br />
  > `check_bears$continuous_parameters$compare_runs` <br />

We can check values for ESS and KS-scores for all continuous parameters of our phylogenetic analysis.


2. Tree parameters
  
  > `check_bears$tree_parameters$ess` <br />
  > `check_bears$tree_parameters$compare_windows` <br />
  > `check_bears$tree_parameters$compare_runs` <br />

Here we can check ESS, mean split frequencies and difference of split frequencies for the splits sampled throughout our MCMC.

Now that we learned how to use the package and how to interpret the results, let's practice with some exercises.

{% subsection Exercise 1 %}

Check for convergence in the output generated in the `Nucleotide substitution models` tutorial.
