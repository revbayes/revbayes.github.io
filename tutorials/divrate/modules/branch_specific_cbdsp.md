{% section Estimating Branch-Specific Diversification Rates under the Conditional-Birth-Death-Shift Process %}

In this exercise we are interested in estimating branch-specific diversification rates. 
To this end, we will assume that the speciation and extinction rates are drawn from a 
lognormal distribution. Note that the rates are drawn from the full continuous distribution.
As we mentioned above in Section {% ref birth_death_shift_model %} it is not possible to compute the likelihood
under this model *if* we allow the diversification rates to be drawn from a continuous distribution
*and* allow diversification rates to shift at extinct lineages.


{% subsection The Conditional-Birth-Death-Shift Process %}

Currently, there is no known probability density function under the birth-death-shift process.
The complication: One cannot calculate the probability of an 
extinct lineage that may have experienced any number of 
rate-shift events to an infinite number of possible new diversification rates {% cite Moore2016 %}.
One possible solution is to assume that rate-shift events do not occur on lineages destined to become extinct.
Then, under the assumption of no rate-shift events occurring on extinct lineages, we have observed all rate-shift events.
This enables us to derive the probability density of an augmented phylogeny under the conditional birth-death-shift process.

First, we break the phylogeny into segments where a segment is defined as a lineage between two consecutive events, either a speciation event or a rate-shift event in the reconstructed phylogeny.
Thus, within a segment there are no rate shifts and the process itself is a constant-rate birth-death process.
During the duration of segment $i$ we have the speciation rate $\lambda_i$ and extinction rate $\mu_i$.
As before, we define the change in the probability over the interval $\Delta t$ as

$$
D_i(t+\Delta t) = \underbrace{(1-\mu_i \Delta t)}_i \times
\underbrace{(1-\eta \Delta t)}_{ii}
\Big[ \underbrace{D_i(t)(1-\lambda_i \Delta t)}_{iii} + 
\underbrace{D_i(t) \lambda_i \Delta t \,2 \,P_0(t|\lambda_i,\mu_i)}_{iv} \Big] 
$$

which accounts for the various events that could occur in the interval, $\Delta t$. 
Specifically, the process does not (*i*) go extinct 
 or (*ii*) experience a rate shift in the interval $\Delta t$ and 
(*iii*) does not speciate, or 
(*iv*) there is a speciation event in the interval but one of the two lineages goes extinct before the present, which occurs with probability $P_0(t|\lambda_i,\mu_i)$ (which assumes that the the extinct lineage continues to diversify with rates $\lambda_i$ and $\mu_i$, with no further possibility of a rate shift occurring). 
Note that  we omit the scenario in which the process goes extinct because we know from our previous elaboration that this scenario has a probability of 0 and thus vanishes from the equation.
Eliminating terms of order $\Delta t^2$ and restructuring the equation, we get

$$
D_i(t+\Delta t) = D_i(t) - D_i(t) (\lambda_i+\mu_i+\eta) \Delta t + D_i(t)\lambda \Delta t \, 2 \, P_0(t|\lambda_i,\mu_i)
$$

Subtracting $D_i(t)$ from $D_i(t+\Delta t)$ and dividing by $\Delta t$ leads to the differential equation

$$
{d D_i \over dt} = -D_i(t)(\lambda_i+\mu_i+\eta) + 2 D_i(t) \lambda P_0(t|\lambda_i,\mu_i)
$$

Initializing $D(t=0)=1$ and using a differential equation solver, we obtain

$$\begin{aligned}
	D(t) & = & {(\lambda - \mu)^2  e^{-(\lambda-\mu)t} \over (\lambda - \mu  e^{-(\lambda-\mu)t})^2} \times \exp(-\eta t)  \nonumber\\
	& = & P_1(t) \times \exp(-\eta t) \label{eq:segment_prob}
\end{aligned}$$

In words, the probability of a lineage segment under the conditional birth-death-shift process can be computed as the probability of a lineage under the constant-rate birth-death process, $P_1(t)$, multiplied with the probability that there was no rate-shift event, $\exp(-\eta t)$.
This equation can readily be applied for terminal segments/branches.
For internal segments/branches that start at time $t_s$ in the past and end at time $t_e$, with $t_s > t_e$, we need to initialize $D(t=t_e)$ appropriately, which is done by dividing $D(t_e)$. 
This yields the probability of an internal segment/branch as

$$\begin{aligned}
	D(t_o,t_y) & = & P_1(t_o) \div P_1(t_y) \times \exp(-\eta(t_o - t_y)) \nonumber\\
	& = & {(\lambda - \mu)^2  e^{-(\lambda-\mu)t_o} \over (\lambda - \mu  e^{-(\lambda-\mu)t_o})^2} \div {(\lambda - \mu)^2  e^{-(\lambda-\mu)t_y} \over (\lambda - \mu  e^{-(\lambda-\mu)t_y})^2} \times \exp(-\eta(t_o - t_y))
\end{aligned}$$

Finally, we compute the probability density of a reconstructed phylogeny augmented with rate-shift events.
Again, let $N$ be the number of observed/sampled species and let $K$ be the number of rate-shift events. 
Then, we obtain the probability density as

$$
\label{eq:cond_birth_death_shift_process}
f(\Psi) \quad = \quad \frac{2^{N-1}}{(N-1)!} \, \times \, \lambda^{N-2} \, \times \, \eta^{K} \, \times \, { [P_1(t_1)]^2  \over (1-P_0(t_1))^2 } \, \times \, \prod_{i=2}^{N+K-1} \, D(t_{b(i)},t_{e(i)})
$$

This equation constitutes an analytical solution for a birth-death process where diversification rates vary along lineages.


{% figure fig_rejfreq %}
<img src="figures/rejection_freq.png" width="800" /> 
{% figcaption %}
The fraction of the time simulations are rejected under the birth-death-shift process 
because a shift event occurred along an extinct lineage. 
$f_{\lambda}(\cdot)$ and $f_{\mu}(\cdot)$ were both gamma-distributed random variables 
with a coefficient of variation of 0.1.
{% endfigcaption %}
{% endfigure %}

This is a very strong and possibly problematic assumption. 
For example, we explored by means of simulations how many realizations under the birth-death-shift process will be rejected
because of the condition that no rate-shift are allowed to occur on extinct lineages.
Trivially, no simulations will be rejected if the shift rate ($\eta$) is equal to zero. 
Of course, if $\eta = 0$, the process is equivalent to the simple birth-death process. 
Another trivial situation is when the model allows for no opportunity for extinction. 
A pure-birth model is more interesting because the likelihood could be calculated and the model allows for changes in diversification rates. 
The non-trivial situations cannot be fully described. 
In Figure {% ref fig_rejfreq %}, we explored a limited range of parameter values to examine the frequency with which simulation replicates would be rejected. 
In these simulations, we assume that new speciation and extinction rates are independently drawn from gamma distributions parameterized such that the coefficient of variation is 0.1. 
The bottom line: shift events occur along lineages that are destined to become extinct frequently enough, especially in biologically realistic situation when the relative extinction rate $\frac{\mu}{\lambda}$ is high, 
to render the conditional birth-death-shift model particularly problematic as a process model.
We therefore recommend to compare results to our alternative implementation: the finite-rate-category birth-death-shift process.

{% subsection Setting up the analysis in RevBayes %}


{% subsubsection Read the tree %}

Begin by reading in the observed tree.
```
observed_phylogeny <- readTrees("data/primates_tree.nex")[1]
```
From this tree, we can get some helpful variables:
```
taxa <- observed_phylogeny.taxa()
root <- observed_phylogeny.rootAge()
tree_length <- observed_phylogeny.treeLength()
```
We will also create a workspace variable called `moves` and `monitors`. 
This variable is a vector containing all of the MCMC moves and monitors respectively.
```
moves    = VectorMoves()
monitors = VectorMonitors()
```
Finally, we create a helper variable that specifies the number of
discrete rate categories, another helper variable for the expected
number of rate-shift events, the total number of species, and the
variation in rates.
```
EXPECTED_NUM_EVENTS = 2
NUM_TOTAL_SPECIES = 367
H = 0.587405
```
Using these variables we can easily change our script, for example, to
use more or fewer categories and test the impact. For example, setting
`NUM_RATE_CATEGORIES = 1` gives the constant rate birth-death process.

{% subsection Specifying the model %}

{% subsubsection Priors on rates %}

We will assume that speciation and extinction rates are drawn from a lognormal distribution.
Thus, we need to specify a prior mean and standard deviation for this lognormal distribution.
For the mean parameter we will simply use the expected diversification rate:
```
speciation_prior_mean <- ln( ln(NUM_TOTAL_SPECIES/2.0) / root )
extinction_prior_mean <- ln( ln(NUM_TOTAL_SPECIES/2.0) / root )
```
Additionally, we choose a fixed standard deviation of $2*H$
($0.587405*2$) for the speciation rates because it represents two orders
of magnitude variance in the rate categories.
```
speciation_sd <- H*2
extinction_sd <- H*2
```
Now we can create the prior distributions on the speciation and extinction rates.
Note that we achieve this by using the `=` operator and the distribution on the
right-hand-side. This command will not create a random variable drawn from a lognormal
distribution but instead a distribution object. We need this distribution object as an argument
of our conditional-birth-death-shift process.
```
speciation_rate_prior = dnLognormal(speciation_prior_mean,speciation_sd)
extinction_rate_prior = dnLognormal(extinction_prior_mean,extinction_sd)
```
Additionally, we need to create a variable for the speciation and extinction rates
at the root. In RevBayes, we could have used the same distribution for the rates at root,
which we actually do here specifically, but we decided to give the user the option to specify another
prior distribution.
```
speciation_root ~ dnLognormal(speciation_prior_mean,speciation_sd)
extinction_root ~ dnLognormal(extinction_prior_mean,extinction_sd)
```
Again, we use a `scaling-move` to update the speciation and extinction rates at the root.
```
moves.append( mvScale(speciation_root,lambda=1,tune=true,weight=5) )
moves.append( mvScale(extinction_root,lambda=1,tune=true,weight=5) )
```

Next, we need a rate parameter for the rate-shifts events. We do not
have much prior information about this rate but we can provide some
realistic ranges. For example, we can specify a mean rate so that the
resulting number of expected rate-shift events is 2 (as specified in our
global variable `EXPECTED_NUM_EVENTS`). Furthermore, we can say that
the 95% prior ranges exactly one order of magnitude. We achieve all this
by specifying a lognormal prior distribution with mean `ln(
EXPECTED_NUM_EVENTS/tree_length )` and standard deviation of `H`.
Remember that this is only possible if the tree is known and not
estimated simultaneously because only if the tree is do we also know the
tree length. As usual for rate parameter, we apply a scaling move to the
`shift_rate` variable.

```
shift_rate ~ dnLognormal( ln( EXPECTED_NUM_EVENTS/tree_length ), H)
```
As usual, we apply a `scaling-move` on this rate parameter.
```
moves.append( mvScale(shift_rate,lambda=1,tune=true,weight=5) )
```

{% subsubsection Incomplete Taxon Sampling %}

We know that we have sampled 233 out of 367 living primate species. To
account for this we can set the sampling parameter as a constant node
with a value of 233 / 367.
```
rho <- observed_phylogeny.ntips() / NUM_TOTAL_SPECIES
```

{% subsubsection Root age %}

The birth-death process requires a parameter for the root age. In this
exercise we use a fix tree and thus we know the age of the tree. Hence,
we can get the value for the root from the {% cite MagnusonFord2012 %} tree. This
is done using our global variable `root` defined above and nothing else
has to be done here.

{% subsubsection The time tree %}

Now we have all of the parameters we need to specify the full episodic
birth-death model. We initialize the stochastic node representing the
time tree.
```
timetree ~ dnCBDSP(rootLambda=speciation_root,
                   rootMu=extinction_root,
                   lambda=speciation_rate_prior, 
                   mu=extinction_rate_prior, 
                   delta=shift_rate, 
                   rootAge=root, 
                   rho=rho, 
                   condition="time",
                   taxa=taxa )
```
And then we attach data to it.
```
timetree.clamp(observed_phylogeny)
```
This specific implementation of the *condination-birth-death-shift process*
augments the tree with rate-shift events. In order to sample the number,
the location, and the types of the rate-shift events, we have to apply
special moves to the tree. These moves will not change the tree but only
the augmented rate-shift events. We use a `mvBirthDeathEventContinuous` to add and
remove events, a `mvEventTimeBeta` and `mvEventTimeSlide` to move to change the time and location
of the events, and a `mvContinuousEventScale` to change the
the speciation and extinction rates of the event.
```
moves.append( mvBirthDeathEventContinuous(timetree, weight=10) )
moves.append( mvContinuousEventScale(timetree, lambda=1.0, weight=5) )
moves.append( mvEventTimeBeta(timetree, delta=0.01, offset=1.0, weight=5,tune=TRUE) )
moves.append( mvEventTimeSlide(timetree, delta=timetree.treeLength()/10.0, weight=5,tune=false) )
```
In this analysis, we are interested in the branch-specific
diversification rates. So far we do not have any variables that directly
give us the number of rate-shift events per branch or the rates per
branch. Fortunately, we can construct deterministic variables and query
these properties from the tree. These function are made available by the
birth-death-shift process distribution.
```
num_events := timetree.numberEvents()
avg_lambda := timetree.averageSpeciationRate()
avg_mu     := timetree.averageExtinctionRate()
avg_net    := avg_lambda - avg_mu
avg_rel    := avg_mu / avg_lambda

total_num_events := sum( num_events )
```

Finally, we create a workspace object of our whole model using the
`model()` function.
```
mymodel = model(speciation)
```
The `model()` function traversed all of the connections and found all of
the nodes we specified.

{% subsection Running a MCMC simulation %}

{% subsubsection Specifying Monitors %}

For the marginal likelihood analysis we don't necessarily need monitors
because we are not going to look into the samples. However, as good
practice we still define our two standard monitors: the model monitor
and a screen monitor
```
monitors.append( mnModel(filename="output/primates_CBDSP.log",printgen=10, separator = TAB) )
monitors.append( mnExtNewick(filename="output/primates_CBDSP.trees", isNodeParameter=FALSE, printgen=10, separator = TAB, tree=timetree, avg_lambda, avg_mu, avg_net, avg_rel) )
monitors.append( mnScreen(printgen=1000, shift_rate, speciation_root, extinction_root, total_num_events) )
```

{% subsection Running an MCMC analysis %}

{% subsubsection Specifying Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to
record the states of our Markov chain. First, we will initialize the
model monitor using the `mnModel` function. This creates a new monitor
variable that will output the states for all model parameters when
passed into a MCMC function.
```
monitors.append( mnModel(filename="output/primates_CBDSP.log",printgen=10, separator = TAB) )
```
Additionally, we create an extended-Newick monitor. The extended-Newick
monitor writes the tree to a file and adds parameter values to the
branches and/or nodes of the tree. We can thus print the tree with the
average speciation and extinction rates, as well as the net
diversification (speciation - extinction) and relative extinction
(extinction / speciation) rates, for each branch into a file. We will
need this file later to estimate and visualize the posterior
distribution of the rates at the branches.
```
monitors.append( mnExtNewick(filename="output/primates_CBDSP.trees", isNodeParameter=FALSE, printgen=10, separator = TAB, tree=timetree, avg_lambda, avg_mu, avg_net, avg_rel) )
```
Finally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=1000, shift_rate, speciation_root, extinction_root, total_num_events) )
```

{% subsubsection Initializing and Running the MCMC Simulation %}

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The `mcmc()` function will
create our MCMC object:
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=2, combine="mixed")
```
Now, run the MCMC:
```
mymcmc.run(generations=10000,tuningInterval=200)
```
When the analysis is complete, you will have the monitored files in your
output directory. You can then visualize the branch-specific rates by
attaching them to the tree. This is actually done automatically in our
`mapTree` function.
```
treetrace = readTreeTrace("output/primates_CBDSP.trees", treetype="clock")
map_tree = mapTree(treetrace,"output/primates_CBDSP_MAP.tree")
```
Now you can open the tree in `FigTree`.

&#8680; The `Rev` file for performing this analysis: `mcmc_CBDSP.Rev`