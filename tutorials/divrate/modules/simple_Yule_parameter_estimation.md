{% section Pure-Birth (Yule) Model %}


In this section, we will walk through specifying a pure-birth process model and
estimating the speciation rate.
Then, we will continue by estimating the marginal likelihood of the model so that we can perform model comparison.
The section about the birth-death process will be less detailed because it will build up on this section.

The simplest branching model is the *pure-birth process* described by
{% citet Yule1925 %}. Under this model, we assume at any instant in time, every
lineage has the same speciation rate, $\lambda$. In its simplest form,
the speciation rate remains constant over time. As a result, the waiting
time between speciation events is exponential, where the rate of the
exponential distribution is the product of the number of extant lineages
($n$) at that time and the speciation rate: $n\lambda$
{% cite Yule1925 Aldous2001 Hoehna2015a %}. The pure-birth branching model
does not allow for lineage extinction
(*i.e.*, the extinction rate $\mu=0$). However,
the model depends on a second parameter, $\rho$, which is the
probability of sampling a species in the present time. It also depends
on the time of the start of the process, whether that is the origin time
or root age. Therefore, the probabilistic graphical model of the
pure-birth process is quite simple, where the observed time tree
topology and node ages are conditional on the speciation rate, sampling
probability, and root age ({% ref fig_yule_gm %}).

{% figure fig_yule_gm %}
<img src="figures/yule_gm.png" width="50%" height="50%" />
{% figcaption %}
The graphical model representation of the pure-birth (Yule) process.
For more information about graphical model representations see {% citet Hoehna2014b %}.
{% endfigcaption %}
{% endfigure %}

We can add hierarchical structure to this model and account for
uncertainty in the value of the speciation rate by placing a prior distribution
on $\lambda$ ({% ref fig_yule_gm2 %}).
The graphical models in {% ref fig_yule_gm %}
and {% ref fig_yule_gm2 %} demonstrate the simplicity of the Yule model.
Ultimately, the pure birth model is just a special case of
the birth-death process, where the extinction rate (typically denoted
$\mu$) is a constant node with the value 0.

{% figure fig_yule_gm2 %}
<img src="figures/yule_gm2.png" width="50%" height="50%" />
{% figcaption %}
The graphical model representation
of the pure-birth (Yule) process, where the speciation rate is treated
as a random variable drawn from a uniform distribution.
{% endfigcaption %}
{% endfigure %}

For this exercise, we will specify a Yule model, such that the speciation rate is a stochastic node, drawn from a uniform distribution as in {% ref fig_yule_gm2 %}.
In a Bayesian framework, we are interested in estimating the posterior probability of $\lambda$ given that we observe a time tree.

$$
\begin{equation}
\mathbb{P}(\lambda \mid \Psi) = \frac{\mathbb{P}(\Psi \mid \lambda)\mathbb{P}(\lambda \mid \nu)}{\mathbb{P}(\Psi)}
\tag{Bayes Theorem}\label{eq:bayes_thereom}
\end{equation}
$$

In this example, we have a phylogeny of 233 primates.
We are treating the time tree $\Psi$ as an observation, thus clamping the model with an observed value.
The time tree we are conditioning the process on is taken from the analysis by {% citet MagnusonFord2012 %}.
Furthermore, there are approximately 367 described primates species, so we will fix the parameter $\rho$ to $233/367$.

&#8680; The full Yule-model specification is in the file called `mcmc_Yule.Rev`.


{% subsection Read the tree %}

Begin by reading in the observed tree and get some useful variables.
We will need these later on.
{{ "mcmc_Yule.Rev" | snippet:"line","19-22" }}

Additionally, we can initialize a variable for our vector of moves and monitors:
{{ "mcmc_Yule.Rev" | snippet:"line","26-27" }}


{% subsection Specifying the model %}

{% subsubsection Birth rate %}

The model we are specifying only has three nodes ({% ref fig_yule_gm2 %}).
We can specify the birth rate $\lambda$, the minimum and maximum of the uniform hyperprior on $\lambda$, and the conditional dependency of the two parameters all in one line of `Rev` code.
{{ "mcmc_Yule.Rev" | snippet:"line","35" }}

Here, the stochastic node called `birth_rate` represents the speciation rate $\lambda$.
To estimate the value of $\lambda$, we assign a proposal mechanism to operate on this node.
In RevBayes these MCMC sampling algorithms are called *moves*.
We will use a scaling move on $\lambda$ called `mvScale`.
{{ "mcmc_Yule.Rev" | snippet:"line","38" }}

{% subsubsection Sampling probability %}

Our prior belief is that we have sampled 233 out of 367 living primate
species. To account for this we can set the sampling parameter as a
constant node with a value of 233/367
{{ "mcmc_Yule.Rev" | snippet:"line","43" }}
Note that we will assume "uniform" taxon sampling {% cite Hoehna2011 Hoehna2014a %}, which we will specify below.
If we want to learn more about different taxon sampling options, then look at {% page_ref divrate/sampling %} tutorial.

{% subsubsection Root age %}

Any stochastic branching process must be conditioned on a time that
represents the start of the process. Typically, this parameter is the
*origin time* and it is assumed that the process started with *one*
lineage. Thus, the origin of a birth-death process is the node that is
*ancestral* to the root node of the tree. For macroevolutionary data,
particularly without any sampled fossils, it is difficult to use the
origin time. To accommodate this, we can condition on the age of the
root by assuming the process started with *two* lineages that both
originate at the time of the root.

We can get the value for the root from the {% citet MagnusonFord2012 %} tree.
{{ "mcmc_Yule.Rev" | snippet:"line","46" }}

{% subsubsection The time tree %}

Now we have all of the parameters we need to specify the full pure-birth
model. We can initialize the stochastic node representing the time tree.
Note that we set the `mu` parameter to the constant value `0.0`.
{{ "mcmc_Yule.Rev" | snippet:"line","50" }}
Note that we specified the `condition="survival"`, which says that we assume this process only produced trees that survived until the present.
Fore more information, see [Conditions of the Birth-Death Process]({{ base.url }}/tutorials/divrate/div_rate_intro#conditions). 

If you refer back to Equation \eqref{eq:bayes_thereom} and {% ref fig_yule_gm2 %},
the time tree $\Psi$ is the variable we observe,
*i.e.*, the data. We can set this in `Rev` by
using the `clamp()` function.
{{ "mcmc_Yule.Rev" | snippet:"line","53" }}
Here we are fixing the value of the time tree to our observed tree from
{% citet MagnusonFord2012 %}.

Finally, we can create a workspace object of our whole model using the
`model()` function. Workspace objects are initialized using the `=`
operator. This distinguishes the objects used by the program to run the
MCMC analysis from the distinct nodes of our graphical model. The model
workspace objects makes it easy to work with the model in `Rev` and
creates a wrapper around our model DAG. Because our model is a directed,
acyclic graph (DAG), we only need to give the model wrapper function a
single node and it does the work to find all the other nodes through
their connections.
```
mymodel = model(birth_rate)
```
The `model()` function traverses all of the connections and finds all of
the nodes we specified.


{% subsection Running an MCMC analysis %}

{% subsubsection Specifying Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to
record the states of our Markov chain. The monitor functions are all
called `mn*`, where `*` is the wildcard representing the monitor type.
First, we will initialize the model monitor using the `mnModel`
function. This creates a new monitor variable that will output the
states for all model parameters when passed into a MCMC function.
{{ "mcmc_Yule.Rev" | snippet:"line","66" }}
Additionally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
{{ "mcmc_Yule.Rev" | snippet:"line","67" }}


{% subsubsection Initializing and Running the MCMC Simulation %}

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The `mcmc()` function will
create our MCMC object:
{{ "mcmc_Yule.Rev" | snippet:"line","76" }}
Now, run the MCMC:
{{ "mcmc_Yule.Rev" | snippet:"line","79" }}
When the analysis is complete, you will have the monitored files in your
output directory.

&#8680; The `Rev` file for performing this analysis: `mcmc_Yule.Rev`



{% subsection Exercise 1 %}
-   Run an MCMC simulation to estimate the posterior distribution of the
    speciation rate (`birth_rate`).
-   Plot the `birth_rate` using RevGadgets ({% page_ref intro/revgadgets %}, {% citet Tribble2022 %}): What is
    the mean posterior estimate of the `birth_rate` and what is the
    estimated HPD?
-   Compare the prior mean with the posterior mean. (**Hint:** Call the
    method `.ignoreAllData()` on the model object to ignore data at clamped nodes.)
    Are they different (*e.g.,* {% ref fig_prior_posterior %})?
    Is the posterior mean outside the prior 95% probability interval?
-   Repeat the analysis and allow for two orders of magnitude of
    prior uncertainty.

{% figure fig_prior_posterior %}
<img src="figures/birth_rate_prior_posterior.png" height="50%" width="50%" />
{% figcaption %}
Estimates of the
posterior and prior distribution of the `birth_rate` visualized in
`RevGadgets` {% cite Tribble2022 %}.
We used the script `plot_Yule_rates.R`.
The prior (red curve) shows the lognormal distribution that we chose as the prior distribution.
{% endfigcaption %}
{% endfigure %}
