{% section Birth-Death Process %}

The pure-birth model does not account for extinction, thus it assumes
that every lineage at the start of the process will have sampled
descendants at time 0. This assumption is fairly unrealistic for most
phylogenetic datasets on a macroevolutionary time scale since the fossil
record provides evidence of extinct lineages. {% citet Kendall1948 %} described a
more general branching process model to account for lineage extinction
called the *birth-death process*. Under this model, at any instant in
time, every lineage has the same rate of speciation $\lambda$ and the
same rate of extinction $\mu$. This is the *constant-rate* birth-death
process, which considers the rates constant over time and over the tree
{% cite Nee1994b Hoehna2015a %}.

{% citet Yang1997 %} derived the probability of time trees under an extension of
the birth-death model that accounts for incomplete sampling of the tips
({% ref fig_bdp_gm %}) (see also {% citet Stadler2009 Hoehna2011 %} and {% citet Hoehna2014a %}).
Under this model, the parameter $\rho$ accounts for the probability of
sampling in the present time, and because it is a probability,
this parameter can only take values between 0 and 1.
For more information on incomplete taxon sampling, see {% page_ref divrate/sampling %} tutorial.

{% figure fig_bdp_gm %}
<img src="figures/BDP_GM_simple.png" height="50%" width="50%" />
{% figcaption %}
The graphical model representation of the birth-death process with uniform sampling and
conditioned on the root age.
{% endfigcaption %}
{% endfigure %}

In principle, we can specify a model with prior distributions on
speciation and extinction rates directly. One possibility is to specify
an exponential, lognormal, or gamma distribution as the prior on either
rate parameter. However, it is more common to specify prior
distributions on a transformation of the speciation and extinction rate
because, for example, we want to enforce that the speciation rate is
always larger than the extinction rate.

{% figure fig_bdp_div_turn_gm %}
<img src="figures/BDP_GM.png" height="50%" width="50%" />
{% figcaption %}
The graphical model representation of the birth-death process
with uniform sampling parameterized using the diversification and turnover.
{% endfigcaption %}
{% endfigure %}

In the following subsections we will only provide the key command that
are different for the constant-rate birth-death process. All other
commands will be the same as in the previous exercise. You should copy
the `mcmc_Yule.Rev` script and modify it accordingly. Don't forget to
rename the filenames of the monitors to avoid overwriting of your
previous results!

{% subsection Birth rate and death rate %}

Previously we assumed a uniform prior on the birth rate to signal that we have
little information. The only information we use is that the rates are positive and
smaller than 10 events per lineage per million years. We will apply this same prior
distribution now for our birth-death model for both the birth and death rate.
{{ "mcmc_BD.Rev" | snippet:"line","34-35" }}
As before we will apply scaling moves on both parameters.
{{ "mcmc_BD.Rev" | snippet:"line","38-39" }}
The birth and death rates are likely to be correlated, i.e., we will get
better MCMC mixing if you jointly update both the birth and death rates.
Joint updates can be done with our `mvUpDownScale` move.
{{ "mcmc_BD.Rev" | snippet:"line","41-44" }}


{% subsection Diversification and turnover %}
The birth and death rates are our stochastic parameters and intrinsic
parameters. However, often we are also interested in the diversification and
relative extinction rate (or sometimes called turnover rate), which are simple
transformations of our birth and death rates. Thus, we create some deterministic
variables called `diversification` and `rel_extinction`.
{{ "mcmc_BD.Rev" | snippet:"line","47-48" }}

All other parameters, such as the sampling probability and the root age
are kept the same as in the analysis above.


{% subsection The time tree %}

Initialize the stochastic node representing the time tree. The main
difference now is that we provide a stochastic parameter for the
extinction rate $\mu$.
```
timetree ~ dnBDP(lambda=birth_rate, mu=death_rate, rho=rho, rootAge=root_time, samplingStrategy="uniform", condition="survival", taxa=taxa)
```


&#8680; The `Rev` file for performing this analysis: `mcmc_BD.Rev`


{% subsection Exercise 3 %}

-   Run an MCMC simulation to compute the posterior distribution of the
    diversification and turnover rate.
-   Look at the parameter estimates in `Tracer`. What can
    you say about the diversification, turnover, speciation and
    extinction rates? How high is the extinction rate compared with the
    speciation rate?
-   Compute the marginal likelihood under the BD model. Which model is
    supported by the data?
-   Enter the estimate in the table above.
-   Can you modify the script to use a prior on the birth drawn from a
    lognormal distribution and relative death rate drawn from a beta
    distribution so that the extinction rate is equal to the birth rate
    times the relative death rate?
    1.  Do the parameter estimates change?
    2.  What about the marginal likelihood estimates?



{% figure fig_bd_posterior %}
<img src="figures/birth_death_rate.png" height="50%" width="50%" />
{% figcaption %}
Estimates of the posterior distribution of the `birth_rate` and `death_rate` visualized in `RevGadgets` {% cite Tribble2022 %}.
We used the script `plot_BD_rates.R`.
{% endfigcaption %}
{% endfigure %}
