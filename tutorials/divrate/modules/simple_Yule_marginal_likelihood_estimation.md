{% section Estimating the marginal likelihood of the model %}

With a fully specified model, we can set up the `powerPosterior()`
analysis to create a file of 'powers' and likelihoods from which we can
estimate the marginal likelihood using stepping-stone or path sampling.
This method computes a vector of powers from a beta distribution, then
executes an MCMC run for each power step while raising the likelihood to
that power. In this implementation, the vector of powers starts with 1,
sampling the likelihood close to the posterior and incrementally
sampling closer and closer to the prior as the power decreases. For more
information on marginal likelihood estimation please read the
[Bayesian Model Selection Tutorial]({{ base.url }}/tutorials/model_selection_bayes_factor/bf_intro)

First, we create the variable containing the power posterior. This
requires us to provide a model and vector of moves, as well as an output
file name. The `cats` argument sets the number of power steps.
```
pow_p = powerPosterior(mymodel, moves, monitors, "output/Yule_powp.out", cats=127, sampleFreq=10)
```
We can start the power posterior by first burning in the chain and and
discarding the first 10000 states.
```
pow_p.burnin(generations=10000,tuningInterval=200)
```
Now execute the run with the `.run()` function:
```
pow_p.run(generations=10000)
```
Once the power posteriors have been saved to file, create a
stepping-stone sampler. This function can read any file of power
posteriors and compute the marginal likelihood using stepping-stone
sampling.
```
ss = steppingStoneSampler(file="output/Yule_powp.out", powerColumnName="power", likelihoodColumnName="likelihood")
```
Compute the marginal likelihood under stepping-stone sampling using the
member function `marginal()` of the `ss` variable and record the value
in {% ref tab_ml_yule %}.
```
write("Stepping stone marginal likelihood:\t", ss.marginal() )
```
Path sampling is an alternative to stepping-stone sampling and also
takes the same power posteriors as input.
```
ps = pathSampler(file="output/Yule_powp.out", powerColumnName="power", likelihoodColumnName="likelihood")
```
Compute the marginal likelihood under stepping-stone sampling using the
member function `marginal()` of the `ps` variable and record the value
in {% ref tab_ml_yule %}.
```
write("Path-sampling marginal likelihood:\t", ps.marginal() )
```
&#8680; The `Rev` file for performing this analysis: `ml_Yule.Rev`.
