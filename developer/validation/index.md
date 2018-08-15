---
title: Setting up Validation Scripts in RevBayes
subtitle: Ensuring correct performance of models and methods using simulations
category: Developer
code_layout: Rev
---

{% section Introduction | introduction %}

We use simulated datasets to validate that our models and methods are performing correctly.
In RevBayes, we have a specific way of doing this and the scripts for validation are contained
in the [public repository](https://github.com/revbayes/revbayes). This way if you implement a new 
move, distribution, function, etc., you can be certain that models and methods developed by other
members of the project are not affected and that your new method works.

{% section Creating and Executing a Validation Script | validation %}

{% subsection Directory Structure | dirstruct %}

In the RevBayes GitHub repository, the validation scripts are all located within the folder
called [`validation`](https://github.com/revbayes/revbayes/tree/master/validation).
In this directory there are two subdirectories: 

1. `scripts`: containing the Rev scripts defining different models and analyses 
that use the RevBayes validation functions to evaluate the coverage of relevant parameters.
2. `data`: containing the data files used to determine the dimensions of the simulations for some 
of the validation analyses (*e.g.*, taxon names, number of taxa, alignment length). Data files
are not necessary for validation of all models.

<!-- {% subsection Best Practices for Writing a Validation Script | bestprac %}

There are a set of standard best practices for writing a validation script to ensure that 
your methods are correct and work with all of the other approaches developed by other members
of the RevBayes team.

1. Please write your  -->


{% subsection Writing a Validation Script for the Normal Distribution | norma %}

We can write a simple validation script that checks the performance of the [normal distribution](https://github.com/revbayes/revbayes/blob/master/validation/scripts/Validation_normal.Rev). 
This script will check the coverage probabilities of estimators for parameters of the normal distribution.
The model we will use is shown in {% ref fig_mod_gm %}.

{% figure fig_mod_gm %}
<img src="figures/model_gm.png" width="300" /> 
{% figcaption %} 
A graphical model of a normally distributed parameter with prior distributions on the parameters of the 
normal distribution.
{% endfigcaption %}
{% endfigure %}

The outcome of this validation will allow us to determine if the following things are 
behaving correctly in RevBayes:

* the functions for drawing random variates under the uniform, exponential, and normal distributions
* the calculation of the probability densities under each distribution
* the scale and slide moves
* and all of the machinery that puts these components together.

The validation methods in RevBayes will take a model and set of moves, simulate true values for stochastic nodes
and an observed data, 
estimate the values for the stochastic nodes conditioned on the simulated data, 
and compare whether the true values fall within a given credible
interval (the default value is 90%) for each stochastic random variable. 
This routine is performed for many simulation replicates 
(set in the validation script) and the coverage probability across replicates is summarized and 
reported to the screen.

The complete validation script for the Normal distribution can be found in the RevBayes GitHub
repository: 
[`Validation_normal.Rev`](https://github.com/revbayes/revbayes/blob/master/validation/scripts/Validation_normal.Rev).
If you view this script, you will see that it begins with a header in comments that provide details about the script:

1. `# RevBayes Validation Test: Normal Distribution` -- the name of the validation test.
2. `# Model: Just a single random variable from a normal distribution.` -- a brief description of what the validation script is testing.
3. `authors: Sebastian Hoehna` -- the author of the script and the person you should contact if you implement any new functionality in RevBayes that break their validation test. 

{% subsubsection Specify the model | model %}

The first part of the script specifies the model DAG (*i.e.*, random variables and conditional dependency) and its dimensions (*i.e.* the number of samples).

```
n_samples = 10

mi = 0

mu ~ dnUniform( -10, 10 )
sigma ~ dnExponential( 1.0 )

moves[ ++mi ] = mvSlide( mu )
moves[ ++mi ] = mvScale( sigma )

for (i in 1:n_samples ) {
   x[i] ~ dnNormal(mu,sigma)
   x[i].clamp( 0.0 )
}
```

Note that in this script, the data node is clamped: `x[i].clamp( 0.0 )`. This is particularly necessary since 
the validation methods will change the clamped value to the simulated data value for each simulation replicate.
It also doesn't hurt to clamp the nodes in this case if you prefer to do so.

Once the model DAG is set up, you can create a model workspace variable:

```
mymodel = model(mu)
```

{% subsubsection Specify the MCMC object | MCMC %}

Before using the validation functions, you need to first have an MCMC workspace variable. Because the `mcmc()`
function requires a list of monitors, we must then create at least 1 monitor to satisfy the required arguments
of that function. Ultimately, the validation functions will not actually use this monitor because a new ones
will be created for each simulation replicate.

```
monitors[1] = mnModel(filename="output/normal_test.log",printgen=10, separator = TAB)
```

The MCMC object is initialized just like in any normal MCMC analysis.

```
mymcmc = mcmc(mymodel, monitors, moves)
```

{% subsubsection Specify the validation analysis | valid %}

The first step in specifying the validation analysis is to create a workspace object using 
the `validationAnalysis()` function. This function takes 2 argments: (1) and MCMC object and (2) the number of
simulation replicates you want it to perform. 

```
validation = validationAnalysis( mymcmc, 1000 )
```

For this validation, note that we chose 1000 replicates. For very large numbers of replicates, you will have a 
better approximation of the coverage probability. However, there is a substantial trade-off when it comes to 
run-times. Some of the validation scripts can take quite a long time to run. Importantly, this can be alleviated
if you compile the MPI version of RevBayes, which will run the individual replicates in parallel. 

Next, you can specify a burn-in period, which will run the MCMC for each replicate for a specified number
of MCMC cycles, while re-tuning the moves.

```
validation.burnin(generations=10000,tuningInterval=1000)
```

Now you can run the validation MCMC. (As previously mentioned, it is best to compile the MPI version of RevBayes.)
The number of generations should be chosen at your discretion, but this should be a sufficient number of samples
so that you can ensure your MCMC has effectively sampled the target distribution.

```
validation.run(generations=30000)
```

{% subsubsection Validation summary | summarize %}

Once the validation run is complete, you can use the `.summarize()` method of the validation object.


```
validation.summarize()
```

```
Summarizing analysis ...

The validation analysis ran 1000 simulations to validate the implementation.
This analysis used a 0.9 credible interval.
Coverage frequencies should be between 0.881 and 0.918 in 95% of the simulations.

Coverage frequencies of parameters in validation analysis:
==========================================================
mu                  		0.917
sigma               		0.882
```
{:.Rev-output}

At this point, you should conduct a visual inspection of the coverage frequencies for the parameters of your model. 
Do the coverage frequencies fall withing the interval calculated by the validation analysis to a reasonable degree? 
In the example output above, the interval is 0.881 to 0.918. 

