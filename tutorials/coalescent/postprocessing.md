---
title: Postprocessing the Output
subtitle: Plotting Population Size Trajectories and Checking for Convergence
authors: Ronja Billenstein and Sebastian Höhna
level: 9
order: 0.8
prerequisites:
- coalescent
index: false
include_all: false
---

{% section Overview %}
This exercise describes how to plot the results from a coalescent analysis with `RevBayes`.
You need the `R` package `RevGadgets` from the `development` branch.

{% section Processing Output %}
With `RevGadgets`, you can use the function `processPopSizes` to summarize your output.
Type `?processPopSizes` in `R` to see the parameters of the function.

{% section Plotting Population Size Trajectories %}
For plotting the population size trajectory from your analysis, you need the `plotPopSizes` function.
Type `?plotPopSizes` in `R` to see the parameters of the function.
The input should be a dataframe created with `processPopSizes` with the option `distribution = FALSE`, which is the default.

{% section Checking for Convergence %}
To check for convergence, you can calculate the Kolmogorov-Smirnov test statistic for the population size distributions.
By using `processPopSizes` with `distribution = TRUE`, you get these distributions at your choice of grid points.
