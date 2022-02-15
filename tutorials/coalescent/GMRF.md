---
title: Skyline Models with GMRF
subtitle: Estimating Demographic Histories with Skyline Models using a Gaussian Markov Random Field Prior
authors: Ronja Billenstein and Sebastian Höhna
level: 8 #may need adjustment
order: 0.3
prerequisites:
- coalescent
- coalescent/constant
- coalescent/skyline
index: false
include_all: false
include_files:
- data/horses_homochronous_sequences.fasta
- scripts/mcmc_homochronous_GMRF.Rev
---

{% section Overview %}
This tutorial describes how to run a Skyline Analysis with a Gaussian Markov Random Field (GMRF) prior in `RevBayes`.
This is a special case of a skyline plot.
The intervals are equally spaced and thus their start and end points are independent from the coalescent events.
Furthermore, each interval's population size has a prior based on the previous, more recent interval (remember that we start in the present and go backwards in time for coalescent processes).

{% section Inference Example %}

> ## For your info
> The entire process of the GMRF based estimation can be executed by using the **mcmc_homochronous_GMRF.Rev** script in the **scripts** folder.
> You can type the following command into `RevBayes`:
~~~
> source("scripts/mcmc_homochronous_GMRF.Rev")
~~~
We will walk you through the script in the following section.
{:.info}

We will mainly highlight the parts of the script that change compared to the [constant coalescent model]({{base.url}}/tutorials/coalescent/constant) and the [skyline model]({{base.url}}/tutorials/coalescent/skyline).

{% subsection Read the data %}
Read in the data as described in the first exercise.

{% subsection The GMRF Model %}
For the GMRF model, you need to decide on the number of intervals.
These are equally distributed in time.

~~~
NUM_INTERVALS = 10
~~~

You will also need to define the points of change in time.
Here, we define the maximal age to be $500000$ which should cover the whole tree.
Further backwards in time the population size is thought to be in equilibrium and to be equal to the population size of the most ancient interval.
The first interval (automatically) starts at $t = 0$, the other starting points depend on the number of intervals and the maximal age.

~~~
MAX_AGE = 500000

for (i in 1:(NUM_INTERVALS-1)) {

    changePoints[i] <- i * ((MAX_AGE)/NUM_INTERVALS)

}
~~~

For each interval, a population size will be estimated.
In this case, the most recent population size is treated differently to the other population sizes.
This is due to the fact that all other population size priors depend on the one more recent.

~~~
population_size_at_present ~ dnUniform(0,1E8)
population_size_at_present.setValue(100)

moves.append( mvScaleBactrian(population_size_at_present,weight=5) )
moves.append( mvMirrorMultiplier(population_size_at_present,weight=5) )
moves.append( mvRandomDive(population_size_at_present,weight=5) )
~~~

For the GMRF model implemented in `RevBayes`, you need to define a hyperprior for the global scale parameter which controls the overall variability of population sizes from present to past.
You can get the appropriate value for this hyperprior by using the `R` package `RevGadgets`.
Here, we ran the function `setMRFGlobalScaleHyperpriorNShifts(10, "GMRF")` to know the value of $0.1065$. <!--- **(why?)** --->

The prior for the global scale is a Half Cauchy Distribution.

~~~
population_size_global_scale_hyperprior <- 0.1065
population_size_global_scale ~ dnHalfCauchy(0,1)

moves.append( mvScaleBactrian(population_size_global_scale,weight=5.0) )
~~~

For each interval we define the prior for the delta log population size to be a Normal Distribution with the standard deviation dependent on the global scale and its hyperprior.

~~~
for (i in 1:(NUM_INTERVALS-1)) {
  # non-centralized parameterization of horseshoe
  delta_log_population_size[i] ~ dnNormal( mean=0, sd=population_size_global_scale*population_size_global_scale_hyperprior )
  # Make sure values initialize to something reasonable
  delta_log_population_size[i].setValue(runif(1,-0.1,0.1)[1])
  moves.append( mvSlideBactrian(delta_log_population_size[i], weight=5) )
}
~~~

Finally, the different population sizes need to be assembled.

~~~
population_size := fnassembleContinuousMRF(population_size_at_present,delta_log_population_size,initialValueIsLogScale=FALSE,order=1)
~~~

Here, a few extra moves are added.

~~~
# Move all field parameters in one go
moves.append( mvEllipticalSliceSamplingSimple(delta_log_population_size,weight=5,tune=FALSE) )
# joint sliding moves of all vector elements
moves.append( mvVectorSlide(delta_log_population_size, weight=10) )
# up-down slide of the entire vector and the rate at present
rates_up_down_move = mvUpDownScale(weight=10.0)
rates_up_down_move.addVariable(population_size_at_present,FALSE)
rates_up_down_move.addVariable(delta_log_population_size,TRUE)
moves.append( rates_up_down_move )
# shrink expand moves
moves.append( mvShrinkExpand( delta_log_population_size, sd=population_size_global_scale, weight=10 ) )
~~~

{% subsection The Tree %}

Now, we will instantiate the stochastic node for the tree.
Similar to the skyline exercise, we use the `dnCoalescentSkyline` distribution for the tree.
In the GMRF case, however, the method is not based on events, but has specified intervals.
~~~
psi ~ dnCoalescentSkyline(theta=population_size, times=changePoints, method="specified", taxa=taxa)
~~~

In order to be able to later plot and analyze the population size curve, we can retrieve the resulting interval times as for the skyline exercise.
Here, they should not change, so you might as well omit this line.

~~~
interval_times := psi.getIntervalAges()
~~~

Again, we constrain the root age as before and add the same moves for the tree.

{% subsection Substitution Model and other parameters %}
This part is also taken from the constant coalescent exercise.

{% subsection Finalize and run the analysis %}

In the end, we need to wrap our model as before.

Finally, we add the monitors and then run the MCMC.
Remember to change the file names to avoid overwriting your previous results.

~~~
monitors.append( mnModel(filename="output/horses_GMRF.log",printgen=THINNING) )
monitors.append( mnFile(filename="output/horses_GMRF.trees",psi,printgen=THINNING) )
monitors.append( mnFile(filename="output/horses_GMRF_NEs.log",population_size,printgen=THINNING) )
# monitors.append( mnFile(filename="output/horses_GMRF_times.log",interval_times,printgen=THINNING) )
monitors.append( mnScreen(population_size, root_age, printgen=100) )

mymcmc = mcmc(mymodel, monitors, moves)
mymcmc.burnin(NUM_MCMC_ITERATIONS*0.1,100)
mymcmc.run(NUM_MCMC_ITERATIONS, tuning = 100)
~~~


{% section Results %}

After running your analysis, you can plot the results using the `R` package `RevGadgets`.

~~~
library(RevGadgets)

burnin = 0.1
probs = c(0.025, 0.975)
summary = "median"

population_size_log = "../output/horses_GMRF_NEs.log"
interval_change_points_log = "../output/horses_GMRF_times.log"
df <- processPopSizes(population_size_log, interval_change_points_log, method = "specified", burnin = burnin, probs = probs, summary = summary)
p <- plotPopSizes(df, method = "specified") + ggplot2::coord_cartesian(ylim = c(1e3, 1e8))
ggplot2::ggsave("horses_GMRF.png", p)
~~~

<!--- In the example, we set the limits of the x-axis to the root age value from the next exercise (see below).
This was done to be able to easily compare the plots. --->

{% figure example_skyline %}
<img src="figures/horses_GMRF.png" width="800">
{% figcaption %}
This is how the resulting GMRF skyline plot should roughly look like.
{% endfigcaption %}
{% endfigure %}

{% section The Horseshoe Markov Random Field Prior %}
Related to the GMRF, there also is the Horseshoe Markov Random Field (HSMRF) prior.
It can be seen as a more generalized version of the GMRF with the change focusing on the definition of the standard deviation ({% cite Magee2020 %})
In the tutorial {% page_ref divrate/ebd %}, it is applied to the estimation of diversification rates.
Have a look at the **Specifying the model** section and try to change the respective lines in your current script to follow the HSMRF procedure.
Do your results look different?

{% aside Hint %}
The lines you should look at are lines 67 to 73 in the script.
There, you can change the way the standard deviation of the population sizes per interval is calculated.

~~~
for (i in 1:(NUM_INTERVALS-1)) {
  # Variable-scaled variances for hierarchical horseshoe
  sigma_population_size[i] ~ dnHalfCauchy(0,1)
  # Make sure values initialize to something reasonable
  sigma_population_size[i].setValue(runif(1,0.005,0.1)[1])
  # moves on the single sigma values
  moves.append( mvScaleBactrian(sigma_population_size[i], weight=5) )
  # non-centralized parameterization of horseshoe
  delta_log_population_size[i] ~ dnNormal( mean=0, sd=sigma_population_size[i]*population_size_global_scale*population_size_global_scale_hyperprior )
  # Make sure values initialize to something reasonable
  delta_log_population_size[i].setValue(runif(1,-0.1,0.1)[1])
  moves.append( mvSlideBactrian(delta_log_population_size[i], weight=5) )
}
~~~

Remember to change the hyperprior value (`setMRFGlobalScaleHyperpriorNShifts(10, "HSMRF")` in `RevGadgets`) and to add extra moves.

In case you prefer to download a whole HSMRF script to compare it to the GMRF script, have a look at [the HSMRF]({{base.url}}/tutorials/coalescent/HSMRF).

{% endaside %}

{% aside Reversible Jump MCMC %}

In RevBayes, there also is the possibility to estimate the number of intervals via reversible jump MCMC (rjMCMC).
In this approach, you don't specifically set the number of intervals before the analysis, but make it a parameter that is estimated as part of the analysis.
This functionality is implemented in the `dnMultiValueEvent` distribution.

For the `eventDistribution` parameter, a distribution on natural number has to be chosen.
In this example, we use a Poisson distribution with an expected value of $10$.
The `valueDistribution` is a vector of prior distributions for the population sizes and the interval times.
We also should call the variables by their names.
The `minNumberEvents` are $1$ population size and $0$ times corresponding to interval changes.
We expect to always have one more population size than change points.
~~~
events ~ dnMultiValueEvent (eventDistribution = dnPoisson(lambda=10),
                   valueDistribution=[dnUniform(1E4,1E8),
                                      dnUniform(0.0,MAX_AGE)],
                   names=["theta","time"],
                   minNumberEvents=[1,0])
~~~
Fo the `dnMultiValueEvent` distribution, we add specific moves.
~~~
# apply a move that adds and removes pairs of theta+time
moves.append( mvMultiValueEventBirthDeath(events, weight=50) )
# add a move that changes the theta variables
moves.append( mvMultiValueEventScale(events, name="theta", lambda=1.0, weight=10, tune=!FALSE) )
# add a move that changes the time variables
moves.append( mvMultiValueEventSlide(events, name="time", lambda=10.0, weight=10, tune=!FALSE) )
moves.append( mvMultiValueEventScale(events, name="time", lambda=0.5, weight=10, tune=!FALSE) )
~~~
Finally, we need to track the different parameters by assigning them to variables.
~~~
n_events := events.getNumberOfEvents()
population_size := events.getRealPosValues(name="theta")
changePoints := events.getRealPosValues(name="time")
~~~
In the end, all the parameters can be put into the `dnCoalescentSkyline` distribution.
~~~
psi ~ dnCoalescentSkyline(theta=population_size, times=changePoints, method="specified", taxa=taxa)
~~~

You can have a look at the results [here]({{base.url}}/tutorials/coalescent/CPP)

{% endaside %}

{% section Next Exercise %}
When you are done, have a look at the next exercise.

* [The GMRF model with trees as input data]({{base.url}}/tutorials/coalescent/GMRF_treebased)