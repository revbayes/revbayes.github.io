---
title: Postprocessing the Output
subtitle: Plotting Population Size Trajectories and Checking for Convergence
authors: Ronja Billenstein and Sebastian Höhna
level: 9
order: 0.8
prerequisites:
- coalescent
- convergence
index: false
include_all: false
---

{% section Overview %}
This exercise describes how to plot the results from a coalescent analysis with `RevBayes`.
You need the `R` package `RevGadgets`.

{% section Processing Output %}
With `RevGadgets`, you can use the function `processPopSizes` to summarize your output.
Type `?processPopSizes` in `R` to see the parameters of the function.

{% section Plotting Population Size Trajectories %}
For plotting the population size trajectory from your analysis, you need the `plotPopSizes` function.
Type `?plotPopSizes` in `R` to see the parameters of the function.
The input should be a dataframe created with `processPopSizes` with the option `distribution = FALSE`, which is the default.

{% section Checking for Convergence %}
To check for convergence, you can calculate the Kolmogorov-Smirnov test statistic for the population size distributions of your replicates.
By using `processPopSizes` with `distribution = TRUE` and using the respective files of the different runs as input, you get these distributions of your samples at your choice of grid points.
Afterwards, you can use the `ks.test` function to calculate the statistic at each grid point.
{% citet Fabreti2022 %} show that the threshold for the statistic should be $${D}_{crit} = 0.0921$$.
If the statistic is below ${D}_{crit}$, the two sets of samples can be considered to be drawn from the same distribution.
This means that the MCMCs have converged.
In the tutorial {% page_ref convergence %}, you can find more information on the Kolmogorov-Smirnov test.
