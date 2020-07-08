---
title: Convergence assessment
subtitle: Phylogenetic convergence assessment using R package Convenience
authors:  Luiza Fabreti and Sebastian Höhna
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

Convergence of MCMC analysis is crucial to assure that the chain had sampled from the stationary distribution. That is, the MCMC has explored the parameter space long enough to reach the true distribution of the parameter and the values we are sampling belong to that distribution. Theory says that a chain that runs through an infinite time, will reach convergence. For our practical problem, we need to make a decision of when we have sampled enough to take a good estimate of the desired parameters.

An ideal solution would be to analytically calculate the number of steps needed to reach convergence. The problem is that this involves sophisticated mathematics that are very specific for the model taken to the MCMC, moreover, the methods developed so far led to impractical number of iterations.

Since we lack a theoretical convergence assessment, what is broadly done in the MCMC field is analyze the output from the MCMC for lack of convergence. 
To do so, we have to keep in mind two aspects of an analysis that has reached convergence: precision and reproducibility. Precision means that if we run the chain longer, we do not change the estimates. While reproducibility means that if we run another independent chain, we get the same estimates.
Precision can be evaluated by comparing parts of the chain for similarity. Reproducibility, on the other hand, by comparing independent chains run under the same model. Therefore, it's recommended to run at least two replicates when performing MCMC.

Another best practice is to remove the initial samples from the chain, those initial iterations are called burn-in. By that we try to get rid of the samples that are not being taken from the stationary distribution. 

One last concept we need to keep in mind is the Effective Sample Size (ESS), the number of independent samples in our chain. The ESS takes into account the correlation between samples within a chain. Low ESS values represent high autocorrelation in the chain. The higher the autocorrelation, higher the uncertainty in our estimates.

{% section Criteria for Convergence %}

Now that we learned about convergence, let's take a look into the criteria in the Convenience package:

In the phylogenetics field the output to be analyzed consists of two types of parameters:

1. Continuous parameters: the evolutionary model parameters and the tree length;
2. Discrete parameters: the phylogenetic tree.

To assess convergence for these parameters, the Convenience package evaluates:

1. The Effective Sample Size (ESS);
2. Comparison between windows of the same run;
3. Comparison between different runs.

The comparison between windows of the same run works by dividing the full length of the run into 5 windows (subsets) and comparing the third and fifth window. In the following figure we can see a trace plot for the tree length from the example provided in this tutorial. The trace plot shows the sampled values over the iterations of the MCMC. The highlighted areas of the figure show the third and fifth window of the run.

{% figure windows %}
<img src="figures/windows.png" /> 
{% figcaption %} 
Trace plot of the tree length for our example analysis. The shaded areas show the third and fifth windows of the run.
{% endfigcaption %}
{% endfigure %}

{% subsection How do we compare windows and runs? %}

For the continuous parameters, the comparison is made with the two-sample Kolmogorov-Smirnov (KS) test, a non-parametric statistical test for equality of probability distributions. Two samples will be equal when the KS value is below a given threshold. The KS value (D) is calculated:

$$ {D}_{m,n} = \max_{x} |{F_{1,m}(x) - G_{2,n}(x)}| $$

F(x) and G(x) are the empirical distribution functions for the first and second sample, respectively.
The two samples will be drawn from different distributions, at level $\alpha$, when:

$$ {D}_{m,n} > c(\alpha) \sqrt{\frac{m + n}{m\times n}} $$

with

$$ c(\alpha) = \sqrt{-\ln({\frac{\alpha}{2})\times \frac{1}{2}}} $$

The phylogenetic tree is evaluated regarding the bipartitions or splits. Therefore, the comparisons are made using the frequency of a given split between intervals of the same run or between different runs.

{% figure splits %}
<img src="figures/splits.png" /> 
{% figcaption %} 
Two example trees with tips A, B, C, D and the splits seen at each tree.
{% endfigcaption %}
{% endfigure %}

{% subsection Thresholds %}

The current state of convergence assessment in Bayesian phylogenetics relies mainly on visual tools and ESS thresholds that have no clear theory to support them. The idea behind the Convenience package is to provide a less subjective framework with clear thresholds for each convergence criterion.

We calculated a minimum value for the ESS based on a normal distribution and the standard error of the mean (SEM).
If we set up the SEM to be smaller than 1% of the 95% interval of the distribution, we can calculate the ESS with:

$$ SEM = \frac{\sigma}{\sqrt{ESS}} $$

$$ \frac{\sigma}{\sqrt{ESS}} < 1\% \times 4 \times \sigma $$

$$ ESS > \frac{1}{0.04^2} $$

$$ ESS > 625 $$

That is the default value for the convenience package.

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

First, download the files listed as data files on the top left of this page. Save them in a folder called data.
These files are the output from a phylogenetic analysis performed with a dataset from bears. The nucleotide substitution model was GTR+$\Gamma$+I and the MCMC was set to run 2 independent runs.
The package also works if your analysis has only one run of the MCMC. But the part to compare runs will not be evaluated. Therefore, it is not possible to say that your MCMC result is reproducible. We strongly advise on running more than 1 run.

The function `checkConvergence` takes the output from a phylogenetic analysis performed on RevBayes and works through the convergence assessment pipeline.
This function can take either a directory with all the output files from a single analysis or a list of files.

The function has 3 arguments: 
1. `path`: for when a path to a directory is provided
2. `list_files`: for when a list of files is provided
3. `control`: a function to set the burnin size, the precision of the standard error of the mean and the continuous parameters to exclude from the assessment. Default values are burnin = 10%, precision = 1%, namesToExclude = "br_lens, bl, Iteration, Likelihood, Posterior, Prior".

Let's run this function with our example output in a directory(this step may take a few minutes):

  > `check_bears <- checkConvergence("data/")` <br />

We can also list the names of the files:

  > `check_bears <- checkConvergence( list_files = c("bears_cytb_GTR_run_1.log", "bears_cytb_GTR_run_1.trees", "bears_cytb_GTR_run_2.log", "bears_cytb_GTR_run_2.trees") )` <br />

Now, let's see what is the output:

{% figure output_example %}
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

{% figure list_parameters %}
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
2. Tree parameters
  > `check_bears$tree_parameters$ess` <br />
  > `check_bears$tree_parameters$compare_windows` <br />
  > `check_bears$tree_parameters$compare_runs` <br />

Each of these elements can be accessed to check all the values calculated in the package.

Now that we learned how to use the package and how to interpret the results, let's practice with some exercises.

{% subsection Exercise 1 %}

Check for convergence in the output generated in the [Nucleotide Substitution Models]({{ base.url }}/tutorials/ctmc/) tutorial.

Which analysis have converged?

{% subsection Convergence failure %}

You can see that the output is different when we have a failure in convergence. We have 2 extra elements `failed` and `failed_names`.
The element `failed` has a summary text of what failed in our analysis. 
The element `failed_names` has the specifics about the parameters that failed, like the name of the parameter or the split and if it failed in checking for the ESS, the comparison between windows or between runs. 

{% ref failed %} shows the results from the convergence assessment on the analysis from Exercise 1 with the GTR+$\Gamma$+I nucleotide substitution model.

{% figure failed %}
<img src="figures/failed.png" /> 
{% figcaption %} 
The output of a convergence assessment that has failed. On the left, we see the output with 6 elements. On the right, it's the summary of the parameters that failed.
{% endfigcaption %}
{% endfigure %}

{% subsection Exercise 2 %}

- Rerun the MCMC with the GTR+$\Gamma$+I model from [Nucleotide Substitution Models]({{ base.url }}/tutorials/ctmc/), but increase the number of iterations to 50000.
- Check the new results for convergence.

{% subsection What to do %}

{% table what_to_do %}
{% tabcaption %}
What to do in case of failure of convergence for each criteria
{% endtabcaption %}

 |	            **Criterion**           	|	               **What we can try**              	|
  	:-----------------------------------	|	:----------------------------------------------:	|
 |	            Combination of criteria 	|	                Get more samples                	|
 |	                ESS                 	|	                Get more samples                	|
 |	    Comparison between windows      	|	                  Increase burn-in      	        |
 |	     Comparison between runs        	| 	               Add more weight to the moves    		|


{% endtable %}
