{% section Episodic Diversification Rate Models | models %}


The basic idea behind the model is that speciation and extinction rates are constant 
within time intervals but can be different between time intervals.
Thus, we will divide time into equally sized intervals.
An overview of the underlying theory of the specific model and implementation 
is given in {% cite Hoehna2015a %}.

{% figure fig_EBD %}
<img src="figures/EBD_scenarios.png" width="75%" height="75%" /> 
{% figcaption %} 
Two scenarios of birth-death models. On the left we show constant diversification. 
On the right we show an example of an episodic birth-death process where rates 
are constant in each time interval (epoch). The top panel of this figure shows 
an example realization under the given rates.
{% endfigcaption %}
{% endfigure %}

{% ref fig_EBD %} shows an example of a constant rate birth-death process and 
an episodic birth-death process.

We assume that the log-transformed rates are drawn from a normal distribution.
Furthermore, we will assume that rates are autocorrelated, that is, rates in the current time interval will be centered around the rates in the previous time interval.
Thus, we model (log-transformed) diversification rates by a Brownian motion.
The assumption of autocorrelated rates does not only makes sense biologically but also improves our ability to estimate parameters.

{% figure fig_EBD_GM %}
<img src="figures/graphical_model_EBD.png" width="75%" height="75%" /> 
{% figcaption %} 
A graphical model with the outline of the `Rev` code. On the left we see the graphical model 
describing the correlated (Brownian motion) model for rate-variation through time. 
On the right we show the corresponding `Rev` commands to instantiate this model. 
This figure gives a complete overview of the model that we use here in this analysis.
{% endfigcaption %}
{% endfigure %}

We show a graphical model of the episodic birth-death process with autocorrelated rates 
in {% ref fig_EBD_GM %}.
This graphical model shows you which variables are included in the model, 
and the dependency between the variables.
Thus, it makes the structure and assumption of the model clear and 
visible instead of a black-box {% cite Hoehna2014b %}.
For example, you see how the speciation and extinction rates in each time interval 
depend on the rates of the previous interval, and that we use a hyperprior for 
the standard deviation of rates between time intervals.

