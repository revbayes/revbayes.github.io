---
title: Quick Tips for Analyses in RevBayes
subtitle:  
authors:  Heath Lab folks
level: 3
order: 15
prerequisites:
- intro
- mcmc
exclude_files:
index: false
redirect: false
---

{% section Getting Started | getting started %}

Mention introductory tutorials: X,Y, and Z. Links to tutorials, resources, google help group, etc.
How to navigate the website for specific things: documentation, a tutorial on X, bug reporting.

{% section Moves  | moves %}

Given infinite time, any MCMC proposal scheme will converge on the posterior distribution. However, since time is finite, we need to carefully consider the moves we chose on parameters to efficiently approximate the sampling distribution. In this section we will discuss how to identify inefficient moves and poor mixing as well as the components of a move scheme that can be modulated to increase MCMC effectiveness. 


{% subsection Choosing and Optimizing Moves %}

In this section we will discuss the things you will want to consider when choosing moves for your MCMC and how we can optimize those moves to efficiently sample the posterior.

{% subsubsection Choosing the Right Type of Move %} 

For most types of parameters there are a plethora moves implemented in RevBayes. When choosing moves it is important to consider the size and scale of the move relative to the parameter space that they operate upon. For example, let us consider the binomial coin-flipping scenario posed in {% page_ref mcmc/binomial %} tutorial where we are trying to estimate the probability of a coin landing on heads, $p$. In this case we know that the parameter $p$ is bounded between 0 and 1 so we would want to consider moves that efficiently move around this space. The move `mvScale` is a valid option for our parameter $p$ but it won't move around the space very effectively as this move multiplies the current value by some scalar which can often propose values on a different order of magnitude. Alternatively, we could chose `mvSlide` to propose new values within some window from the current value; this move is more better for proposing values between 0 and 1. Since moves often act in drastically different ways and on various scales, it can be useful to use multiple different types of moves on the same parameter to search space efficiently.

{% subsubsection The Size of Moves %}

Although we have chosen an appropriate type of move we still need to consider the size of the move itself. In the case of `mvSlide` the function for the move has the parameter `delta` which is used to specify the size of the window around the current value $p$. In other words, the move proposes a new value $p'$ by choosing a value at random on the interval $(p-\delta,p+\delta)$. Large values of `delta` will result in proposals that often fall outside of the interval $(0,1)$ while too small of a `delta` will cause the MCMC to explore the parameter space slowly and inefficiently. Most moves on continous variables have parameters that control the relative size of the move, in the case of `mvSlide`, the `lambda` parameter controls the size of the sclar. 

We can qualitatively assess the adequacy of size parameters of moves by using `TRACER` to view the trace. In figure __ we can see an example of a well-mixing MCMC, the catapillar-like appearance is a qualitative sign that the parameter is efficiently moving around the parameter space. If the move is too large the trace will look blocky, almost like a city skyline. Large moves often cause proposals to be rejected which is why we see the trace having the same value for many generations. Conversely, if we set too small of a move then we will accept most moves and the trace will appear to slowly meander about parameter values. 

**Figure of 3 trace outputs. One for a good mixing, too small, and too big move**

We can directly see how often proposals on specific moves are accepted or rejected by using the `operatorSummary()` method on an `mcmc` object. 

**Show the output of operatorSummary**

We can see that almost every proposal was accepted for the move with the smallest window size while the largest move rejected most proposals. In general we want a move that isn't too small such that it moves slowly but isn't so large that it rejects most proposals, this is known as the Goldilock's Principle.  ___ found an optimal acceptance ratio of 0.234 for a multivariate target distributions with i.i.d. components. Being able to break the posterior into i.i.d. components is unrealistic for phylogenetic analyses, numerical studies have shown acceptance rates to be robust to this assumption and rates between 0.1 and 0.6 are still reasonably efficient.

{% aside Different Sized Moves on Trees %}
{% endaside %}

{% subsubsection Tuning Moves %}

Luckily, for moves with an adjustable size, we don't need trial and error adjusting of that size argument to achieve a certain acceptance rate. We can tune our moves to achieve a certain acceptance ratio. When creating a move that has an adjustable size, we can set the `tune` arguemnt to `TRUE`, this will adjust the size of the move so the acceptance rate approaches the value given in `tuneTarget`. Before running our mcmc analysis, we can tune our parameters by using the `tuningInterval` argument in  either the `burnin` or `run methods on an `mcmc` object. This means that every `tuninginterval` MCMC generations, it will try to adjust the size of the move to reach the desired tuning interval.

**Example code with screenshots of the tuning before and after**

{% subsection Creating a Move Scheme %}

After we've chosen the moves we want, we need to specify how often those moves get called and how they are scheduled. We can set up a move schedule that determines the order of moves with the `moveschedule` argument of the `mcmc` function. There are 3 different options for `moveschedule`:

- **sequential**:
- **single**:
- **random**: 

**After talking about the different types of schedules, talk about weights** 
Talk about how too low weighting on a particular node can create that skyline effect on the trace of a certain parameter

upweight moves on nodes with a complex parameter space
upweight the tree moves based on the number of taxa
downeight nuisance parameters that aren't interested in 










{% section Clade Constraints  | Clade Constraints %}

{% section Checkpointing  | Checkpointing %}

{% section Multiple Independent Runs | Multiple Independent Runs %}

{% section Metropolis Coupled MCMC | MCMCMC %}

{% section MCMC under the Prior | Sampling under the Prior %}





