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
({% ref fig_bdp_gm %}) (see also {% citet Stadler2009 %} and {% citet Hoehna2014a %}). Under
this model, the parameter $\rho$ accounts for the probability of
sampling in the present time, and because it is a probability, this
parameter can only take values between 0 and 1.

{% figure fig_bdp_gm %}
<img src="figures/simple_BD_gm_root.png" height="50%" width="50%" /> 
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
<img src="figures/cBDR_gm.png" height="50%" width="50%" /> 
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

{% subsection Diversification and turnover %}

We have some good prior information about the magnitude of the
diversification. The diversification rate represent the rate at which
the species diversity increases. Thus, we just use the same prior for
the diversification rate as we used before for the birth rate.
```
diversification_mean <- ln( ln(367.0/2.0) / T.rootAge() )
diversification_sd <- 0.587405
diversification ~ dnLognormal(mean=diversification_mean,sd=diversification_sd)
moves.append( mvScale(diversification,lambda=1.0,tune=true,weight=3.0) )
```
Unfortunately, we have less prior information about the turnover rate.
The turnover rate is the rate at which one species is replaced by
another species due to a birth plus death event. Hence, the turnover
rate represent the longevity of a species. For simplicity we use the
same prior on the turnover rate but with two orders of magnitude prior
uncertainty.
```
turnover_mean <- ln( ln(367.0/2.0) / T.rootAge() )
turnover_sd <- 0.587405*2
turnover ~ dnLognormal(mean=turnover_mean,sd=turnover_sd)
moves.append( mvScale(turnover,lambda=1.0,tune=true,weight=3.0) )
```

{% subsection Birth rate and death rate %}

The birth and death rates are both deterministic nodes. We compute them
by simple parameter transformation. Note that the death rate is in fact
equal to the turnover rate.
```
birth_rate := diversification + turnover
death_rate := turnover
```
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