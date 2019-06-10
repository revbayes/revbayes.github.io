{% section Environmental-dependent Diversification Rate Models %}


The fundamental idea of this model is the question if diversification rates are correlated with an environmental variable.
Examples of environmental variables are $\text{CO}_2$ and temperature.
{% figure fig_CO2 %}
<img src="figures/Historical_CO2.png" width="75%" height="75%" /> 
{% figcaption %} 
Estimates of historical $\text{CO}_2$ values. These estimates are obtained from XXX. The unit of $\text{CO}_2$ represents XXX
{% endfigcaption %}
{% endfigure %}
Have a look at {% ref fig_CO2 %} which shows the historical value $\text{CO}_2$ in the last 50 million years.
We can clearly see that the $\text{CO}_2$ dropped drastically around 30 million years ago.

{% figure fig_EBD_estimates %}
<img src="figures/EBD_10_Result.png" width="75%" height="75%" /> 
{% figcaption %} 
Estimated diversification rates through time. These estimates are taken from the episodic birth-death model with autocorrelated (Brownian motion) rate as described in the {% page_ref divrate/ebd %}.
{% endfigcaption %}
{% endfigure %}
In our previous {% page_ref divrate/ebd %} we estimated diversification as shown in {% ref fig_EBD_estimates %}.
We clearly see that diversification rates were not constant through time.
Now we wonder if perhaps the diversification rates are correlated with $\text{CO}_2$.

We want to build on our episodic birth-death model so that our environmental correlation model collapses to the episodic birth-death model if there is no correlation.
Recall that we used a Brownian motion model on the log-transformed rates.
Hence, we assumed that the rates in the next time interval (epoch) have the current value as their expectation:

$$
E[\log( \lambda(t) )] = \log( \lambda(t-\Delta t) )
$$

For the environmental dependent birth-death model, we have additional observation from the environmental variable.
Thus, we know how much the environmental variable changed between time intervals (epochs).
We can compute this change by taking the ratio between two consecutive measurements: 
$\frac{\text{CO}_2(t)}{\text{CO}_2(t-\Delta t)}$.
Hence, if the $\text{CO}_2$ double from one epoch to the next we would compute a change of 2.
This has the clear advantage that our computation is less sensitive to the unit and magnitude of the environmental variable.

Now let us assume that our diversification rates shift synchronously with the environmental variable if they are actually correlated.
Then we can express our expectation of the log-transformed diversification rate in the next time interval (epoch) as being equal the log-transform diversification rate in the current time interval plus the log-transformed change in the environmental variable:

$$
E[\log( \lambda(t) )] = \log( \lambda(t-\Delta t) ) + \beta \times \log\left( \frac{\text{CO}_2(t)}{\text{CO}_2(t-\Delta t)} \right) \mbox{ .}
$$

Here we denote the correlation coefficient by $\beta$.
If $\beta > 0$ then there is a positive correlation between the speciation rate and $\text{CO}_2$, that is, if the $\text{CO}_2$ increases then the speciation increases also.
If $\beta < 0$ then there is a negative correlation between the speciation rate and $\text{CO}_2$, that is, if the $\text{CO}_2$ increases then the speciation decreases.
Finally, if $\beta = 0$ then there is no correlation and our model collapses to the episodic birth-death model.

In summary, we use a regression-like prior model for the speciation and extinction rate where the environmental variable (here $\text{CO}_2$) is the predictor variable.
Specifically, we use a Brownian motion model for the log-transformed speciation and extinction rates where the expectation depends on the shift in the environmental variable.
Thus, our model can be considered as a Brownian motion model with drift where the drift parameter is the environmental variable.

We will now walk you through setting up this analysis in `RevBayes`.
