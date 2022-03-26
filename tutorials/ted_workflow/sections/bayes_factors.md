{% section Comparing Model Fit with Bayes Factors | bayes_factors %}

If we assess model sensitivity and determine that our estimates depend on the choice of model (as they often do), we will naturally want to ask: _Which of the models best describes my dataset?_ or _which of the estimates should I trust the most/report in my results?_.
We can use _Bayes factors_ to compare the relative fit of different models to our data, which allows us to decide which results are the most trustworthy.

The _Bayes factor_ represents how well one model, $M_0$, fits the data relative to an alternative model, $M_1$.
The Bayes factor between models $M_0$ and $M_1$ ($\text{BF}_{01}$) is calculated as:

$$
\begin{equation*}
\text{BF}_{01} = \frac{ P(X \mid M_0) }{ P(X \mid M_1) }
\end{equation*}
$$

where $P(X \mid M_i)$ is the marginal likelihood of model $M_i$.
A Bayes factor greater than 1 indicates support for model $M_0$, while a Bayes factor between 0 and 1 indicates support for model $M_1$.
We often report $$2 \ln \text{BF}_{01}$$ (twice the Bayes factor on the log scale), in which case values greater than 0 indicate support for model $M_0$ and less than 0 indicate support for model $M_1$.
The nice thing about the log scale is that it is _symmetrical_ around 0: $$2\ln\text{BF}_{01} = 5$$ represents the same amount of support for $M_0$ as $$2\ln\text{BF}_{01} = -5$$ represents for $M_1$.

The _marginal likelihood_ for a given model (the denominator of Bayes' theorem) is the probability of the data (the likelihood) averaged over all possible parameter values in proportion to their prior probability.
Because it is the _average_ probability of the data, Bayes factors intuitively represent our preference for models that have a higher average probability of producing the data.
Also, because the must integrate over each prior distribution, increasing the number of parameters will tend to _reduce_ the marginal likelihoods unless the additional parameters improve the fit of the model; that is, Bayes factors provide a natural way of penalizing additional parameters.

For more details of Bayes factors and how to interpret them, please see the [Model Selection tutorial]({{site.baseurl}}{% link tutorials/model_selection_bayes_factors/bf_intro.md %}).

{% subsection Estimating the Marginal Likelihood with Power-Posterior Analysis %}

The only difference between estimating the posterior distribution and estimating the marginal likelihood is that we must run a variant of Markov-chain Monte Carlo called _power-posterior_ analysis.
This involves running a set of $k$ MCMC runs, each of which experiences a "distorted" version of the posterior distribution.
Each run is sometimes called a "stone" or a "cat" (category).
This distortion is represented by a parameter, $\beta$, which is used to "heat" the likelihood function:

$$
\begin{equation*}
P_\beta(\theta \mid X) = \frac{ P(X \mid \theta)^\beta P(\theta)}{ P_\beta(X) }
\end{equation*}
$$

(Because we raise the likelihood function to a _power_, this is called a _power posterior_ analysis.)
We run a set of Markov chains with $\beta$ ranging from 0 (the prior) to 1 (the posterior), and use the resulting samples of the likelihoods sampled by each run to estimate the marginal likelihood using either a "Path-Sampling" estimator or a "Stepping-Stone" estimator.
In theory, these two estimates are the same, but they can be different if we don't use enough stones or if we don't sample enough from each stone.
See the [Model Selection tutorial]({{site.baseurl}}{% link tutorials/model_selection_bayes_factors/bf_intro.md %}) for more details about how this algorithm works.

Practically, rather than using `modules/analysis/MCMC.Rev`, we need to set up a new analysis type for the power-posterior analysis.
(This analysis script is already provided in `modules/analysis/PP.Rev`.)
To run a power-posterior analysis, we first have to decide on some settings, in particular: how frequently to write a sample of the chain to a file, how many stones to use, and how many generations to run per stone:
```R
# analysis settings
printgen = 2
nstones  = 30
ngen     = 1000
```
The number of generations is _per stone_, so the total number of generations is the number of stones times the number of generations!
The quality of the marginal-likelihood estimate will depend on the number of generations; we number of stones and generations we use is small because our dataset is relatively small, but you will probably need to use more to get accurate estimates for larger datasets.

We then create a screen monitor to give us a progress bar:
```R
# the monitors
monitors = VectorMonitors()
monitors.append( mnScreen(printgen = printgen) )
```
(Note that we aren't creating other monitors here, like an `mnModel` or `mnFile` monitor to keep track of parameter samples. Because the chains in a power-posterior analysis experience a distorted posterior distribution, the sampled parameters are not a valid approximation of the posterior distribution, except when $\beta = 1$.
If you want to estimate the posterior distribution, you should use the `MCMC.Rev` analysis module.)

As with MCMC, we define a model object:
```R
# the model
mymodel = model(timetree)
```

Next, we define our power-posterior analysis object.
This function takes the number of stones (the `cats`) argument, as well as the filename for the samples per stone.
```R
# make the analysis
mymcmc = powerPosterior(mymodel, monitors, moves, filename = output_filename + "/stones/pp.log", cats = nstones, sampleFreq = printgen)
```
(This function automatically decides where to place the $\beta$ values for each stone, but advanced users may want to control where the stones go using the `powers` or `alpha` arguments, describes in the documentation. The placement of stones can have some affect on the accuracy of marginal-likelihood estimates, but the default values are usually pretty good.)

We then run the power-posterior analysis.
```R
# run the analysis
mymcmc.run(generations = ngen)
```

After the analysis finishes, we read in the samples to compute both the path-sampling and stepping-stone estimates of the marginal likelihood.
If these estimates are different, it indicates that we did not use enough stones and/or did not sample enough generations per stone!
We print each estimate to screen, but also write them into a file named `ml.txt` for later reference.
```R
# compute the path-sampling estimate of the marginal likelihood
ps = pathSampler(file = output_filename + "/stones/pp.log", powerColumnName = "power", likelihoodColumnName = "likelihood")
ps_ml = ps.marginal()
"Path-sampling estimate of ML: " + ps_ml

# compute the stepping-stone estimate of the marginal likelihood
ss = steppingStoneSampler(file = output_filename + "/stones/pp.log", powerColumnName = "power", likelihoodColumnName = "likelihood")
ss_ml = ss.marginal()
"Stepping-stone sampling estimate of ML: " + ps_ml

# write the estimates to file
write(ps_ml, ss_ml, filename = output_filename + "/ml.txt")
```

&#9888; **_NOTE: The values reported by these marginal likelihood estimates are in fact the log marginal likelihoods! If you want to compute the Bayes factor between two models, plug these log marginal likelihoods into the following equation:_**

$$
\begin{equation*}
2 \ln \text{BF}_{01} = 2 \times \left[ \text{log-marginal-likelihood of }M_0 - \text{log-marginal-likelihood of }M_1 \right]
\end{equation*}
$$

That's it!
The rest of the model files do not need to change, because the power-posterior analysis does not involve modifications to the model itself.

{% subsection Exercise 2: Comparing among models %}

Now that we've written a `PP.Rev` analysis script for doing a power-posterior analysis, we want to compare the fit of our models.
Prepare a header file for each of the five models we explored in Exercise 1, above.
(We also provide the relevant header files in `headers/PowerPosterior`.
Note that these model comparisons are _not exhaustive_, and you might want to consider more combinations of models to pinpoint which parts of the model are affecting model fit.)

Use these header files to estimate the marginal likelihood for each model.
For each model, assess whether the path-sampling and and stepping-stone estimates are the same.

{% figure tab_ml_ted_models %}

|       **Model**        |   **Path-Sampling**   |   **Stepping-Stone-Sampling**   |
------------------------:|:---------------------:|:-------------------------------:|
| `strict_Mk`            |                       |                                 |
| `UCLN_Mk`              |                       |                                 |
| `UCE_Mk`               |                       |                                 |
| `UCLN_F81Mix`          |                       |                                 |
| `epochal_Mk`           |                       |                                 |

{% figcaption %}
Marginal likelihoods for total-evidence models.
{% endfigcaption %}
{% endfigure %}

Now, compare the relative fit by computing the Bayes factor between each pair of models:

{% figure tab_bf_ted_models %}

| **Model** | `strict_Mk` | `UCLN_Mk` | `UCE_Mk` | `UCLN_F81Mix` | `epochal_Mk` |
-----------:|:-----------:|:---------:|:--------:|:-------------:|:------------:|
| `strict_Mk` | | | | | |
| `UCLN_Mk` | | | | | |
| `UCE_Mk` | | | | | |
| `UCLN_F81Mix` | | | | | |
| `epochal_Mk` | | | | | |

{% figcaption %}
Bayes factors between total-evidence models.
{% endfigcaption %}
{% endfigure %}

<!--  -->
