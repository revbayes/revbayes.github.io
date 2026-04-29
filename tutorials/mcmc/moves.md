---
title: Overview of Moves in MCMC
subtitle: Guidelines and Recommendation
authors:  Sebastian Höhna and Basanta Khakurel
level: 1
order: 0.4
index: true
include_all: false
prerequisites:
- intro
redirect: false
---

Overview
========
{:.section}

This page gives a brief overview of all the moves available in `RevBayes`.


<!-- This is the very first tutorial for you in `RevBayes`. The goal of this set of tutorials is
getting you started and familiar with the basics in `RevBayes`. If you have some familiarity
with `R` or similar software, then this should be straight forward. Nevertheless, we recommend
you to work through these tutorials to learn all the specific quirks of `RevBayes`. -->

# Continuous Variables

## Over the full real line

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvMirror`    | Proposes a new state by reflecting the current value across a specified boundary. |  {% cite Metropolis1953 %} |
 |    `mvRandomDive`    | Proposes a new value by executing a random dive along the real line. |  {% cite Metropolis1953 %} |
 |    `mvSlice`    | Draws a new value from a uniform slice of the probability density. |  {% cite neal2003slice %} |
 |    `mvSlide`    | Symmetric sliding window random walk proposal along the real line. |  {% cite Metropolis1953 %} |
 |    `mvSlideBactrian`    | Sliding window proposal drawing from a bimodal Bactrian distribution to avoid small steps. |  {% cite yang2013searching %} |

 {% endtable %}



## Positive only (or negative only) continuous variables

Positive continuous variables, such as drawn from a *Gamma*, *Exponental* or *Lognormal* distribution, require moves that don't change the sign.
In principle it is possible to apply also moves that work on the full real line, and then let the moves be rejected if they are outside the boundary, but this may be inefficient.

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for positive continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvGammaScale`    | Proposes a scaled value where the scaling factor is drawn from a Gamma distribution. |  {% cite Hastings1970 %} |
 |    `mvLevyJump`    | Proposes a new value by adding a jump drawn from a Lévy process. |  {% cite Hastings1970 %} |
 |    `mvLevyJumpSum`    | Proposes jumps based on a Lévy process for a sum of variables. |  {% cite Hastings1970 %} |
 |    `mvMirrorMultiplier`    | A combination of an asymmetric multiplier proposal and mirroring across boundaries. |  {% cite Hastings1970 %} |
 |    `mvScale`    | Asymmetric multiplier proposal that scales the current value by a random factor. |  {% cite Hastings1970 %} |
 |    `mvScaleBactrian`    | Multiplier proposal using a bimodal Bactrian distribution |  {% cite yang2013searching %} |
 |    `mvScaleBactrianCauchy`    | Multiplier proposal using a heavy-tailed Bactrian Cauchy distribution |  {% cite yang2013searching %} |

 {% endtable %}


## Multiple Continuous Variables


{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for multiple continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvAVMVN`    | Adaptive Variance Multivariate Normal proposal; learns covariance during MCMC. |  {% cite haario2001adaptive %} |
 |    `mvEllipticalSliceSamplingSimple`    | Elliptical slice sampling for strongly correlated Gaussian priors. |  {% cite murray2010elliptical %} |
 |    `mvMultipleElementVectorScale`    | Scales multiple elements of a vector simultaneously by the same factor. |  {% cite Hastings1970 %} |
 |    `mvUpDownScale`    | Scales two variables (or vectors) in opposite directions to preserve their product. |  {% cite Hastings1970 %} |
 |    `mvShrinkExpand`    | Shrinks or expands the variance/scale of a set of continuous variables. |  {% cite Hastings1970 %} |
 |    `mvShrinkExpandScale`    | A scaled version of the shrink-expand proposal. |  {% cite Hastings1970 %} |
 |    `mvSynchronizedVectorFixedSingleElementSlide`    | Slides a single fixed element while synchronizing updates across a vector. |  {% cite Metropolis1953 %} |
 |    `mvUpDownSlide`    | Slides two variables in opposite directions to preserve their sum. |  {% cite Metropolis1953 %} |
 |    `mvUpDownSlideBactrian`    | Up-down slide proposal using a bimodal Bactrian distribution |  {% cite yang2013searching %} |
 |    `mvVectorBinarySwitch`    | Switches binary states (0/1) for elements within a vector. |  {% cite Metropolis1953 %} |
 |    `mvVectorFixedSingleElementSlide`    | Applies a sliding window proposal to a specific, fixed element of a vector. |  {% cite Metropolis1953 %} |
 |    `mvVectorScale`    | Applies an asymmetric multiplier proposal to all elements of a vector. |  {% cite Hastings1970 %} |
 |    `mvVectorSingleElementSlide`    | Randomly selects one element of a vector and applies a sliding window proposal. |  {% cite Metropolis1953 %} |
 |    `mvVectorSlide`    | Applies a symmetric sliding window proposal to all elements of a vector simultaneously. |  {% cite Metropolis1953 %} |
 |    `mvVectorSlideRecenter`    | Slides all vector elements and then recenters them to a specified mean. |  {% cite Metropolis1953 %} |

 {% endtable %}



## GMRF and HSMRF


{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for Gaussian and Horseshoe Markov Random Fields.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvGMRFHyperpriorGibbs`    | Gibbs sampler update for the hyperprior of a Gaussian Markov Random Field. |  {% cite geman1984stochastic %} |
 |    `mvGMRFUnevenGridHyperpriorGibbs`    | Gibbs update for a GMRF hyperprior on an uneven temporal/spatial grid. |  {% cite geman1984stochastic %} |
 |    `mvHSRFHyperpriorsGibbs`    | Gibbs sampler for the global/local hyperpriors of a Horseshoe Markov Random Field |  {% cite Faulkner2020 %} |
 |    `mvHSRFIntervalSwap`    | Swaps local shrinkage parameters between adjacent intervals in an HSMRF. |  {% cite Faulkner2020 %} |
 |    `mvHSRFUnevenGridHyperpriorsGibbs`    | Gibbs update for HSMRF hyperpriors on an uneven grid. |  {% cite Faulkner2020 %} |

 {% endtable %}


## Matrices

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for matrix variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvConjugateInverseWishart`    |                               |  {% cite  %} |
 |    `mvCorrelationMatrixElementSwap`    |                               |  {% cite  %} |
 |    `mvCorrelationMatrixRandomWalk`    |                               |  {% cite  %} |
 |    `mvCorrelationMatrixSingleElementBeta`    |                               |  {% cite  %} |
 |    `mvCorrelationMatrixSpecificElementBeta`    |                               |  {% cite  %} |
 |    `mvCorrelationMatrixUpdate`    |                               |  {% cite  %} |
 |    `mvGraphFlipClique`    |                               |  {% cite  %} |
 |    `mvGraphFlipEdge`    |                               |  {% cite  %} |
 |    `mvGraphShiftEdge`    |                               |  {% cite  %} |
 |    `mvMatrixElementScale`    |                               |  {% cite  %} |
 |    `mvMatrixElementSlide`    |                               |  {% cite  %} |
 |    `mvSymmetricMatrixElementSlide`    |                               |  {% cite  %} |

 {% endtable %}


# Probabilities (numbers bounded between 0 and 1)

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for integer and natural number variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvBetaProbability`    |                               |  {% cite  %} |
 |    `mvProbabilityElementScale`    |                               |  {% cite  %} |

{% endtable %}





# Simplices

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for positive continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvBetaSimplex`    |                               |  {% cite  %} |
 |    `mvDirichletSimplex`    |                               |  {% cite  %} |
 |    `mvElementSwapSimplex`    |                               |  {% cite  %} |
 |    `mvSimplex`    |                               |  {% cite  %} |
 |    `mvSimplexElementScale`    |                               |  {% cite  %} |

 {% endtable %}





# Natural and Integer numbers

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for integer and natural number variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvBinarySwitch`    | Flipping a value from 0 to 1 and vice versa    |  {% cite  %} |
 |    `mvRandomGeometricWalk`    |                               |  {% cite  %} |
 |    `mvRandomIntegerWalk`    |                               |  {% cite  %} |
 |    `mvRandomNaturalWalk`    |                               |  {% cite  %} |

{% endtable %}




# Trees

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for tree variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvBranchLengthScale`    |                               |  {% cite  %} |
 |    `mvCollapseExpandFossilBranch`    |                               |  {% cite  %} |
 |    `mvEmpiricalTree`    |                               |  {% cite  %} |
 |    `mvFNPR`    |                               |  {% cite  %} |
 |    `mvFossilTimeSlideUniform`    |                               |  {% cite  %} |
 |    `mvGPR`    |                               |  {% cite  %} |
 |    `mvIndependentTopology`    |                               |  {% cite  %} |
 |    `mvNNI`    |                               |  {% cite  %} |
 |    `mvNarrow`    |                               |  {% cite  %} |
 |    `mvNodeTimeScale`    |                               |  {% cite  %} |
 |    `mvNodeTimeSlideBeta`    |                               |  {% cite  %} |
 |    `mvNodeTimeSlidePathTruncatedNormal`    |                               |  {% cite  %} |
 |    `mvNodeTimeSlideUniform`    |                               |  {% cite  %} |
 |    `mvNodeTimeSlideUniformAgeConstrained`    |                               |  {% cite  %} |
 |    `mvResampleFBD`    |                               |  {% cite  %} |
 |    `mvRootTimeScaleBactrian`    |                               |  {% cite  %} |
 |    `mvRootTimeSlideUniform`    |                               |  {% cite  %} |
 |    `mvSPR`    |                               |  {% cite  %} |
 |    `mvSubtreeScale`    |                               |  {% cite  %} |
 |    `mvSubtreeSwap`    |                               |  {% cite  %} |
 |    `mvTipTimeSlideUniform`    |                               |  {% cite  %} |
 |    `mvTreeScale`    |                               |  {% cite  %} |

{% endtable %}


## On trees and other variables

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for tree variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvGibbsDrawCharacterHistory`    |                               |  {% cite  %} |
 |    `mvBirthDeathEvent`    |                               |  {% cite  %} |
 |    `mvBirthDeathEventContinuous`    |                               |  {% cite  %} |
 |    `mvBirthDeathEventDiscrete`    |                               |  {% cite  %} |
 |    `mvBirthDeathFromAgeEvent`    |                               |  {% cite  %} |
 |    `mvBurstEvent`    |                               |  {% cite  %} |
 |    `mvCharacterHistory`    |                               |  {% cite  %} |
 |    `mvContinuousEventScale`    |                               |  {% cite  %} |
 |    `mvDiscreteEventCategoryRandomWalk`    |                               |  {% cite  %} |
 |    `mvEventTimeBeta`    |                               |  {% cite  %} |
 |    `mvEventTimeSlide`    |                               |  {% cite  %} |
 |    `mvLayeredScaleProposal`    |                               |  {% cite  %} |
 |    `mvNarrowExchangeRateMatrix`    |                               |  {% cite  %} |
 |    `mvNodeRateTimeSlideBeta`    |                               |  {% cite  %} |
 |    `mvNodeRateTimeSlideUniform`    |                               |  {% cite  %} |
 |    `mvRateAgeBetaShift`    |                               |  {% cite  %} |
 |    `mvRateAgeProposal`    |                               |  {% cite  %} |
 |    `mvRateAgeSubtreeProposal`    |                               |  {% cite  %} |

{% endtable %}


## Species Trees

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for tree variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvSpeciesTreeScale`    |                               |  {% cite  %} |
 |    `mvSpeciesNarrow`    |                               |  {% cite  %} |
 |    `mvSpeciesNodeTimeSlideUniform`    |                               |  {% cite  %} |
 |    `mvSpeciesSubtreeScale`    |                               |  {% cite  %} |
 |    `mvSpeciesSubtreeScaleBeta`    |                               |  {% cite  %} |
 |    `mvSpeciesTreeScale`    |                               |  {% cite  %} |

{% endtable %}


# Unassigned

Weird moves ...

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for positive continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `xxx`    |                               |  {% cite  %} |
 |    `xxx`    |                               |  {% cite  %} |
 |    `xxx`    |                               |  {% cite  %} |
 |    `mvContinuousCharacterDataSlide`    |                               |  {% cite  %} |
 |    `mvDPPAllocateAuxGibbs`    |                               |  {% cite  %} |
 |    `mvDPPGibbsConcentration`    |                               |  {% cite  %} |
 |    `mvDPPValueBetaSimplex`    |                               |  {% cite  %} |
 |    `mvDPPValueScaling`    |                               |  {% cite  %} |
 |    `mvDPPValueSliding`    |                               |  {% cite  %} |
 |    `mvGibbsMixtureAllocation`    |                               |  {% cite  %} |
 |    `mvHomeologPhase`    |                               |  {% cite  %} |
 |    `mvMixtureAllocation`    |                               |  {% cite  %} |
 |    `mvMultiValueEventBirthDeath`    |                               |  {% cite  %} |
 |    `mvMultiValueEventScale`    |                               |  {% cite  %} |
 |    `mvMultiValueEventSlide`    |                               |  {% cite  %} |
 |    `mvMultiValueEventSlide`    |                               |  {% cite  %} |
 |    `mvRJSwitch`    |                               |  {% cite  %} |
 |    `mvUPPAllocation`    |                               |  {% cite  %} |

{% endtable %}
