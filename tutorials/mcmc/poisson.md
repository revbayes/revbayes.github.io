---
title: Introduction to MCMC
subtitle: A simple Poisson regression example
authors:  Sebastian H&#246;hna
level: 1
order: 0.1
index: true
include_all: false
prerequisites:
- intro
redirect: false
---



Exercise: Poisson Regression Model for Airline Fatalities
=========================================================

This exercise will demonstrate how to approximate the posterior
distribution of some parameters using a simple Metropolis algorithm. The
focus here lies in the Metropolis algorithm, Bayesian inference, and
model specification—but not in the model or the data. After completing
this computer exercise, you should be familiar with the basic Metropolis
algorithm, analyzing output generated from a MCMC algorithm, and
performing standard Bayesian inference.

Model and Data
--------------

We will use the data example from {% cite Gelman2003 %}. A summary is given in
Table [tab:airlineFatalities].

  ------------ ------ ------ ------ ------ ------ ------ ------ ------ ------ ------
  Year           1976   1977   1978   1979   1980   1981   1982   1983   1984   1985
  Fatalities       24     25     31     31     22     21     26     20     16     22
  ------------ ------ ------ ------ ------ ------ ------ ------ ------ ------ ------

  : Airline fatalities from 1976 to 1985. Reproduced from @Gelman2003
  [Table 2.2 on p. 69].<span data-label="tab:airlineFatalities">

These data can be loaded into `RevBayes` by typing:

    observed_fatalities <- v(24,25,31,31,22,21,26,20,16,22)

The model is a [Poisson
regression](http://en.wikipedia.org/wiki/Poisson_regression) model with
parameters $\alpha$ and $\beta$

$$y \sim \text{Poisson}(\exp(\alpha+\beta*x))$$

where $y$ is the number of fatal accidents in year $x$. For simplicity,
we choose uniform priors for $\alpha$ and $\beta$. $$\begin{aligned}
\alpha & \sim & \text{Uniform}(-10,10)\\
\beta &  \sim & \text{Uniform}(-10,10)\end{aligned}$$ The probability
density can be computed in `RevBayes` for a single year by

    dpoisson(y[i],exp(alpha+beta*x[i]))

Problems
--------

### Metropolis Algorithm

The source file for this sub-exercise ‘airline_fatalities_part1.Rev‘.

Let us construct a Metropolis algorithm that simulates from the
posterior distribution $P(\alpha,\beta|y)$. We will construct this
algorithm explicitly, without using the high-level functions existing in
`RevBayes` to perform MCMC. In the next section, we will repeat the same
analysis, this time using the high-level functions. (More background on
MCMC is provided in the [Introduction to Markov Chain Monte Carlo
Algorithms
tutorial](https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/RB_MCMC_Intro_Tutorial/RB_MCMC_Intro_Tutorial.pdf).)

For simplicity of the calculations you can “normalize” the years, e.g.

    x <- 1976:1985 - mean(1976:1985)

A common proposal distribution for $\alpha^{\prime} \sim P(\alpha[i-1])$
is the normal distribution with mean $\mu = \alpha[i-1]$ and standard
deviation $\sigma = \delta_\alpha$:

    alpha_prime <- rnorm(1,alpha[i-1],delta_alpha)

A similar distribution should be used for $\beta^{\prime}$.

    delta_alpha <- 1.0
    delta_beta <- 1.0

After you look at the output of the MCMC (later), play around to find
appropriate values for $\delta_{\alpha}$ and $\delta_{\beta}$.

Now we need to set starting values for the MCMC algorithm. Usually,
these are drawn from the prior distribution, but sometimes if the prior
is very uninformative, then these parameter values result in a
likelihood of 0.0 (or log-likelihood of -Inf).

    alpha[1] <- -0.01     # you can also use runif(-1.0,1.0)
    beta[1] <- -0.01      # you can also use runif(-1.0,1.0)

Next, create some output for our MCMC algorithm. The output will be
written into a file that can be read into `R`or Tracer
{% cite Rambaut2011 %}.

    # create a file output
    write("iteration","alpha","beta",file="airline_fatalities.log")
    write(0,alpha[1],beta[1],file="airline_fatalities.log",append=TRUE)

Note that we need a first iteration with value 0 so that Tracer can load
in this file.

Finally, we set up a ‘for‘ loop over each iteration of the MCMC.

    for (i in 2:10000) {

Within the ‘for‘ loop we propose new parameter values.

        alpha_prime <- rnorm(1,alpha[i-1],delta_alpha)[1]
        beta_prime <- rnorm(1,beta[i-1],delta_beta)[1]

For the newly proposed parameter values we compute the prior ratio. In
this case we know that the prior ratio is 0.0 as long as the new
parameters are within the limits.

        ln_prior_ratio <- dunif(alpha_prime,-10.0,10.0,log=TRUE) + dunif(beta_prime,-10.0,10.0,log=TRUE) - dunif(alpha[i-1],-10.0,10.0,log=TRUE) - dunif(beta[i-1],-10.0,10.0,log=TRUE)

Similarly, we compute the likelihood ratio for each observation.

        ln_likelihood_ratio <- 0
        for (j in 1:x.size() ) {
           lambda_prime <- exp( alpha_prime + beta_prime * x[j] )
           lambda <- exp( alpha[i-1] + beta[i-1] * x[j] )
           ln_likelihood_ratio += dpoisson(observed_fatalities[j],lambda_prime) - dpoisson(observed_fatalities[j],lambda)
        }
        ratio <- ln_prior_ratio + ln_likelihood_ratio

And finally we accept or reject the newly proposed parameter values with
probability ‘ratio‘.

        if ( ln(runif(1)[1]) < ratio) {
           alpha[i] <- alpha_prime
           beta[i] <- beta_prime
        } else {
           alpha[i] <- alpha[i-1]
           beta[i] <- beta[i-1]
        }

Then we log the current parameter values to the file by appending the
file.

        # output to a log-file
        write(i-1,alpha[i],beta[i],file="airline_fatalities.log",append=TRUE)
     }

As a quick summary you can compute the posterior mean of the parameters.

    mean(alpha)
    mean(beta)

You can also load the file into `R`or Tracer to analyze the
output.

In this section of the first exercise we wrote our own little Metropolis
algorithm in `Rev`. This becomes very cumbersome, difficult and slow if
we’ld need to do this for every model. Here we wanted to show you only
the basic principle of any MCMC algorithm. In the next section we will
use the built-in MCMC algorithm of `RevBayes`.

### MCMC analysis using the built-in algorithm in `RevBayes`

Before starting with this new approach it would be good if you either
start a new `RevBayes` session or clear all previous variables using the
‘clear‘ function. Currently we may have some minor memory problems and
if you get stuck it may help to restart `RevBayes`.

We start by loading in the data to `RevBayes`.

    observed_fatalities <- v(24,25,31,31,22,21,26,20,16,22)
    x <- 1976:1985 - mean(1976:1985)

Then we create the parameters with their prior distributions.

    alpha ~ dnUnif(-10,10) 
    beta ~ dnUnif(-10,10)

It may be good to set some reasonable starting values especially if you
choose a very uninformative prior distribution. If by chance you had
starting values that gave a likelihood of -Inf, then `RevBayes` will try
several times to propose new starting values drawn from the prior
distribution.

    # let us use reasonable starting value
    alpha.setValue(0.0)
    beta.setValue(0.0)

Our next step is to set up the moves. Moves are algorithms that propose
new values and know how to reset the values if the proposals are
rejected. We use the same sliding window move as we implemented above by
ourselves.

    mi <- 0
    moves[mi++] = mvSlide(alpha)
    moves[mi++] = mvSlide(beta)

Then we set up the model. This means we create a stochastic variable for
each observation and clamp its value with the observed data.

    for (i in 1:x.size() ) {
        lambda[i] := exp( alpha + beta * x[i] )
        y[i] ~ dnPoisson(lambda[i])
        y[i].clamp(observed_fatalities[i])
    }

We can now create the model by pulling up the model graph from any
variable that is connected to our model graph.

    mymodel = model( alpha )

We also need some monitors that report the current values during the
MCMC run. We create two monitors, one printing all numeric non-constant
variables to a file and one printing some information to the screen.

    monitors[1] = mnModel(filename="output/airline_fatalities.log",printgen=10, separator = "	")
    monitors[2] = mnScreen(printgen=10, alpha, beta)

Finally we create an MCMC object. The MCMC object takes in a model
object, the vector of monitors and the vector of moves.

    mymcmc = mcmc(mymodel, monitors, moves)

On the MCMC object we call its member method ‘run‘ to run the MCMC.

    mymcmc.run(generations=3000)

And now we are done

### Posterior Distribution of $\alpha$ and $\beta$

Report the posterior mean and 95% credible intervals for $\alpha$ and
$\beta$. Additionally, plot the posterior distribution of $\alpha$ and
$\beta$ by plotting a histogram of the samples. Plot the curve of
$m(x) = \text{E}[\exp(\alpha+\beta*x)|y]$ for $x = [1976,1985]$. You can
generate draws from the posterior distribution of the expected value for
a specific $x$ by recording the current expected value at a iteration
$i$ of the Metropolis algorithm
$m_sample(x)[i] = \text{E}[\exp(\alpha[i]+\beta[i]*x)|y]$ and taking
the mean of those samples (‘m(x) = ) afterwards. Since `RevBayes`
provides you with the samples of
$m(x) = \text{E}[\exp(\alpha+\beta*x)|y] = \lambda_x$ you can simply
plot these posterior curves.

Produce a histogram of the predictive distribution of the number of
fatalities in 2014 and estimate the posterior mean. The predictive
distribution can be approximated simultaneously with the Metropolis
algorithm. This means, for any iteration $i$ you simulate draws from the
conditional distribution for $x = 2014$ and the current values of
$\alpha[i]$ and $\beta[i]$.

Estimate the distribution of the mean of the posterior predictive
distribution of the the number of fatalities in 2014. Therefore, let us
denote the expected value of the posterior distribution by $\mu$. Since
we do not know this value $\mu$ exactly, we can follow the Bayesian
approach and associate a probability for each value $m$ as being the
true expected value of the posterior distribution, given the
observations $y$ ($P(m = \mu|y)$). You can approximate this distribution
by recording the expected value for the number of fatalities in 2014
($\text{E}[\exp(\alpha+\beta*x)|y]$) in each iteration $i$ of the
Metropolis algorithm. Plot a histogram of the expected values, compute
the mean of the expected values and compare it to the previously
obtained estimate of the mean of the posterior predictive distribution.

Follow the same approach as for the posterior predictive distribution
for $x = 2014$, but this time for $x = 2016$ and estimate the
probability of no fatality.

Exercise: Poisson Regression Model for Coal-mine Accidents
==========================================================

We will analyze a dataset coal-mine accidents. The values are the dates
of major (more than 10 casualties) coal-mining disasters in the UK from
1851 to 1962.

A model for disasters
---------------------

A common model for the number of events that occur over a period of time
is a Poisson process, in which the numbers of events in disjoint
time-intervals are independent and Poisson-distributed. We will
discretize and look at the yearly number of accidents.

In order to take into account the possible change of rate, we will allow
for different rates before and after year $\theta$, where $\theta$ is
unknown to us. Thus, the observation distribution of our model is
$y_t \sim Poisson(\lambda_t)$ with $t = 1851,\ldots,1962$ and
$$\begin{aligned}
\lambda_t & = & \begin{cases}
\beta & \mbox{if } t < \theta \\
\gamma & \mbox{if } t \geq \theta
\end{cases}\end{aligned}$$ Thus, the rate $\lambda_t$ is defined by
three unknown parameters: $\beta$, $\gamma$ and $\theta$. A hierarchical
choice of priors is given by $$\begin{aligned}
 \eta & \sim & Gamma(10.0;20.0) \\ 
 \beta & \sim & Gamma(2.0;\eta) \\
 \gamma & \sim &Gamma(2.0;\eta) \\
 \theta & \sim & Uniform(1852,\ldots,1962)\end{aligned}$$ which brings
an additional parameter $\eta$ in the model. For $\theta$ we have used a
uniform prior over the years, but excluded year 1851 in order to make
sure at least one year has rate $\beta$. The hierarchical prior carries
the belief that $\beta$ and $\gamma$ are somewhat similar in size, since
they both depend on $\eta$.

The model in `Rev` {#the-model-in-rev .unnumbered}
------------------

We start as usual by loading in the data.

    observed_fatalities <-  v(4, 5, 4, 1, 0, 4, 3, 4, 0, 6, 3, 3, 4, 0, 2, 6, 3, 3, 5, 4, 5, 3, 1, 4, 4, 1, 5, 5, 3, 4, 2, 5, 2, 2, 3, 4, 2, 1, 3, 2, 2, 1, 1, 1, 1, 3, 0, 0, 1, 0, 1, 1, 0, 0, 3, 1, 0, 3, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 2, 1, 0, 0, 0, 1, 1, 0, 2, 3, 3, 1, 1, 2, 1, 1, 1, 1, 2, 3, 3, 0, 0, 0, 1, 4, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1)
    year <- 1851:1962

In `Rev` we specify this prior choice by

    eta ~ dnGamma(10.0,20.0)
    beta ~ dnGamma(2.0,eta)
    gamma ~ dnGamma(2.0,eta)
    theta ~ dnUnif(1852.0,1962.0)

Then we select moves for each parameter. For the rate parameters — which
are defined only on the positive real line — we choose a scaling move.
Only for ‘theta‘ we choose the sliding window proposal.

    mi <- 0
    moves[mi++] = mvScale(eta)
    moves[mi++] = mvScale(beta)
    moves[mi++] = mvScale(gamma)
    moves[mi++] = mvSlide(theta)

Then, we set up the model by computing the conditional rate of the
Poisson distribution, creating random variables for each observation and
attaching (clamping) data to the variables.

    for (i in 1:year.size() ) {
        rate[i] := ifelse(theta > year[i], beta, gamma)
        y[i] ~ dnPoisson(rate[i])
        y[i].clamp(observed_fatalities[i])
    }

Finally, we create the model object from the variables, add some
monitors and run the MCMC algorithm.

    mymodel = model( theta )

    monitors[1] = mnModel(filename="output/coal_accidents.log",printgen=10, separator = "	")
    monitors[2] = mnScreen(printgen=10, eta, lambda, gamma, theta)

    mymcmc = mcmc(mymodel, monitors, moves)

    mymcmc.run(generations=3000)

Batch Mode
----------

If you wish to run this exercise in batch mode, the files are provided
for you.

You can carry out these batch commands by providing the file name when
you execute the ‘rb‘ binary in your unix terminal (this will overwrite
all of your existing run files).

-   ‘\$ rb RevBayes_scripts airline_fatalities_part1.Rev‘\

<!-- -->

-   ‘\$ rb RevBayes_scripts airline_fatalities_part2.Rev‘\

<!-- -->

-   ‘\$ rb RevBayes_scripts coalmine_accidents.Rev‘\

