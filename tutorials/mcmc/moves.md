---
title: Overview of Moves in MCMC
subtitle: Guidelines and Recommendation
authors:  Sebastian H&#246;hna
level: 1
order: 0.4
index: true
prerequisites:
- intro
redirect: false
---

Overview
========
{:.section}

This is the very first tutorial for you in `RevBayes`. The goal of this set of tutorials is
getting you started and familiar with the basics in `RevBayes`. If you have some familiarity
with `R` or similar software, then this should be straight forward. Nevertheless, we recommend
you to work through these tutorials to learn all the specific quirks of `RevBayes`.



# Continuous Variables

## Over the full real line

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvMirror`    |                               |  {% cite  %} |
 |    `mvRandomDive`    |                               |  {% cite  %} |
 |    `mvSlice`    |                               |  {% cite  %} |
 |    `mvSlide`    |                               |  {% cite  %} |
 |    `mvSlideBactrian`    |                               |  {% cite  %} |

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
 |    `mvGammaScale`    |                               |  {% cite  %} |
 |    `mvLevyJump`    |                               |  {% cite  %} |
 |    `mvLevyJumpSum`    |                               |  {% cite  %} |
 |    `mvMirrorMultiplier`    |                               |  {% cite  %} |
 |    `mvScale`    |                               |  {% cite  %} |
 |    `mvScaleBactrian`    |                               |  {% cite  %} |
 |    `mvScaleBactrianCauchy`    |                               |  {% cite  %} |

 {% endtable %}


## Multiple Continuous Variables


{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for positive continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvAVMVN`    |                               |  {% cite  %} |
 |    `mvEllipticalSliceSamplingSimple`    |                               |  {% cite  %} |
 |    `mvMultipleElementVectorScale`    |                               |  {% cite  %} |
 |    `mvUpDownScale`    |                               |  {% cite  %} |
 |    `mvShrinkExpand`    |                               |  {% cite  %} |
 |    `mvShrinkExpandScale`    |                               |  {% cite  %} |
 |    `mvUpDownScale`    |                               |  {% cite  %} |
 |    `mvSynchronizedVectorFixedSingleElementSlide`    |                               |  {% cite  %} |
 |    `mvUpDownSlide`    |                               |  {% cite  %} |
 |    `mvUpDownSlideBactrian`    |                               |  {% cite  %} |
 |    `mvVectorBinarySwitch`    |                               |  {% cite  %} |
 |    `mvVectorFixedSingleElementSlide`    |                               |  {% cite  %} |
 |    `mvVectorScale`    |                               |  {% cite  %} |
 |    `mvVectorSingleElementSlide`    |                               |  {% cite  %} |
 |    `mvVectorSlide`    |                               |  {% cite  %} |
 |    `mvVectorSlideRecenter`    |                               |  {% cite  %} |

 {% endtable %}



## GMRF and HSMRF


{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for positive continuous variables.
{% endtabcaption %}

 |   **Move**      |        **Description**        |    **Citation**   |
 |:---------------:|:-----------------------------:|:-----------------:|
 |    `mvGMRFHyperpriorGibbs`    |                               |  {% cite  %} |
 |    `mvGMRFUnevenGridHyperpriorGibbs`    |                               |  {% cite  %} |
 |    `mvHSRFHyperpriorsGibbs`    |                               |  {% cite  %} |
 |    `mvHSRFIntervalSwap`    |                               |  {% cite  %} |
 |    `mvHSRFUnevenGridHyperpriorsGibbs`    |                               |  {% cite  %} |

 {% endtable %}


## Matrices

{% table tab_cont %}
{% tabcaption %}
Moves available in RevBayes for positive continuous variables.
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
 |    `mvAddRemoveTip`    |                               |  {% cite  %} |
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
