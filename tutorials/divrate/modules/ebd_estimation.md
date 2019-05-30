{% section Estimating Episodic Diversification Rates %}

{% subsection Read the tree %}

Begin by reading in the ``observed'' tree.
```
T <- readTrees("data/primates_tree.nex")[1]
```
From this tree, we get some helpful variables, such as the taxon information which we need to instantiate the birth-death process.
```
taxa <- T.taxa()
```
Additionally, we initialize a variable for our vector of moves and monitors.
```
moves    = VectorMoves()
monitors = VectorMonitors()
```

Finally, we create a helper variable that specifies the number of intervals.
```
NUM_INTERVALS = 10
```
Using this variable we can easily change our script to break-up time into many (e.g., `NUM_INTERVALS = 100`) or few (e.g., `NUM_INTERVALS = 4`) intervals.



{% subsection Specifying the model %}

{% subsubsection Priors on amount of rate variation %}
We start by specifying prior distributions on the rates.
Each interval-specific speciation and extinction rate will be drawn from a normal distribution.
Thus, we need a parameter for the standard deviation of those normal distributions.
We use an exponential hyperprior with rate `SD = 0.587405 / NUM_INTERVALS` to estimate the standard deviation, but assume that all speciation rates and all extinction rates share the same standard deviation.
The motivation for an exponential hyperprior is that it has the highest probability density at 0 which would make the variance of rates between consecutive time intervals 0 and thus represent a constant rate process.
The data will tell us if there should be much variation in rates through time.
(You may want to experiment with this hyperprior if you are interested.)
```
SD = abs(0.587405 / NUM_INTERVALS)

speciation_sd ~ dnExponential( 1.0 / SD)
extinction_sd ~ dnExponential( 1.0 / SD)
```
We apply a simple scaling move on each prior parameter.
```
moves.append( mvScale(speciation_sd,weight=5.0) )
moves.append( mvScale(extinction_sd,weight=5.0) )
```



{% subsubsection Specifying episodic rates %}
As we mentioned before, we will apply normal distributions as priors for each log-transformed rate.
We begin with the rate at the present which is our initial rate parameter.
The rates at the present will be specified slightly differently
because they are not correlated to any previous rates.
This is because we are actually modeling rate-changes backwards in time and
there is no previous rate for the rate at the present.
Modeling rates backwards in time makes it easier for us if we had some prior information
about some event affected diversification sometime before the present,
*e.g.,* 25 million years ago.

We use a uniform distribution between -10 and 10 because of our lack of prior knowledge
on the diversification rate.
This actually means that we allow speciation and extinction rates
between $e^{-10}$ and $e^10$, so we should clearly cover the true values.
(Note that for diversification rate estimates, $e^{-10}$ is virtually 0
since the rate is so slow).
```
log_speciation[1] ~ dnUniform(-10.0,10.0)
log_speciation[1].setValue(0.0)
log_extinction[1] ~ dnUniform(-10.0,10.0)
log_extinction[1].setValue(-1.0)
```
Notice that we store the diversification rate variables in vectors.
Storing the rate parameters in vectors will be useful and important later when we pass the rates into the birth-death process.

We apply simple sliding window moves for the rates.
Normally we would use scaling moves but in this case we work on the log-transformed parameters and thus sliding moves perform better.
(If you are keen you can test the differences.)
```
moves.append( mvSlide(log_speciation[1], weight=2) )
moves.append( mvSlide(log_extinction[1], weight=2) )
```
Now we transform the diversification rate parameters into actual rates using
an exponential parameter transformation.
```
speciation[1] := exp( log_speciation[1] )
extinction[1] := exp( log_extinction[1] )
```

Next, we specify the speciation and extinction rates for each time interval (*i.e.,* epoch).
This can be done efficiently using a `for-loop`.
We will use a specific index variable so that we can more easily refer to the rate at the previous interval.
Remember that we want to model the rates as a Brownian motion, which we achieve by specifying a normal distribution as the prior distribution on the rates centered around the previous rate (\IE the mean of the normal distribution is equal to the previous rate).
```
for (i in 1:NUM_INTERVALS) {
    index = i+1

    log_speciation[index] ~ dnNormal( mean=log_speciation[i], sd=speciation_sd )
    log_extinction[index] ~ dnNormal( mean=log_extinction[i], sd=extinction_sd )

    moves.append( mvSlide(log_speciation[index], weight=2) )
    moves.append( mvSlide(log_extinction[index], weight=2) )

    speciation[index] := exp( log_speciation[index] )
    extinction[index] := exp( log_extinction[index] )

}
```
Finally, we apply moves that slide all values in the rate vectors,
*i.e.,* all speciation or extinction rates.
We will use an `mvVectorSlide` move.
```
moves.append( mvVectorSlide(log_speciation, weight=10) )
moves.append( mvVectorSlide(log_extinction, weight=10) )
```

Additionally, we apply a `mvShrinkExpand` move which changes the spread of several variables
around their mean.
```
moves.append( mvShrinkExpand( log_speciation, sd=speciation_sd, weight=10 ) )
moves.append( mvShrinkExpand( log_extinction, sd=extinction_sd, weight=10 ) )
```
Both moves considerably improve the efficiency of our MCMC analysis.

{% subsubsection Setting up the time intervals %}
In `RevBayes` you actually have the possibility to specify unequal time intervals
or even different intervals for the speciation and extinction rate.
This is achieved by providing a vector of times when each interval ends.
Here we simply break-up the time in equal-length intervals.
```
interval_times <- T.rootAge() * (1:NUM_INTERVALS) / NUM_INTERVALS
```
This vector of times will be used for both the speciation and extinction rates.
Also, remember that the times of the intervals represent ages going backwards in time.

{% subsubsection Incomplete Taxon Sampling %}

We know that we have sampled 233 out of 367 living primate species.
To account for this we can set the sampling parameter as a constant node with a value of 233/367.
For simplicity, and since almost all species have been sampled,
we assume *uniform* taxon sampling {%cite Hoehna2011 Hoehna2014a %},
```
rho <- T.ntips()/367
```


{% subsubsection Root age %}

The birth-death process requires a parameter for the root age.
In this exercise we use a fixed tree and thus we know the age of the tree.
Hence, we can get the value for the root from the {% citet MagnusonFord2012 %} tree.
```
root_time <- T.rootAge()
```

{% subsubsection The time tree %}

Now we have all of the parameters we need to specify the full episodic birth-death model.
We initialize the stochastic node representing the time tree.
```
timetree ~ dnEpisodicBirthDeath(rootAge=T.rootAge(), lambdaRates=speciation, lambdaTimes=interval_times, muRates=extinction, muTimes=interval_times, rho=rho, samplingStrategy="uniform", condition="survival", taxa=taxa)
```
You may notice that we explicitly specify that we want to condition on survival.
It is possible to change this condition to the *time of the process* or
*the number of sampled taxa* too.

Then we attach data to the `timetree` variable.
```
timetree.clamp(T)
```

Finally, we create a workspace object of our whole model using the `model()` function.
```
mymodel = model(speciation)
```

The `model()` function traversed all of the connections and found all of the nodes we specified.


{% subsection Running an MCMC analysis %}

{% subsubsection Specifying Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to record the states of our Markov chain.
First, we will initialize the model monitor using the `mnModel` function.
This creates a new monitor variable that will output the states for all model parameters
when passed into a MCMC function.
```
monitors.append( mnModel(filename="output/primates_EBD.log",printgen=10, separator = TAB) )
```

Additionally, we create four separate file monitors, one for each vector of speciation and extinction rates and for each speciation and extinction rate epoch (\IE the times when the interval ends).
We want to have the speciation and extinction rates stored separately so that we can plot them nicely afterwards.
```
monitors.append( mnFile(filename="output/primates_EBD_speciation_rates.log",printgen=10, separator = TAB, speciation) )
monitors.append( mnFile(filename="output/primates_EBD_speciation_times.log",printgen=10, separator = TAB, interval_times) )
monitors.append( mnFile(filename="output/primates_EBD_extinction_rates.log",printgen=10, separator = TAB, extinction) )
monitors.append( mnFile(filename="output/primates_EBD_extinction_times.log",printgen=10, separator = TAB, interval_times) )
```

Finally, we create a screen monitor that will report the states of specified variables
to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=1000, extinction_sd, speciation_sd) )
```

{% subsubsection Initializing and Running the MCMC Simulation %}

With a fully specified model, a set of monitors, and a set of moves,
we can now set up the MCMC algorithm that will sample parameter values in proportion
to their posterior probability.
The `mcmc()` function will create our MCMC object:
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=2, combine="mixed")
```

Now, run the MCMC:
```
mymcmc.run(generations=50000, tuningInterval=200)
```

When the analysis is complete, you will have the monitored files in your output directory.
You can then visualize the rates through time using `R` using our package `RevGadgets`.
If you don't have the R-package `RevGadgets` installed, or if you have trouble with the package, then please read the separate tutorial about the package.

Just start `R` in the main directory for this analysis and then type the following commands:
```R
library(RevGadgets)

tree <- read.nexus("data/primates_tree.nex")

rev_out <- rev.process.div.rates(speciation_times_file = "output/primates_EBD_speciation_times.log", speciation_rates_file = "output/primates_EBD_speciation_rates.log", extinction_times_file = "output/primates_EBD_extinction_times.log", extinction_rates_file = "output/primates_EBD_extinction_rates.log", tree=tree, burnin=0.25,numIntervals=100)

pdf("EBD.pdf")
par(mfrow=c(2,2))
rev.plot.div.rates(rev_out,use.geoscale=FALSE)
dev.off()
```

(Note, you may want to add a nice geological timescale to the plot by setting `use.geoscale=TRUE` but then you can only plot one figure per page.)

&#8680; The `Rev` file for performing this analysis: `mcmc_EBD.Rev`


{% figure fig_EBD_Results %}
<img src="figures/EBD_10_Result.png" width="75%" height="75%" />
{% figcaption %}
Resulting diversification rate estimations when using 10 intervals.
You should obtain similar results when you use 10 intervals.
The estimated rates might change when you use a different resolution, *i.e.,* a different number of intervals.
{% endfigcaption %}
{% endfigure %}
