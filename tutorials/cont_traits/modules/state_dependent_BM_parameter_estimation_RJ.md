{% section Testing Hypotheses About State-Dependent Rates %}

In the previous section, we learned how to estimate the posterior distribution of state-dependent rate parameters, $\zeta^2$. However, we might also be interested in explicit hypothesis tests about state-dependent rates, especially if the posterior distributions of the focal parameters are overlapping. In this section, we will learn how to use reversible-jump Markov chain Monte Carlo to test the hypotheses that rates of continuous-character evolution depend on the state of the discrete character.

{% subsection Model Selection using Reversible-Jump MCMC %}

To test the hypothesis that rates depend on the discrete state, we imagine two models. The first model, where states do not depend on the discrete character, is the case when $\zeta_i^2 = 1$ for all $i$, _i.e._, when all of the discrete characters confer the same rate of discrete character evolution. The second model corresponds to the state-dependent model described previously.

Obviously, the state-independent model is a special case of the state-dependent model when $\zeta_i^2 = 1$ for all $i$. Unfortunately, because the $\zeta^2_i$ are continuous parameters, a standard Markov chain will never visit states where each value is exactly equal to 1. Fortunately, we can use reversible jump to allow the Markov chain to consider visiting the state-independent model. This involves specifying the prior probability on each of the two models, and providing the prior distribution for $\boldsymbol{\zeta^2}$ for the state-dependent model.

Using rjMCMC allows the Markov chain to visit the two models in proportion to their posterior probability. The posterior probability of model $i$ is simply the fraction of samples where the chain was visiting that model. Because we also specify a prior on the models, we can compute a Bayes factor for the state-dependent model as:

$$
\begin{equation}
    \text{BF}_\text{state-dependent} = \frac{ P( \text{state-dependent} \mid X, Y) }{ P( \text{state-independent} \mid X, Y) } \div \frac{ P( \text{state-dependent}) }{ P( \text{state-independent}) },
\end{equation}
$$

where $P( \text{state-dependent} \mid X, Y)$ and $P( \text{state-dependent})$ are the posterior probability and prior probability of state-dependent rates, respectively.

{% subsubsection Reversible-jump for state-dependent rates %}

To enable rjMCMC, we simply have to place a reversible-jump prior on the relevant parameter, $\boldsymbol{\zeta^2}$. We can modify the prior on `proportional_zeta` so that it takes either a constant value where all rates are equal (`simplex(rep(1, num_disc_states))`), or is drawn from a Dirichlet prior distribution, `dnDirichlet( rep(concentration, num_disc_states) )`. We specify a prior probability on the state-independent model of `p = 0.5`.
```
proportional_zeta ~ dnReversibleJumpMixture( simplex(rep(1,num_disc_states)), dnDirichlet( rep(concentration, num_disc_states) ), p=0.5 )
```
We then provide a reversible-jump proposal on `proportional_zeta` that proposes changes between the two models.
```
moves.append( mvRJSwitch(proportional_zeta, weight=1.0) )
```
Additionally, we provide the normal `mvBetaSimplex` proposal for when the MCMC is visiting a state-dependent model.
```
moves.append( mvBetaSimplex(proportional_zeta, weight=1.0) )
```
We include a variable that has a value of `1` when the chain is visiting a state-dependent model. This will allow us to easily compute the posterior probability of the state-dependent model because we simply need to compute the posterior mean value of this parameter.
```
is_state_dependent := ifelse( proportional_zeta == simplex(rep(1,num_disc_states)), 0.0, 1.0)
```
The fraction of samples for which `is_state_dependent = 1` is the posterior probability of the state-dependent model. Alternatively, the posterior mean estimate of this indicator variable corresponds to the posterior probability of the state-dependent model.
















<!--  -->
