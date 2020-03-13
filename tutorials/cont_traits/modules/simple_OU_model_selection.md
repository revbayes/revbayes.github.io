{% section Comparing OU and BM models %}

Now that we can fit both BM and OU models, we might naturally want to know which model does fits better. In this section, we will learn how to use reversible-jump Markov chain Monte Carlo to compare the fit of OU and BM models.

{% subsection Model Selection using Reversible-Jump MCMC %}

To test the hypothesis that a character evolves toward a selective optimum, we imagine two models. The first model, where there is no adaptation towards the optimum, is the case when $\alpha = 0$. The second model corresponds to the OU model with $\alpha > 0$. This works because Brownian motion is a special case of the OU model when the rate of adaptation is 0. Unfortunately, because $\alpha$ is a continuous parameters, a standard Markov chain will never visit states where each value is exactly equal to 0. Fortunately, we can use reversible jump to allow the Markov chain to consider visiting the Brownian-motion model. This involves specifying the prior probability on each of the two models, and providing the prior distribution for $\alpha$ for the OU model.

Using rjMCMC allows the Markov chain to visit the two models in proportion to their posterior probability. The posterior probability of model $i$ is simply the fraction of samples where the chain was visiting that model. Because we also specify a prior on the models, we can compute a Bayes Factor for the OU model as:

$$
\begin{equation}
    \text{BF}_\text{OU} = \frac{ P( \text{OU model} \mid X) }{ P( \text{BM model} \mid X) } \div \frac{ P( \text{OU model}) }{ P( \text{BM model}) },
\end{equation}
$$

where $P( \text{OU model} \mid X)$ and $P( \text{OU model})$ are the posterior probability and prior probability of the OU model, respectively.

{% subsubsection Reversible-jump between OU and BM models %}

To enable rjMCMC, we simply have to place a reversible-jump prior on the relevant parameter, $\alpha$. We can modify the prior on `alpha` so that it takes either a constant value of 0, or is drawn from a prior distribution. Finally, we specify a prior probability on the OU model of `p = 0.5`.

```
alpha ~ dnReversibleJumpMixture(0.0, dnExponential(10), 0.5)
```
We then provide a reversible-jump proposal on `alpha` that proposes changes between the two models.
```
moves.append( mvRJSwitch(alpha, weight=1.0) )
```
Additionally, we provide the normal `mvScale` proposal for when the MCMC is visiting the OU model.
```
moves.append( mvScale(alpha, weight=1.0) )
```
We include a variable that has a value of `1` when the chain is visiting the OU model, and a corresponding variable that has value `1` when it is visiting the BM model. This will allow us to easily compute the posterior probability of the models because we simply need to compute the posterior mean value of this parameter.
```
is_OU := ifelse(alpha != 0.0, 1, 0)
is_BM := ifelse(alpha == 0.0, 1, 0)
```
The fraction of samples for which `is_OU = 1` is the posterior probability of the OU model. Alternatively, the posterior mean estimate of this indicator variable corresponds to the posterior probability of the OU model. These values can be used in the Bayes Factor equation above to compute the Bayes Factor support for either model.





<!--  -->
