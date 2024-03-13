---
title: Summary of the Coalescent Analyses
subtitle: Summary of all coalescent analyses run in the preceding exercises
authors: Ronja Billenstein and Sebastian Höhna
level: 9
order: 0.7
prerequisites:
- coalescent
index: false
include_all: false
include_example_output: false
---

{% section Overview %}
After running all the exercises for coalescent analyses, we want to compare all population size plots.

{% section Results %}
{% figure all-outputs-iso %}
<p align="middle">
  <img src="figures/horses_iso_Constant.png" width="32%" />
  <img src="figures/horses_iso_Skyline.png" width="32%" />
  <img src="figures/horses_iso_GMRF.png" width="32%" />
</p>
<p align="middle">
  <img src="figures/horses_iso_HSMRF.png" width="32%" />
  <img src="figures/horses_iso_SkyfishAC.png" width="32%" />
  <img src="figures/horses_iso_piecewise_6diff.png" width="32%" />
</p>
{% figcaption %}
Example output from plotting the output from a choice of coalescent analyses with isochronous data.
The resulting population size trajectories are from (left to right) the constant analysis, the skyline analysis, the GMRF analysis, the HSMRF analysis, the Skyfish analysis and the piecewise analysis with six pieces. The bold line represents the median of the posterior distribution of the population size and the shaded are shows the $95\%$ credible intervals. For the piecewise analysis, the reference skyline result is shown in green and the result of the piecewise analysis is shown in blue.
{% endfigcaption %}
{% endfigure %}
